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
        Group {
            if isLoading || shows.isEmpty {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.8), .gray.opacity(0.5)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 300, height: 450)
                            .shimmer()
                        
                        ProgressView("Loading shows…")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundColor(.white)
                    }
                }
            } else {
                NavigationStack {
                    TabView{
                        FullScreenPageView(shows: shows)
                            .tabItem {
                                Image(systemName: "film")
                                Text("Newest")
                            }
                    }
                }
            }
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
