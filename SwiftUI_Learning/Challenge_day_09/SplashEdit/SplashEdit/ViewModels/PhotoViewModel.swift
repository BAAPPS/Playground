//
//  PhotoViewModel.swift
//  SplashEdit
//
//  Created by D F on 7/20/25.
//

import Foundation
import Observation

struct LikedPhotoIDOnly: Decodable {
    let id: UUID
}


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
    
    func fetchLikedPhotoID(userId: UUID, unsplashID: String) async throws -> UUID? {
        let results: [LikedPhotoIDOnly] = try await client
            .from("liked_photo")
            .select("id")
            .eq("user_id", value: userId)
            .eq("unsplash_id", value: unsplashID)
            .limit(1)
            .execute()
            .value

        return results.first?.id
    }

}
