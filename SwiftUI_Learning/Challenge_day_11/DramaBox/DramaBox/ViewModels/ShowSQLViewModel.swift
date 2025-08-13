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
    var errorMessage: String? = nil
    var successMessage: String? = nil
    
    private let supabaseClient = SupabaseManager.shared.client
    
    func uploadShows(from jsonString: String) async {
        self.errorMessage = nil
        self.successMessage = nil
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            self.errorMessage = "Invalid JSON string encoding."
            return
        }
        
        do {
            let decoder = JSONDecoder()
            // Decode Insert structs (snake_case keys expected)
            let shows = try decoder.decode([ShowDetails.Insert].self, from: jsonData)
            
            try await insertShows(shows)
            
            self.successMessage = "Uploaded \(shows.count) shows successfully."
            
        } catch {
            self.errorMessage = "Upload failed: \(error.localizedDescription)"
            print("Decoding/upload error:", error)
        }
    }
    
    func insertShowWithEpisodes(_ show: ShowDetails) async throws {
        // Insert the show first
        let showInsert = ShowDetails.Insert(
            title: show.title,
            subtitle: show.subtitle,
            schedule: show.schedule,
            genres: show.genres,
            cast: show.cast,
            year: show.year,
            description: show.description,
            thumb_image_url: show.thumbImageURL,
            banner_image_url: show.bannerImageURL
        )

        let showResponse = try await supabaseClient
            .from("show_details")
            .insert([showInsert])
            .select("id")
            .execute()

        let data = showResponse.data
        guard
            let insertedShows = try? JSONDecoder().decode([ShowDetailsResponse].self, from: data),
            let insertedShow = insertedShows.first
        else {
            throw NSError(domain: "Supabase", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to insert show"])
        }

        let showId = insertedShow.id

        // Prepare episodes to insert
        let episodeInserts = show.episodes.compactMap { episode -> Episode.Insert? in
            guard let thumb = episode.thumbnailURL else { return nil }
            return Episode.Insert(show_id: showId, title: episode.title, url: episode.url, thumbnail_url: thumb)
        }

        if !episodeInserts.isEmpty {
            try await supabaseClient
                .from("episodes")
                .insert(episodeInserts)
                .execute()
        }
    }

    
    private func insertShows(_ shows: [ShowDetails.Insert]) async throws {
        for show in shows {
            // Check if show exists
            let existingResponse = try await supabaseClient
                .from("show_details")
                .select("id")
                .eq("title", value: show.title)
                .eq("year", value: show.year)
                .limit(1)
                .execute()
            
            let data = existingResponse.data
            
            if let existingShows = try? JSONDecoder().decode([ShowDetailsResponse].self, from: data),
               !existingShows.isEmpty {
                print("Show already exists, skipping insert:", show.title)
                continue
            }
            
            // Insert show
            let response = try await supabaseClient
                .from("show_details")
                .insert([show])
                .select("id")
                .execute()
            
            let responseData = response.data
            let insertedShows = try JSONDecoder().decode([ShowDetailsResponse].self, from: responseData)
            
            guard let insertedShow = insertedShows.first else {
                throw NSError(domain: "Supabase", code: 0, userInfo: [NSLocalizedDescriptionKey: "Insert response array empty"])
            }
            
//            let insertedId = insertedShow.id
        }
    }
}

struct ShowDetailsResponse: Decodable {
    let id: Int
}
