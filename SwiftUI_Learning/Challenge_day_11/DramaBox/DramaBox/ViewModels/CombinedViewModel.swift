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
    
    /// Fetch merged shows: online (Supabase) + local (TVB cache)
    func fetchMergedShows(isOnline: Bool) async -> [ShowDisplayable] {
        var allShows: [ShowDisplayable] = []
        var seenIDs = Set<String>()
        
        // Load SQL cached shows
        let sqlCached = showSQLVM.loadCachedShowsDirectly()
        allShows.append(contentsOf: sqlCached)
        sqlCached.forEach { seenIDs.insert($0.id) }

        
        // If online, fetch online shows and merge
        if isOnline {
            await showSQLVM.loadShows(isOnline: true) // fetches Supabase and updates cache
            for show in showSQLVM.shows where !seenIDs.contains(show.id) {
                allShows.append(show)
                seenIDs.insert(show.id)
            }
        }
        
        // Add TVB local shows if not duplicate
        let tvbLocalShows = tvbShowsVM.loadShowDetailsLocally() ?? []
        for show in tvbLocalShows where !seenIDs.contains(show.id) {
            allShows.append(show)
            seenIDs.insert(show.id)
        }
        
        print("ℹ️ Merged shows count: \(allShows.count)")
        return allShows
    }
    
    /// Scrape TVB shows, filter new ones, and upload to Supabase
    func scrapeAndUploadNewShows(isOnline: Bool) async -> Result<String, Error> {
        guard isOnline else {
            print("📴 Offline: skipping scrape and upload")
            return .success("Offline mode, skipping upload")
        }
        
        let mergedShows = await fetchMergedShows(isOnline: true)
        let existingIDs = Set(mergedShows.map { $0.id })
        
        // Scrape all show details
        let allScrapedShows = await tvbShowsVM.fetchAllShowDetailsAndSave()
        
        // Filter only new shows
        let newShows = allScrapedShows.filter { !existingIDs.contains($0.id) }
        guard !newShows.isEmpty else {
            return .success("No new shows found, skipping upload.")
        }
        
        print("⬆️ Uploading \(newShows.count) new shows to Supabase")
        
        // Convert to ShowDetails.Insert + episodes
        let showsWithEpisodes = newShows.map { show in
            let insert = ShowDetails.Insert(
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
            return (show: insert, episodes: show.episodes)
        }
        
        return await showSQLVM.uploadShows(showsWithEpisodes)
    }
}

