//
//  ArtistViewModel.swift
//  HKPopTracks
//
//  Created by D F on 6/29/25.
//

import Foundation

@Observable
class ArtistViewModel: Identifiable{
    var artists: [ArtistModel] = []
    var isLoading = false
    var errorMessage: String?
    

    func fetchArtistByNames(_ names: [String]) async -> [ArtistModel]{
        self.isLoading = true
        self.errorMessage = nil
        var allArtists: [ArtistModel] = []
        
        
        await withTaskGroup(of: [ArtistModel].self) { group in
            for name in names{
                group.addTask{
                    
                    do {
                        let escapedTerm = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        let url = "https://itunes.apple.com/search?term=\(escapedTerm)&entity=musicArtist&attribute=artistTerm&country=HK"
                        let response: ArtistModelResponse = try await NetworkFetcher.fetchAsync(from: url)
                        return response.results
                    } catch {
                        print("Fetch error: \(error.localizedDescription)")
                        return []
                    }
                    
                }
            }
            
            for await result in group{
                allArtists += result
            }
            
        }
       
        let uniqueArtistsSet = Set(allArtists)
        let uniqueArtists = Array(uniqueArtistsSet).sorted {$0.artistName < $1.artistName}
        self.artists = uniqueArtists
        self.isLoading = false
        return self.artists
        
    }
    
    
    func fetchArtistByName(term: String) async {
        isLoading = true
        errorMessage = nil
        
        let escapedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "https://itunes.apple.com/search?term=\(escapedTerm)&entity=musicArtist&attribute=artistTerm&country=HK"
        
        print("Final URL: \(url)")
        
        do {
            let response: ArtistModelResponse = try await NetworkFetcher.fetchAsync(from: url)
            artists = response.results
        } catch {
            errorMessage =  error.localizedDescription
            print("Fetch error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    


    func fetchArtist() async{
        let artistNames = [
            "Andy Lau", "Eason Chan", "G.E.M.", "Joey Yung",
            "Sammi Cheng", "Leon Lai", "Jacky Cheung", "Jordan Chan"
        ]
        let fetchedArtists = await fetchArtistByNames(artistNames)
        artists = fetchedArtists
    }


}
