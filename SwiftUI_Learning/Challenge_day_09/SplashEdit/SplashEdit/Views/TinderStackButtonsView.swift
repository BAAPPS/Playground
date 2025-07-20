//
//  TinderStackButtonsView.swift
//  SplashEdit
//
//  Created by D F on 7/20/25.
//

import SwiftUI

struct TinderStackButtonsView: View {
    
    @Bindable var buttonsVM:TinderStackButtonsVM
    @Binding var selectedPhoto:UnsplashPhotosModel?
    
    var photos: [UnsplashPhotosModel]
    
    
    var likeButton: some View {
        ReusableAsyncImageButton(
            systemImageName: buttonsVM.isLiked ? "heart.fill" : "heart",
            fgColor: buttonsVM.isLiked ? .red : .white
        ){
            await buttonsVM.likeCurrentPhotoAsync()
        }

    }
    
    var infoButton: some View {
        ReusableAsyncImageButton(systemImageName: "info.circle") {
            selectedPhoto = photos[buttonsVM.currentIndex]
        }
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack{
                    likeButton
                    infoButton
                }
                .padding(.trailing, 20)
                .padding(.bottom, 40)
            }
        }
        .offset(x: 10)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedPhoto: UnsplashPhotosModel? = nil
        @State private var mockPhotos = MockData.mockPhotos
        
        var body: some View {
            TinderStackButtonsView(
                buttonsVM: TinderStackButtonsVM(
                    authVM: SupabaseAuthViewModel(),
                    photos: mockPhotos
                ),
                selectedPhoto: $selectedPhoto,
                photos: mockPhotos
            )
        }
    }
    
    return PreviewWrapper()
}
