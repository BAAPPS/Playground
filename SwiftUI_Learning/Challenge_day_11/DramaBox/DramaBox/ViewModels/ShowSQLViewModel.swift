//
//  ShowSQLViewModel.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
//

import Foundation
import Supabase

@MainActor
@Observable
class ShowSQLViewModel {
    private let supabaseClient = SupabaseManager.shared.client
    private let cache = SaveDataLocallyVM<ShowDetails>(fileName: "ShowDetails.json")
    
    var shows: [ShowDisplayable] = []
    private let episodeBatchSize = 50
    
    // MARK: - Load Shows
    
    func loadShows(isOnline: Bool) async {
        if isOnline { await loadOnlineShows() }
        else { loadCachedShows() }
    }
    
    private func loadOnlineShows() async {
        do {
            let fresh = try await fetchShowsFromSupabase()
            shows = fresh
            try? cache.saveLocally(fresh)
        } catch {
            print("❌ Failed to load online shows:", error.localizedDescription)
            loadCachedShows()
        }
    }
    
    func loadCachedShows() {
        do {
            shows = try cache.loadLocally()
        } catch {
            shows = []
        }
    }
    
    func loadCachedShowsDirectly() -> [ShowDisplayable] {
        (try? cache.loadLocally()) ?? []
    }
    
    // MARK: - Supabase Fetch
    
    func fetchShowsFromSupabase() async throws -> [ShowDetails] {
        let response = try await supabaseClient
            .from("show_details")
            .select("*")
            .execute()
        return try JSONDecoder().decode([ShowDetails].self, from: response.data)
    }
    
    func fetchEpisodesByShow(showId: Int) async throws -> [String] {
        let response = try await supabaseClient
            .from("episodes")
            .select("title")
            .eq("show_id", value: showId)
            .execute()
        let decoded = try? JSONDecoder().decode([[String: String]].self, from: response.data)
        return decoded?.compactMap { $0["title"] } ?? []
    }
    
    func fetchEpisodesByShowTitle(title: String, year: String) async throws -> [String] {
        let showsResponse = try await supabaseClient
            .from("show_details")
            .select("id")
            .eq("title", value: title)
            .eq("year", value: year)
            .limit(1)
            .execute()
        let decodedShows = try? JSONDecoder().decode([ShowDetails.ShowDetailsResponse].self, from: showsResponse.data)
        guard let showId = decodedShows?.first?.id else { return [] }
        return try await fetchEpisodesByShow(showId: showId)
    }
    
    // MARK: - Upload

    func uploadShows(_ showsWithEpisodes: [(show: ShowDetails.Insert, episodes: [Episode]?)]) async -> Result<String, Error> {
        var uploadedShows = 0
        var uploadedEpisodes = 0

        do {
            // 1️⃣ Fetch all existing shows once
            let existingShows = try await fetchShowsFromSupabase()
            // Map "title-year" to Int id
            var showTitleYearToId: [String: Int] = Dictionary(
                uniqueKeysWithValues: existingShows.compactMap { show -> (String, Int)? in
                    if let id = Int(show.id) {
                        return ("\(show.title)-\(show.year)", id)
                    } else {
                        return nil // skip invalid ids
                    }
                }
            )

            // 2️⃣ Fetch all existing episodes once
            let allEpisodesResponse = try await supabaseClient
                .from("episodes")
                .select("show_id,title")
                .execute()
            
            // Decode into EpisodeRecord (show_id is Int)
            let decodedEpisodes = try JSONDecoder().decode([Episode.EpisodeRecord].self, from: allEpisodesResponse.data)
            var existingEpisodesDict: [Int: Set<String>] = [:]
            for ep in decodedEpisodes {
                existingEpisodesDict[ep.show_id, default: []].insert(ep.title)
            }

            // 3️⃣ Concurrently insert shows + episodes
            await withTaskGroup(of: (Int, Int).self) { group in
                for item in showsWithEpisodes {
                    group.addTask {
                        return await self.insertShowAndEpisodesSafe(
                            item.show,
                            episodes: item.episodes,
                            showTitleYearToId: &showTitleYearToId,
                            existingEpisodesDict: &existingEpisodesDict
                        )
                    }
                }

                for await (sCount, eCount) in group {
                    uploadedShows += sCount
                    uploadedEpisodes += eCount
                }
            }

            return .success("✅ Uploaded \(uploadedShows) shows and \(uploadedEpisodes) episodes successfully (duplicates skipped).")

        } catch {
            return .failure(error)
        }
    }

    // MARK: - Insert (Safe)

    private func insertShowAndEpisodesSafe(
        _ show: ShowDetails.Insert,
        episodes: [Episode]?,
        showTitleYearToId: inout [String: Int],
        existingEpisodesDict: inout [Int: Set<String>]
    ) async -> (Int, Int) {
        
        var insertedShows = 0
        var insertedEpisodes = 0
        let key = "\(show.title)-\(show.year)"
        
        do {
            // 1️⃣ Insert or fetch show
            let showId: Int
            if let existingId = showTitleYearToId[key] {
                showId = existingId
                print("⚠️ Show exists:", show.title)
            } else {
                let insertResponse = try await supabaseClient
                    .from("show_details")
                    .insert([show])
                    .select("id")
                    .execute()
                let inserted = try JSONDecoder().decode([ShowDetails.ShowDetailsResponse].self, from: insertResponse.data)
                guard let id = inserted.first?.id else { return (0, 0) }
                showId = id
                insertedShows = 1
                showTitleYearToId[key] = showId
                print("✅ Inserted show:", show.title)
            }
            
            // 2️⃣ Insert episodes
            guard let episodes = episodes, !episodes.isEmpty else { return (insertedShows, 0) }
            let existingTitles = existingEpisodesDict[showId] ?? []
            let newEpisodes = episodes.filter { !existingTitles.contains($0.title) }
            
            if !newEpisodes.isEmpty {
                let batchSize = 50
                for batchStart in stride(from: 0, to: newEpisodes.count, by: batchSize) {
                    let batch = Array(newEpisodes[batchStart..<min(batchStart + batchSize, newEpisodes.count)])
                    let inserts = batch.map { Episode.Insert(show_id: showId, title: $0.title, url: $0.url, thumbnail_url: $0.thumbnailURL) }
                    
                    do {
                        try await supabaseClient.from("episodes").insert(inserts).execute()
                        insertedEpisodes += inserts.count
                    } catch {
                        print("⚠️ Some episodes may be duplicates for show:", show.title)
                    }
                }
                existingEpisodesDict[showId, default: []].formUnion(newEpisodes.map { $0.title })
            }
            
        } catch {
            print("❌ Error inserting show/episodes:", show.title, "-", error.localizedDescription)
        }
        
        return (insertedShows, insertedEpisodes)
    }

}

