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
    
    func scrapeAndUploadShows() async -> Result<String, Error>{
        do{
       
            let savedShows = tvbShowsVM.loadShowDetailsLocally() ?? []
            
            //  If there are already shows saved, skip scraping
            if !savedShows.isEmpty {
                return .success("All shows already exist locally, skipping scrape.")
            }
            
            // Otherwise, fetch and save new show details
            let shows = await tvbShowsVM.fetchAllShowDetailsAndSave()
            
            guard !shows.isEmpty else {
                throw NSError(domain: "CombinedViewModel", code: 1, userInfo: [
                    NSLocalizedDescriptionKey:"No shows saved locally"
                ])
            }
            
            // Prepare tuple of show + episodes
            let showsWithEpisodes = shows.map { show in
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
        }catch {
            return .failure(error)
        }
        
    }
}
