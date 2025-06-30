//
//  ArtistDetailViewModel.swift
//  HKPopTracks
//
//  Created by D F on 6/29/25.
//

import Foundation


@Observable
class ArtistDetailViewModel: Identifiable{
    var artistDetailsById: [Int: [ArtistDetailModel]] = [:]
    var isLoading = false
    var errorMessage: String?
    
    
    func fetchArtistDetailsById(for artistId: Int) async {
        isLoading = true
        errorMessage = nil
        
        print("Fetching details for artistId: \(artistId)")
        
        let urlString = "https://itunes.apple.com/lookup?id=\(artistId)&entity=song&limit=20"
        
        do {
            let response: ArtistDetailResponse = try await NetworkFetcher.fetchAsync(from: urlString)
            artistDetailsById[artistId] = response.results
            
            let tracks = response.results.filter { $0.wrapperType == "track" }
            print("Fetched \(tracks.count) tracks for artistId: \(artistId): \(tracks.map { $0.trackName ?? "Unknown" })")
            
        } catch {
            errorMessage = error.localizedDescription
            print("Fetch error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }

    
    
    func getDetails(for artistId: Int) -> [ArtistDetailModel] {
        artistDetailsById[artistId] ?? []
    }
    
}


