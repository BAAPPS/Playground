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
    
    var errorMessage: String? = nil
    var successMessage: String? = nil
    
    func scrapeAndUploadShows() async {
        // Fetch all show details
        await tvbShowsVM.fetchAllShowDetailsAndSave()
        
        guard let shows = tvbShowsVM.loadShowDetailsLocally() else {
            errorMessage = "No shows saved locally."
            return
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
        await showSQLVM.uploadShows(showsWithEpisodes)
        
        if let success = showSQLVM.successMessage {
            successMessage = success
        } else if let error = showSQLVM.errorMessage {
            errorMessage = error
        }
        
    }
}
