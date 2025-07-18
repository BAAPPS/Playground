//
//  PhotoSwipeView.swift
//  SplashEdit
//
//  Created by D F on 7/18/25.
//

import SwiftUI

enum SwipeDirection {
    case left
    case right
}

struct PhotoSwipeView: View {
    
    let photo: UnsplashPhotosModel
    let onSwipe: (SwipeDirection) -> Void
    
    @State private var offset = CGSize.zero
    
    var body: some View {
        AsyncImage(url: URL(string: photo.urls.regular)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    .offset(offset)
                    .rotationEffect(.degrees(Double(offset.width / 20)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                            .onEnded { _ in
                                if offset.width > 150 {
                                    onSwipe(.right)
                                } else if offset.width < -150 {
                                    onSwipe(.left)
                                }
                                offset = .zero
                            }
                    )
                    .ignoresSafeArea()
                
            case .failure:
                EmptyView()
            @unknown default:
                EmptyView()
            }
        }
        .animation(.spring(), value: offset)
    }
    
}

#Preview {
    PhotoSwipeView(photo: MockData.mockPhoto, onSwipe: { direction in
        print("Preview onSwipe called with direction: \(direction)")
    })

}

