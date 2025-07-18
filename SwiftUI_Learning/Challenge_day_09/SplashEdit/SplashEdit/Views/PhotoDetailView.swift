//
//  PhotoDetailView.swift
//  SplashEdit
//
//  Created by D F on 7/18/25.
//

import SwiftUI

struct PhotoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let photo:UnsplashPhotosModel
    var body: some View {
        ZStack {
            Color(hex: "#edf2f4")
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing:16) {
                    AsyncImageLoader(urlString: photo.urls.regular)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            HStack {
                                Spacer()
                                VStack{
                                    Button(action: {
                                        dismiss()
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .foregroundColor(.white)
                                            .background(Color.black.opacity(0.6))
                                            .clipShape(Circle())
                                    }.padding()
                                        .padding(.trailing, 20)
                                    Spacer()
                                }
                            }
                        )
                    
                    VStack(alignment:.leading, spacing:10) {
                        Text(photo.alt_description ?? "")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(hex:"#5f8d98"))
                        Text(photo.description ?? "")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex:"#202c31"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    Divider()
                    HStack(spacing:20) {
                        Text("Photo by:")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex:"#364f56"))
                        AsyncImageLoader(urlString: photo.user.profile_image.large)
                            .frame(width:80, height:80)
                            .clipShape(.circle)
                        Text(photo.user.username)
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
            }
            .ignoresSafeArea(edges:.top)
        }
        
    }
}


#Preview {
    PhotoDetailView(photo: MockData.mockPhoto)
}
