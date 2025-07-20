//
//  TinderStackButtonsVM.swift
//  SplashEdit
//
//  Created by D F on 7/20/25.
//

import Foundation
import Observation

@Observable
class TinderStackButtonsVM {
    var authVM: SupabaseAuthViewModel
    var photos: [UnsplashPhotosModel] = []
    var currentIndex: Int = 0
    
    var isLiked: Bool = false
    var showHeartOverlay: Bool = false
    
    init(authVM: SupabaseAuthViewModel, photos: [UnsplashPhotosModel]) {
        self.authVM = authVM
        self.photos = photos
    }
    
    var currentPhoto: UnsplashPhotosModel? {
        guard currentIndex >= 0 && currentIndex < photos.count else {
            return nil
        }
        return photos[currentIndex]
    }
    
    func updateLikeStatus() async {
        guard let photo = currentPhoto else {return}
        let liked = await authVM.hasUserLikedPhoto(unsplashID: photo.id)
        await MainActor.run {
            self.isLiked = liked
        }
    }
    
    func likeCurrentPhotoAsync() async {
        guard let userId = authVM.currentUser?.id, let username = authVM.currentUser?.username, let photo = currentPhoto else
        {
            print("User not logged in or photo unavailable")
            return
        }
        
        let photoModel = PhotoModel(
            id: nil,  // no id yet,  DB will generate
            user_id: userId,
            unsplash_id: photo.id,  // Unsplash ID string
            original_url: photo.urls.regular,
            liked_by: username,
            created_at: nil    // no need to send timestamp
        )
        
        let liked = await authVM.toggleLike(for: photoModel)
        
        await MainActor.run {
            isLiked = liked
            showHeartOverlay = liked
        }
        
        try? await Task.sleep(nanoseconds: 700_000_000)
        
        await MainActor.run {
            showHeartOverlay = false
        }
    }
    
    func moveToNextPhoto() async {
        if currentIndex < photos.count - 1 {
            currentIndex += 1
            await updateLikeStatus()
        }
    }
    
    func moveToPreviousPhoto() async {
        if currentIndex > 0 {
            currentIndex -= 1
            await updateLikeStatus()
        }
    }
}
