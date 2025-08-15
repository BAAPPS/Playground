//
//  ContentView.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @State private var combinedVM = CombinedViewModel()
    @State private var networkMonitor = NetworkMonitorModel()
    @State private var shows: [ShowDetails] = []
    @State private var isLoading = true
    @State private var isOnline = false
    
    var body: some View {
        NavigationStack {
            FullScreenPageView(shows: shows)
        }
        .task{
            let result = await combinedVM.scrapeAndUploadNewShows()
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                print(error.localizedDescription)
            }
            // Load merged shows for display (online first, fallback local)
            isOnline = networkMonitor.isConnected
            shows = await combinedVM.fetchMergedShows()
            print("Loaded shows count:", shows.count)
            isLoading = false
        }
        .onChange(of: networkMonitor.isConnected) {oldStatus, newStatus in
            isOnline = newStatus
            Task{
                shows = await combinedVM.fetchMergedShows()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
