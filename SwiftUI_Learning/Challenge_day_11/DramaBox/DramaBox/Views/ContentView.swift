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
    @State private var shows: [ShowDisplayable] = []
    @State private var isLoading = true
    @State private var isOnline = false
    @State private var hasLoadedOnce = false
    @State private var isFetchingShows = false
    
    
    
    var body: some View {
        NavigationStack {
            if shows.isEmpty {
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
                TabView {
                    FullScreenPageView(shows: shows)
                        .tabItem {
                            Image(systemName: "film")
                            Text("Newest")
                        }
                }
            }
        }
        .task {
            isOnline = networkMonitor.isConnected
            loadAndFetchShowsIfNeeded()
        }
        .onChange(of: networkMonitor.isConnected) { _, newStatus in
            isOnline = newStatus
            loadAndFetchShowsIfNeeded()
        }
    }
    
    @MainActor
    private func loadAndFetchShowsIfNeeded() {
        Task {
            guard !isFetchingShows else { return } // prevent duplicate calls
            isFetchingShows = true
            
            // 1️⃣ Load local cache first
            if !hasLoadedOnce, let localShows = combinedVM.tvbShowsVM.loadShowDetailsLocally(), !localShows.isEmpty {
                shows = localShows
                isLoading = false
                hasLoadedOnce = true // mark that we've loaded cache at least once
            }
            
            // 2️⃣ Only fetch if online and allowed
            guard isOnline, combinedVM.tvbShowsVM.shouldFetchNewShows() else {
                isFetchingShows = false
                return
            }
            
            // 3️⃣ Scrape & upload
            let _ = await combinedVM.scrapeAndUploadNewShows(isOnline: true)
            
            // 4️⃣ Merge with UI
            let mergedShows = await combinedVM.fetchMergedShows(isOnline: true)
            for show in mergedShows {
                if !shows.contains(where: { $0.id == show.id }) {
                    shows.append(show)
                }
            }
            
            // 5️⃣ Update last fetch date
            UserDefaults.standard.set(Date(), forKey: "lastFetchDate")
            isFetchingShows = false
        }
    }
    
}

#Preview {
    ContentView()
}
