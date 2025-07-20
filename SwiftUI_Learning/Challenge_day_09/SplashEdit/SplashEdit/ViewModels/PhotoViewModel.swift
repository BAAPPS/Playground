//
//  PhotoViewModel.swift
//  SplashEdit
//
//  Created by D F on 7/20/25.
//

import Foundation
import Observation

@Observable
class PhotoViewModel {
    private let client = SupabaseManager.shared.client
    
    var likedPhotos: [PhotoModel] = []
    
    
    func fetchLikedPhoto() async {
        guard let userId = client.auth.currentUser?.id else {
            print("User not logged in")
            return
        }
        
        do {
            let result: [PhotoModel] = try await client
                .from("liked_photo")
                .select()
                .eq("user_id", value: userId)
                .order("created_at", ascending: false)
                .execute()
                .value
            
            self.likedPhotos = result
            
        } catch {
            print("Error fetching liked photos: \(error)")
        }
    }
}
