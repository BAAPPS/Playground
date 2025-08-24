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
    
    var shows: [ShowDetails] = []
    private let episodeBatchSize = 50
    
    // MARK: - Load Shows
    
    func loadShows(isOnline: Bool) async {
        if isOnline { await loadOnlineShows() }
        else { loadCachedShows() }
    }
    
    private func loadOnlineShows() async {
        do {
            let fresh = try await fetchShowsFromSupabase()
            let cached = loadCachedShowsDirectly()

            var localDict = Dictionary(uniqueKeysWithValues: cached.map { ($0.id, $0) })


            // Merge fresh shows into cached
            for newShow in fresh {
                if let oldShow = localDict[newShow.id] {
                    // Replace only if different
                    if oldShow != newShow {
                        localDict[newShow.id] = newShow
                    }


                } else {
                    // New show → add it
                    localDict[newShow.id] = newShow
                }
            }

            shows = Array(localDict.values)
            try? cache.saveLocally(shows)
            
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
    
    func loadCachedShowsDirectly() -> [ShowDetails] {
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

    @MainActor
    private func updateShowIdDict(_ dict: inout [String: Int], key: String, id: Int) {
        dict[key] = id
    }

    @MainActor
    private func updateEpisodeDict(_ dict: inout [Int: Set<String>], showId: Int, titles: [String]) {
        dict[showId, default: []].formUnion(titles)
    }
    
    @MainActor
    func uploadShows(_ showsWithEpisodes: [(show: ShowDetails.Insert, episodes: [Episode]?)]) async -> Result<String, Error> {
        var uploadedShows = 0
        var uploadedEpisodes = 0

        do {
            // 1️⃣ Fetch existing shows
            let existingShows = try await fetchShowsFromSupabase()
            var showTitleYearToId: [String: Int] = Dictionary(
                uniqueKeysWithValues: existingShows.compactMap { show in
                    guard let id = Int(show.id) else { return nil }
                    return ("\(show.title)-\(show.year)", id)
                }
            )

            // 2️⃣ Fetch existing episodes
            let allEpisodesResponse = try await supabaseClient
                .from("episodes")
                .select("show_id,title")
                .execute()
            let decodedEpisodes = try JSONDecoder().decode([Episode.EpisodeRecord].self, from: allEpisodesResponse.data)
            var existingEpisodesDict: [Int: Set<String>] = [:]
            for ep in decodedEpisodes {
                existingEpisodesDict[ep.show_id, default: []].insert(ep.title)
            }

            // 3️⃣ Insert concurrently
            await withTaskGroup(of: (Int, Int).self) { group in
                for showItem in showsWithEpisodes {
                    group.addTask {
                        await self.insertShowAndEpisodesTask(showItem, showDict: &showTitleYearToId, episodeDict: &existingEpisodesDict)
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
    
    @MainActor
    private func insertShowAndEpisodesTask(
        _ showItem: (show: ShowDetails.Insert, episodes: [Episode]?),
        showDict: inout [String: Int],
        episodeDict: inout [Int: Set<String>]
    ) async -> (Int, Int) {
        var insertedShows = 0
        var insertedEpisodes = 0
        do {
            let key = "\(showItem.show.title)-\(showItem.show.year)"
            let showId: Int

            // Insert or fetch show
            if let existingId = showDict[key] {
                showId = existingId
            } else {
                let insertResponse = try await supabaseClient
                    .from("show_details")
                    .insert([showItem.show])
                    .select("id")
                    .execute()
                let inserted = try JSONDecoder().decode([ShowDetails.ShowDetailsResponse].self, from: insertResponse.data)
                guard let id = inserted.first?.id else { return (0,0) }
                showId = id
                insertedShows = 1
                updateShowIdDict(&showDict, key: key, id: id)
            }

            // Insert episodes
            guard let episodes = showItem.episodes, !episodes.isEmpty else { return (insertedShows, 0) }
            let existingTitles = episodeDict[showId] ?? []
            let newEpisodes = episodes.filter { !existingTitles.contains($0.title) }

            if !newEpisodes.isEmpty {
                let batchSize = 50
                for batchStart in stride(from: 0, to: newEpisodes.count, by: batchSize) {
                    let batch = Array(newEpisodes[batchStart..<min(batchStart + batchSize, newEpisodes.count)])
                    let inserts = batch.map { Episode.Insert(show_id: showId, title: $0.title, url: $0.url, thumbnail_url: $0.thumbnailURL) }
                    try await supabaseClient.from("episodes").insert(inserts).execute()
                    insertedEpisodes += inserts.count
                }
                updateEpisodeDict(&episodeDict, showId: showId, titles: newEpisodes.map { $0.title })
            }

        } catch {
            print("❌ Error uploading show \(showItem.show.title):", error)
        }

        return (insertedShows, insertedEpisodes)
    }


}

