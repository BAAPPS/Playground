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
    
    var body: some View {
        NavigationStack {
            FullScreenMediaView(mediaViewModel: mediaViewModel)
        }
    }
}

#Preview {
    ContentView()
}
