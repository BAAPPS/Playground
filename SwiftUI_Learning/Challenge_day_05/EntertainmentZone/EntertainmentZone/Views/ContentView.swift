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
    
    @State private var showMediaDetails = false
    
    @State private var showingList = false
    
    @State private var pathStore = PathStore()
    
    
    
    var body: some View {
        NavigationStack(path:$pathStore.path) {
            Group {
                if showingList {
                    ListScreenMediaView(mediaViewModel: mediaViewModel, showingList: $showingList)
                        .navigationDestination(for: Media.self) {media in
                            MediaDetailView(mediaViewModel: MediaViewModel(media: media, allCast: cast), pathStore: $pathStore)
                        }
                } else{
                    FullScreenMediaView(mediaViewModel: mediaViewModel, showingList: $showingList, path: $pathStore.path)
                        .navigationDestination(for: Media.self) { media in
                            MediaDetailView(mediaViewModel: MediaViewModel(media: media, allCast: cast), pathStore: $pathStore)
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text(media.title)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    }
                                }
                        }
                      
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
