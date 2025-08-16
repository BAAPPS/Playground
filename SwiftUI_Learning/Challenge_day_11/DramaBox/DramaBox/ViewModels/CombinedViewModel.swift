//
//  CombinedViewModel.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
//

import Foundation
import Supabase

@MainActor
@Observable
class CombinedViewModel {
    let tvbShowsVM = TVBShowsVM()
    let showSQLVM = ShowSQLViewModel()
    
    func fetchMergedShows(isOnline: Bool) async -> [ShowDisplayable] {
        let localShows = tvbShowsVM.loadShowDetailsLocally() ?? []
        
        guard isOnline else {
            print("📴 Offline mode: loaded \(localShows.count) local shows")
            return localShows
        }
        
        let onlineShows = (try? await showSQLVM.fetchShowsFromSupabase()) ?? []
        print("✅ Loaded \(onlineShows.count) shows from Supabase")
        
        var allShows: [ShowDisplayable] = []
        var seenIDs: Set<String> = []
        
        // Add online first
        for show in onlineShows {
            allShows.append(show)
            seenIDs.insert(show.id)
        }
        
        // Add local only if ID is truly unique
        for show in localShows {
            if !seenIDs.contains(show.id) {
                allShows.append(show)
                seenIDs.insert(show.id)
            }
        }
        
        print("ℹ️ Merged shows count: \(allShows.count)")
        return allShows
    }

 
    
        func scrapeAndUploadNewShows(isOnline: Bool) async -> Result<String, Error>{
            guard isOnline else {
                   print("📴 Offline: skipping scrape and upload")
                   return .success("Offline mode, skipping upload")
               }
    
               // Load merged shows to know which IDs already exist
               let mergedShows = await fetchMergedShows(isOnline: true)
    
            let existingIDs = Set(mergedShows.map { $0.id })
    
    
            // Scrape all show details
            let allScrapedShows = await tvbShowsVM.fetchAllShowDetailsAndSave()
    
            // Filter only truly new shows
            let newShows = allScrapedShows.filter { !existingIDs.contains($0.id) }
    
            guard !newShows.isEmpty else {
                return .success("No new shows found, skipping scrape.")
            }
    
            print("⬆️ Uploading \(newShows.count) new shows to Supabase")
    
    
            // Prepare tuple of show + episodes
            let showsWithEpisodes = newShows.map { show in
                let showInsert = ShowDetails.Insert(
                    title: show.title,
                    subtitle: show.subtitle ?? "",
                    schedule: show.schedule,
                    genres: show.genres,
                    cast: show.cast,
                    year: show.year,
                    description: show.description,
                    thumb_image_url: show.thumbImageURL,
                    banner_image_url: show.bannerImageURL
                )
                return (show: showInsert, episodes: show.episodes)
            }
    
            // Upload all shows + episodes
            return await showSQLVM.uploadShows(showsWithEpisodes)
        }
}
