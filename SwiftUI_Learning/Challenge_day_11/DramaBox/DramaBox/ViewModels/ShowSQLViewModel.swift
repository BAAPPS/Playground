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
    private let cacheFileName = "ShowDetails.json"
    
    private let cache = SaveDataLocallyVM<ShowDetails>(fileName: "ShowDetails.json")

    
    var shows: [ShowDisplayable] = []
      
    // MARK: - Public API
    /// Load shows from Supabase if online, otherwise from local cache
    func loadShows(isOnline: Bool) async {
        if isOnline {
            await loadOnlineShows()
        } else {
            loadCachedShows()
        }
    }
    
    /// Load online shows and update cache
    private func loadOnlineShows() async {
        do {
            let fresh = try await fetchShowsFromSupabase()
            shows = fresh
            try? cache.saveLocally(fresh)
        } catch {
            print("❌ Failed to load online shows:", error.localizedDescription)
            // fallback to cache
            loadCachedShows()
        }
    }
    
    /// Load shows from local cache
    func loadCachedShows() {
        do {
            shows = try cache.loadLocally()
        } catch {
            print("❌ Failed to load cached shows:", error.localizedDescription)
            shows = []
        }
    }
    
    /// Public method to load cached shows
    func loadCachedShowsDirectly() -> [ShowDisplayable] {
           (try? cache.loadLocally()) ?? []
       }
    
 
    // MARK: - Supabase
    
    func fetchShowsFromSupabase() async throws -> [ShowDetails] {
        let response = try await supabaseClient
            .from("show_details")
            .select("*")
            .execute()
        
        return try JSONDecoder().decode([ShowDetails].self, from: response.data)
    }
    
    // MARK: - Upload Shows & Episodes
    
    /// Upload shows and their episodes
    func uploadShows(_ showsWithEpisodes: [(show: ShowDetails.Insert, episodes: [Episode]?)]) async -> Result<String, Error> {
      
        do {
            try await insertShows(showsWithEpisodes)
            return .success("Uploaded \(showsWithEpisodes.count) shows successfully.")
        } catch {
            return .failure(error)
        }
    }
    
    private func insertShows(_ showsWithEpisodes: [(show: ShowDetails.Insert, episodes: [Episode]?)]) async throws {
        for item in showsWithEpisodes {
            let show = item.show
            let episodes = item.episodes
            
            // 1. Check if the show already exists
            let existingShowResponse = try await supabaseClient
                .from("show_details")
                .select("id")
                .eq("title", value: show.title)
                .eq("year", value: show.year)
                .limit(1)
                .execute()
            
            let existingData = existingShowResponse.data
            if let existingShows = try? JSONDecoder().decode([ShowDetailsResponse].self, from: existingData),
               !existingShows.isEmpty {
                print("Show already exists, skipping:", show.title)
                continue
            }
            
            // 2. Insert the show and get its ID
            let insertShowResponse = try await supabaseClient
                .from("show_details")
                .insert([show])
                .select("id")
                .execute()
            
            let insertedData = insertShowResponse.data
            guard let insertedShows = try? JSONDecoder().decode([ShowDetailsResponse].self, from: insertedData),
                  let showId = insertedShows.first?.id else {
                print("Failed to get inserted show ID for:", show.title)
                continue
            }
            
            // 3. Insert episodes efficiently, avoiding duplicates
            if let episodes = episodes, !episodes.isEmpty {
                // Fetch existing episode titles for this show
                let existingEpisodesResponse = try await supabaseClient
                    .from("episodes")
                    .select("title")
                    .eq("show_id", value: showId)
                    .execute()
                
                let existingTitles: [String] = (try? JSONDecoder().decode([[String: String]].self, from: existingEpisodesResponse.data).compactMap { $0["title"] }) ?? []
                
                // Filter out episodes that already exist
                let newEpisodes = episodes.filter { !existingTitles.contains($0.title) }
                
                if !newEpisodes.isEmpty {
                    let episodeInserts = newEpisodes.map { ep in
                        Episode.Insert(
                            show_id: showId,
                            title: ep.title,
                            url: ep.url,
                            thumbnail_url: ep.thumbnailURL
                        )
                    }
                    
                    try await supabaseClient
                        .from("episodes")
                        .insert(episodeInserts)
                        .execute()
                }
            }
        }
    }
}

struct ShowDetailsResponse: Decodable {
    let id: Int
}
