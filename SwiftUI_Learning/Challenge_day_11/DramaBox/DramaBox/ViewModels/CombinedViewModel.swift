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
    
    func fetchMergedShows() async -> [ShowDetails]{
        var allShows: [ShowDetails] = []
        var seenIDs: Set<String> = []
        
        
        let onlineShows = (try? await showSQLVM.fetchShowsFromSupabase()) ?? []
        allShows.append(contentsOf: onlineShows)
        seenIDs.formUnion(onlineShows.map{ $0.id})
        print("✅ Loaded \(onlineShows.count) shows from Supabase")
        
        
        // 2. Load local JSON shows
        let localShows = tvbShowsVM.loadShowDetailsLocally() ?? []
        for show in localShows {
            if !seenIDs.contains(show.id) {
                allShows.append(show)
                seenIDs.insert(show.id)
            }
        }
        print("ℹ️ Loaded \(localShows.count) shows locally, merged total: \(allShows.count)")
        
        return allShows
        
    }
    
    func scrapeAndUploadNewShows() async -> Result<String, Error>{
        // Load merged shows to know which IDs already exist
        let mergedShows = await fetchMergedShows()
        
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
                subtitle: show.subtitle,
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
