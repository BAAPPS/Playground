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
    
    @Binding var pathStore: PathStore
    
    
    
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
                                                .frame(width: .infinity, height: .infinity)
                                                .clipShape(Rectangle())
                                            
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
                                VStack(alignment:.leading){
                                    HStack{
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.blue)
                                        
                                        Text(cast.name)
                                            .foregroundColor(.white)
                                            .font(.title3)
                                    }
                                    HStack{
                                        Image(systemName: "theatermasks.fill")
                                            .foregroundColor(.blue)
                                        
                                        Text(cast.character)
                                            .foregroundColor(.white)
                                            .font(.title3)
                                    }
                                }
                                .padding()
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.white.opacity(0.5))
                            )
                            .padding()
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
                .navigationBarBackButtonHidden(true)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            pathStore.path = NavigationPath()
                        }){
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    @Previewable @State var pathStore = PathStore()
    let media: [Media] = Bundle.main.decode("media.json")
    let cast: [Cast] = Bundle.main.decode("cast.json")
    let mediaVM = MediaViewModel(media: media[media.count-1], allCast: cast)
    NavigationStack{
        MediaDetailView(mediaViewModel:mediaVM, pathStore:$pathStore)
    }
}
