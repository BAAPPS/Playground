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
        GeometryReader { geometry in
            ZStack {
                Color(hex: "#edf2f4")
                    .ignoresSafeArea()
                
                if photoVM.isLoading {
                    ProgressView("Loading photos...")
                } else if let error = photoVM.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    if photoVM.photos.isEmpty {
                        VStack {
                            Spacer()
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
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        TinderStackView(authVM: authVM, photos: $photoVM.photos, parentSize: geometry.size)
                    }
                }
            }
            .task {
                await photoVM.fetchPhotos()
            }
        }
    }
}


#Preview {
    NavigationView {
        LoggedInView(authVM: SupabaseAuthViewModel())
    }
}
