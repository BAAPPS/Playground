//
//  CombinedViewModel.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
//

// CombinedViewModel.swift

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
        do {
            // Fetch all show details by scraping
            await tvbShowsVM.fetchAllShowDetailsAndSave()
            
            // Load locally saved ShowDetails
            guard let shows = tvbShowsVM.loadShowDetailsLocally() else {
                errorMessage = "No shows saved locally after scraping."
                return
            }
            
           
            let showInserts = shows.map { show in
                ShowDetails.Insert(
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
            }
            
    
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(showInserts)
            
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                errorMessage = "Failed to convert encoded data to String."
                return
            }
            
            // Upload to Supabase
            await showSQLVM.uploadShows(from: jsonString)
            
            if let success = showSQLVM.successMessage {
                successMessage = success
            } else if let error = showSQLVM.errorMessage {
                errorMessage = error
            }
            
        } catch {
            errorMessage = "Error during scraping or upload: \(error.localizedDescription)"
        }
    }
}

