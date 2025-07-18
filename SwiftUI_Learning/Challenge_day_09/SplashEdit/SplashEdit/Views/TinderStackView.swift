//
//  TinderStackView.swift
//  SplashEdit
//
//  Created by D F on 7/18/25.
//

import SwiftUI

struct TinderStackView: View {
    @Binding var photos: [UnsplashPhotosModel]
    let parentSize: CGSize
    
    // Track which photo is selected for detailed modal
    @State private var selectedPhoto: UnsplashPhotosModel? = nil
    
    @State private var currentIndex = 0
    
    
    var body: some View {
        ZStack {
            ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                if currentIndex >= 0 && currentIndex < photos.count {
                    PhotoSwipeView(photo: photos[currentIndex]) { direction in
                        if direction == .left && currentIndex < photos.count - 1 {
                            currentIndex += 1
                        } else if direction == .right && currentIndex > 0 {
                            currentIndex -= 1
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
                            .offset(x: 10)
                        : nil
                    )
                    
                } else {
                    Text("No more photos")
                }
            }
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
        
        TinderStackView(photos: bindingPhotos, parentSize: CGSize(width: 375, height: 600))
    }
    
}
