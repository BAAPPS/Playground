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
    
    /// Fetch all shows (cached + online) for UI consumption
    func fetchMergedShows(isOnline: Bool) async -> [ShowDisplayable] {
        // Load cached SQL shows
        var sqlShows = showSQLVM.loadCachedShowsDirectly()
        
        // Update online shows if online
        if isOnline {
            await showSQLVM.loadOnlineShows() // fetch fresh online shows + cache
            sqlShows = showSQLVM.shows
        }
        
        // 3️⃣ Load local TVB shows
        let tvbLocal = tvbShowsVM.loadShowDetailsLocally() ?? []
        var localDict: [String: ShowDetails] = Dictionary(uniqueKeysWithValues: sqlShows.map { ($0.id, $0) })
        
        for show in tvbLocal {
            let details = show.asShowDetails()
            if let old = localDict[show.id] {
                let mergedEpisodes = (details.episodes ?? []) + (old.episodes ?? [])
                localDict[show.id] = ShowDetails(
                    schedule: details.schedule,
                    subtitle: details.subtitle,
                    genres: details.genres,
                    year: details.year,
                    description: details.description,
                    thumbImageURL: details.thumbImageURL,
                    cast: details.cast,
                    title: details.title,
                    bannerImageURL: details.bannerImageURL,
                    episodes: Array(Set(mergedEpisodes))
                )
            } else {
                localDict[show.id] = details
            }
        }
        
        return Array(localDict.values)
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
