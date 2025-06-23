//
//  MediaDetailView.swift
//  EntertainmentZone
//
//  Created by D F on 6/23/25.
//

import SwiftUI

struct MediaDetailView: View {
    let mediaViewModel: MediaViewModel
    
    let columns = [GridItem(.adaptive(minimum: 200))]
    

    
    var body: some View {
        ZStack {
            Color.red.opacity(0.75)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text(mediaViewModel.media.description)
                        .padding()
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                    HStack {
                        Spacer(minLength: 20)
                        HStack(spacing:8){
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .font(.title2)
                            Text(mediaViewModel.releaseDateFormatted)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        HStack(spacing:8){
                            Image(systemName: mediaViewModel.media.mediaType == "tv" ? "tv" :"film")
                                .foregroundColor(.blue)
                                .font(.title2)
                            Text(mediaViewModel.media.mediaType)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .textCase(.uppercase)
                        }
                        Spacer(minLength: 20)
                    }
                    
                    
                    LazyVGrid(columns: columns) {
                        ForEach(mediaViewModel.cast, id:\.id){ cast in
                            VStack{
                                
                                if let url = URL(string: cast.profileUrl) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 100, height: 100)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 150)
                                                .clipShape(Circle())
                                                .padding()
                                            
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width:100, height: 100)
                                                .clipped()
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                                VStack{
                                    HStack{
                                        Text("Starring:")
                                            .foregroundColor(.blue)
                                            .font(.title2)
                                        Text(cast.name)
                                            .foregroundColor(.white)
                                            .font(.title3)
                                    }
                                    HStack{
                                        Text("Role:")
                                            .foregroundColor(.blue)
                                            .font(.title2)
                                        Text(cast.character)
                                            .foregroundColor(.white)
                                            .font(.title3)
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("\(mediaViewModel.media.title)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
        }
    }
}


#Preview {
    let media: [Media] = Bundle.main.decode("media.json")
    let cast: [Cast] = Bundle.main.decode("cast.json")
    let mediaVM = MediaViewModel(media: media[media.count-1], allCast: cast)
    NavigationStack{
        MediaDetailView(mediaViewModel:mediaVM )
    }
}
