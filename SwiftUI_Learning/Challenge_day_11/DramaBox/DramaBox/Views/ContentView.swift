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
    @State private var isFetchingShows = false
    @State private var pathStore = PathStore()
    @AppStorage("hasScrapedShows") private var hasScrapedShows: Bool = false
    
    
    var body: some View {
        NavigationStack(path:$pathStore.path) {
            if shows.isEmpty {
                loadingView
            } else {
                CustomTabBarView(shows: shows, pathStore: $pathStore)
                    .navigationDestination(for: ShowDetails.self) {show in
                        FullScreenDetailView(show: show, pathStore: $pathStore)
                    }
            }
        }
        .environment(combinedVM)
        .task { await loadShowsIfNeeded() }
        .onChange(of: networkMonitor.isConnected) { _, newStatus in
            isOnline = newStatus
            if newStatus { Task { await loadShowsIfNeeded() } }
        }
    }
    
    
    private var loadingView: some View {
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
    }
    
    
    @MainActor
    private func loadShowsIfNeeded() async {
        guard !isFetchingShows else { return }
        isFetchingShows = true
        defer { isFetchingShows = false }
        
        // Merge cached + online shows
        shows = await combinedVM.fetchMergedShows(isOnline: isOnline)
        isLoading = false
        
        // Only scrape TVB once for initial population
        if isOnline && !hasScrapedShows {
            let result = await combinedVM.scrapeAndUploadNewShows(isOnline: true)
            hasScrapedShows = true
            switch result {
            case .success(let message): print("⬆️ Initial scrape:", message)
            case .failure(let error): print("❌ Scrape failed:", error.localizedDescription)
            }
        }
        
        // Always update online shows from Supabase without scraping TVB again
        if isOnline {
            await combinedVM.showSQLVM.loadOnlineShows()
            shows = await combinedVM.fetchMergedShows(isOnline: true) // merge fresh online shows with local
        }
    }
    
    
}

#Preview {
    @Previewable @State var combinedVM = CombinedViewModel()
    ContentView()
        .environment(combinedVM)
}
