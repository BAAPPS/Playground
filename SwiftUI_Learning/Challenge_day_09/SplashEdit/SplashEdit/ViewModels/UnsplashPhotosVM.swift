//
//  UnsplashPhotosVM.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import Foundation
import Observation

@Observable
class UnsplashPhotosVM: Identifiable {
    var photos: [UnsplashPhotosModel] = []
    var isLoading = false
    var errorMessage:String?
    
    private let apiKey = SecretsManager.getValue(for: "UNSPLASH_KEY")
    
    func fetchPhotos() async {
          isLoading = true
          errorMessage = nil

          let urlString = "https://api.unsplash.com/photos/?client_id=\(apiKey)&per_page=15"
          
          do {
              let result: [UnsplashPhotosModel] = try await NetworkFetcher.fetchAsync(from: urlString)
              self.photos = result
          } catch {
              self.errorMessage = error.localizedDescription
              print("❌ Fetch failed: \(error)")
          }
          
          isLoading = false
      }
    
}

