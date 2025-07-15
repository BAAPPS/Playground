//
//  LoggedInView.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import SwiftUI

struct LoggedInView: View {
    @Bindable var authVM: SupabaseAuthViewModel
    @State private var photoVM = UnsplashPhotosVM()
    
    
    var body: some View {
        ZStack {
            Color(hex: "#edf2f4")
                .ignoresSafeArea()
            if photoVM.isLoading {
                ProgressView("Loading photos...")
            }else if let error = photoVM.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    if photoVM.photos.isEmpty {
                        GeometryReader { geometry in
                            VStack(spacing: 16) {
                                Spacer()
                                //                                ContentUnavailableView("No Pictures Available", systemImage: "photo.stack")
                                //                                    .foregroundStyle(Color(hex: "#202c31"))
                                
                                Image(systemName: "photo.stack")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(Color(hex: "#202c31"))
                                
                                Text("No Pictures Available")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color(hex: "#202c31"))
                                
                                
                                Spacer()
                            }
                            .frame(height: geometry.size.height)
                            .frame(maxWidth: .infinity)
                        }
                        .frame(height: 400)
                    }else{
                        LazyVStack(spacing:16){
                            ForEach(photoVM.photos) { photo in
                                AsyncImage(url: URL(string: photo.urls.regular)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(12)
                                            .shadow(radius: 4)
                                    case .failure:
                                        EmptyView() // ✅ fail silently
                                    @unknown default:
                                        EmptyView() // ✅ safe fallback
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("\(authVM.currentUser?.username ?? "Unknown User")")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await photoVM.fetchPhotos()
        }
    }
}

#Preview {
    NavigationView {
        LoggedInView(authVM: SupabaseAuthViewModel())
    }
}
