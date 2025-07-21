//
//  TinderStackButtonsView.swift
//  SplashEdit
//
//  Created by D F on 7/20/25.
//

import SwiftUI

struct TinderStackButtonsView: View {
    
    @Bindable var authVM: SupabaseAuthViewModel
    
    @Bindable var buttonsVM:TinderStackButtonsVM
//    @Binding var selectedPhoto:UnsplashPhotosModel?
    @Binding var activeModal: ActiveModal?
    
    
    var photos: [UnsplashPhotosModel]
    
    @State private var showUserProfile = false
    
    
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
            activeModal = .photoDetail(photos[buttonsVM.currentIndex])
        }
    }

    var filterViewButton: some View {
        ReusableAsyncImageButton(systemImageName: "camera.filters") {
            activeModal = .filterPhoto(photos[buttonsVM.currentIndex])
        }
    }

    
    var userProfileViewButton: some View {
        ReusableAsyncImageButton(systemImageName: "person.circle") {
            showUserProfile.toggle()
        }
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack{
                    userProfileViewButton
                    filterViewButton
                    likeButton
                    infoButton
                }
                .padding(.trailing, 20)
                .padding(.bottom, 40)
            }
        }
        .offset(x: 10)
        .navigationDestination(isPresented: $showUserProfile) {
            UserProfileView(authVM: authVM)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
//        @State private var selectedPhoto: UnsplashPhotosModel? = nil
        @State private var mockPhotos = MockData.mockPhotos
        @State private var activeModal: ActiveModal? = nil
        
        var body: some View {
            TinderStackButtonsView(
                authVM: SupabaseAuthViewModel(),
                buttonsVM: TinderStackButtonsVM(
                    authVM: SupabaseAuthViewModel(),
                    photos: mockPhotos
                ),
//                selectedPhoto: $selectedPhoto,
                activeModal: $activeModal,
                photos: mockPhotos
            )
        }
    }
    
    return PreviewWrapper()
}
