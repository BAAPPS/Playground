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
        var allShows: [ShowDisplayable] = []
        var seenIDs = Set<String>()
        
        let sqlCached = showSQLVM.loadCachedShowsDirectly()
        allShows.append(contentsOf: sqlCached)
        sqlCached.forEach { seenIDs.insert($0.id) }
        
        if isOnline {
            await showSQLVM.loadShows(isOnline: true)
            for show in showSQLVM.shows where !seenIDs.contains(show.id) {
                allShows.append(show)
                seenIDs.insert(show.id)
            }
        }
        
        let tvbLocal = tvbShowsVM.loadShowDetailsLocally() ?? []
        for show in tvbLocal where !seenIDs.contains(show.id) {
            allShows.append(show)
            seenIDs.insert(show.id)
        }
        
        print("ℹ️ Merged shows count: \(allShows.count)")
        return allShows
    }
    
    func scrapeAndUploadNewShows(isOnline: Bool) async -> Result<String, Error> {
        guard isOnline else { return .success("📴 Offline, skipping upload") }
        
        let existingShows = await fetchMergedShows(isOnline: true)
        let existingIDs = Set(existingShows.map { $0.id })
        
        let allScraped = await tvbShowsVM.fetchAllShowDetailsAndSave()
        let newShows = allScraped.filter { !existingIDs.contains($0.id) }
        let existingScraped = allScraped.filter { existingIDs.contains($0.id) }
        
        var resultMessage = ""
        
        // Upload new shows + episodes
        if !newShows.isEmpty {
            let inserts = newShows.map { show in
                (show: ShowDetails.Insert(
                    title: show.title,
                    subtitle: show.subtitle ?? "",
                    schedule: show.schedule,
                    genres: show.genres,
                    cast: show.cast,
                    year: show.year,
                    description: show.description,
                    thumb_image_url: show.thumbImageURL,
                    banner_image_url: show.bannerImageURL
                ), episodes: show.episodes)
            }
            let result = await showSQLVM.uploadShows(inserts)
            switch result {
            case .success(let msg): resultMessage += msg + "\n"
            case .failure(let err): resultMessage += "Failed: \(err)\n"
            }
        }
        
        // Update episodes for existing shows
        for show in existingScraped {
            let existingTitles = try? await showSQLVM.fetchEpisodesByShowTitle(title: show.title, year: show.year)
            let missingEpisodes = (show.episodes ?? []).filter { !(existingTitles ?? []).contains($0.title) }
            if !missingEpisodes.isEmpty {
                let result = await showSQLVM.uploadShows([
                    (
                        show: ShowDetails.Insert(
                            title: show.title,
                            subtitle: show.subtitle ?? "",
                            schedule: show.schedule,
                            genres: show.genres,
                            cast: show.cast,
                            year: show.year,
                            description: show.description,
                            thumb_image_url: show.thumbImageURL,
                            banner_image_url: show.bannerImageURL
                        ),
                        episodes: missingEpisodes
                    )
                ])
                
                switch result {
                case .success(let message):
                    print("⬆️ Upload succeeded:", message)
                case .failure(let error):
                    print("❌ Upload failed:", error.localizedDescription)
                }
                
                
            }
        }
        
        return .success(resultMessage.isEmpty ? "No new shows or episodes" : resultMessage)
    }
}
