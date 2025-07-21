//
//  TinderStackView.swift
//  SplashEdit
//
//  Created by D F on 7/18/25.
//

import SwiftUI


enum ActiveModal: Identifiable {
    case photoDetail(UnsplashPhotosModel)
    case filterPhoto(UnsplashPhotosModel)
    
    var id: String {
        switch self {
        case .photoDetail(let photo): return "detail-\(photo.id)"
        case .filterPhoto(let photo): return "filter-\(photo.id)"
        }
    }
}


struct TinderStackView: View {
    @Bindable var authVM: SupabaseAuthViewModel
    
    @Binding var photos: [UnsplashPhotosModel]
    let parentSize: CGSize
    
    // Track which photo is selected for detailed modal
    @State private var selectedPhoto: UnsplashPhotosModel? = nil
    
    @State private var buttonsVM:TinderStackButtonsVM
    
    @State private var activeModal: ActiveModal? = nil

    
    
    init(authVM: SupabaseAuthViewModel, photos: Binding<[UnsplashPhotosModel]>, parentSize: CGSize) {
        self.authVM = authVM
        self._photos = photos
        self.parentSize = parentSize
        _buttonsVM = State(wrappedValue: TinderStackButtonsVM(authVM: authVM, photos: photos.wrappedValue))
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                    if buttonsVM.currentIndex >= 0 && buttonsVM.currentIndex < photos.count {
                        PhotoSwipeView(photo: photos[buttonsVM.currentIndex]) { direction in
                            Task{
                                
                                if direction == .left{
                                    await buttonsVM.moveToNextPhoto()
                                } else if direction == .right{
                                    await buttonsVM.moveToPreviousPhoto()
                                }
                            }
                        }
                        .frame(width: parentSize.width, height: parentSize.height)
                        .zIndex(Double(index))
                        .overlay(
                            index == photos.indices.last ?
                            
                            TinderStackButtonsView(authVM:authVM, buttonsVM: buttonsVM, activeModal: $activeModal, photos:photos)
                            
                            : nil
                        )
                        .overlay {
                            if buttonsVM.showHeartOverlay {
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
                await buttonsVM.updateLikeStatus()
            }
            // Present full screen modal when selectedPhoto is set
            .fullScreenCover(item: $activeModal) { modal in
                switch modal {
                case .photoDetail(let photo):
                    PhotoDetailView(photo: photo)
                case .filterPhoto(let photo):
                    FilterPhotoView(authVM: authVM, photo: photo)
                }
            }

        }
        
    }
    func remove(_ photo: UnsplashPhotosModel) {
        photos.removeAll { $0.id == photo.id }
        buttonsVM.photos = photos
        if buttonsVM.currentIndex >= photos.count {
            buttonsVM.currentIndex = max(photos.count - 1, 0)
        }
        Task {
            await buttonsVM.updateLikeStatus()
        }
    }
}



#Preview {
    @Previewable  @State var mockPhotos = MockData.mockPhotos
    
    PreviewBindingsView(mockPhotos) { bindingPhotos in
        
        TinderStackView(authVM: SupabaseAuthViewModel(), photos: bindingPhotos, parentSize: CGSize(width: 375, height: 600))
    }
    
}
