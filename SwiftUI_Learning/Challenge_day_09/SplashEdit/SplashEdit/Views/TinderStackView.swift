//
//  TinderStackView.swift
//  SplashEdit
//
//  Created by D F on 7/18/25.
//

import SwiftUI




struct TinderStackView: View {
    var authVM: SupabaseAuthViewModel
    
    @Binding var photos: [UnsplashPhotosModel]
    let parentSize: CGSize
    
    // Track which photo is selected for detailed modal
    @State private var selectedPhoto: UnsplashPhotosModel? = nil
    
    @State private var currentIndex = 0
    
    // Track if current photo is liked
    @State private var isLiked = false
    // Track showing big heart overlay briefly
    @State private var showHeartOverlay = false
    
    
    var likeButtonLabel: some View {
        Image(systemName: isLiked ? "heart.fill" : "heart")
            .font(.largeTitle)
            .padding()
            .background(Color(hex:"#364f56"))
            .clipShape(Circle())
            .foregroundColor(isLiked ? .red : .white)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 3)
            .offset(x: -7, y: -10)
    }
    
    func updateLikeStatus() async {
        guard currentIndex >= 0 && currentIndex < photos.count else { return }
        let photo = photos[currentIndex]
        let liked = await authVM.hasUserLikedPhoto(unsplashID: photo.id)
        await MainActor.run {
            isLiked = liked
        }
    }
    
    
    private func likeCurrentPhotoAsync() async {
        guard currentIndex >= 0 && currentIndex < photos.count else { return }
        guard let userId = authVM.currentUser?.id,
              let username = authVM.currentUser?.username else {
            print("User not logged in or username missing")
            return
        }
        let photo = photos[currentIndex]
        
        let photoModel = PhotoModel(
            id: nil,  // no id yet,  DB will generate
            user_id: userId, 
            unsplash_id: photo.id,                      // Unsplash ID string
            original_url: photo.urls.regular,
            liked_by: username,
            created_at: nil                           // no need to send timestamp
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
    
    var body: some View {
        ZStack {
            ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                if currentIndex >= 0 && currentIndex < photos.count {
                    PhotoSwipeView(photo: photos[currentIndex]) { direction in
                        
                        if direction == .left && currentIndex < photos.count - 1 {
                            currentIndex += 1
                            Task { await updateLikeStatus() }
                        } else if direction == .right && currentIndex > 0 {
                            currentIndex -= 1
                            Task { await updateLikeStatus() }
                        }
                    }
                    .frame(width: parentSize.width, height: parentSize.height)
                    .zIndex(Double(index))
                    .overlay(
                        index == photos.indices.last ?
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                
                                VStack{
                                    Button {
                                        Task {
                                            await likeCurrentPhotoAsync()
                                        }
                                    } label: {
                                        likeButtonLabel
                                    }
                                    Button {
                                        selectedPhoto = photos[currentIndex]
                                        
                                        print(selectedPhoto?.urls.regular ?? "none")
                                        
                                        
                                    } label: {
                                        Image(systemName: "info.circle")
                                            .font(.title)
                                            .padding()
                                            .background(Color(hex:"#364f56"))
                                            .clipShape(Circle())
                                            .foregroundColor(.white)
                                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 3)
                                    }
                                    .padding(.trailing, 20)
                                    .padding(.bottom, 40)
                                }
                            }
                        }
                            .offset(x: 10)
                        : nil
                    )
                    .overlay {
                        if showHeartOverlay {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.red)
                                .opacity(0.8)
                                .transition(.scale)
                        }
                    }
                    
                } else {
                    Text("No more photos")
                }
            }
        }
        .task{
            await updateLikeStatus()
        }
        // Present full screen modal when selectedPhoto is set
        .fullScreenCover(item: $selectedPhoto) { photo in
            PhotoDetailView(photo: photo)
            
        }
        
    }
    
    func remove(_ photo: UnsplashPhotosModel) {
        photos.removeAll { $0.id == photo.id }
    }
}



#Preview {
    @Previewable  @State var mockPhotos = MockData.mockPhotos
    
    PreviewBindingsView(mockPhotos) { bindingPhotos in
        
        TinderStackView(authVM: SupabaseAuthViewModel(), photos: bindingPhotos, parentSize: CGSize(width: 375, height: 600))
    }
    
}
