//
//  ContentView.swift
//  EntertainmentZone
//
//  Created by D F on 6/22/25.
//

import SwiftUI

struct ContentView: View {
    
    let cast: [Cast] = Bundle.main.decode("cast.json")
    let media: [Media] = Bundle.main.decode("media.json")
    
    var mediaViewModel: [MediaViewModel] {
        media.map{MediaViewModel(media: $0, allCast: cast)}
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Cast count: \(cast.count)")
                    Text("Media count: \(media.count)")
                    Text("MediaViewModels count: \(mediaViewModel.count)")
                    
                    ForEach(mediaViewModel) { mediaVM in
                        VStack{
                            Text(mediaVM.media.title)
                                .font(.headline)
                            
                            if let url = URL(string: mediaVM.media.imageUrl){
                                AsyncImage(url:url) { phase in
                                    
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 200)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 200)
                                    @unknown default:
                                        EmptyView()
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Entertainment Zone")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
