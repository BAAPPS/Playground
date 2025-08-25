//
//  ContentView.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @State private var showCache = SaveDataLocallyVM<ShowDetails>(fileName: "ShowDetails.json")

    @State private var combinedVM = CombinedViewModel()
    @State private var networkMonitor = NetworkMonitorModel()
    @State private var shows: [ShowDisplayable] = []
    @State private var isLoading = true
    @State private var isOnline = false
    @State private var isFetchingShows = false
    @State private var pathStore = PathStore()
    @AppStorage("hasScrapedShows") private var hasScrapedShows: Bool = false
    @AppStorage("hasRequestedNotifications") private var hasRequestedNotifications: Bool = false
    
    
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
        .task {
            await loadShowsIfNeeded()
            
            if !hasRequestedNotifications {
                await combinedVM.requestNotificationPermission()
                hasRequestedNotifications = true
            }
        }
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
                
                ProgressView("Scrapping shows…")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
            }
        }
    }
    
    
    @MainActor
    private func loadShowsIfNeeded() async {
        guard !isFetchingShows else { return }
        isFetchingShows = true
        isLoading = true // start loading spinner
        defer { isFetchingShows = false }
        
        // 1️⃣ Load cached shows immediately if available
        if let cachedShows = try? showCache.loadLocally(), !cachedShows.isEmpty {
            shows = cachedShows
            isLoading = false
        }
        
        // 2️⃣ Fetch merged shows
        let mergedShows = await combinedVM.fetchMergedShows(isOnline: isOnline)
        if !mergedShows.isEmpty {
            shows = mergedShows
            let concreteMerged = mergedShows.compactMap { $0 as? ShowDetails }
            try? showCache.saveLocally(concreteMerged)
            isLoading = false
        }
        
        // 3️⃣ Scrape new shows if needed
        if isOnline && !hasScrapedShows {
            Task {
                let result = await combinedVM.scrapeAndUploadNewShows(isOnline: true)
                hasScrapedShows = true
                print("⬆️ Initial scrape:", result)
                
                let refreshed = await combinedVM.fetchMergedShows(isOnline: true)
                if !refreshed.isEmpty {
                    await MainActor.run {
                        shows = refreshed
                        isLoading = false
                    }
                    let concreteRefreshed = refreshed.compactMap { $0 as? ShowDetails }
                    try? showCache.saveLocally(concreteRefreshed)
                }
            }
        }
        
        // 4️⃣ Update online shows in background
        if isOnline {
            Task {
                await combinedVM.showSQLVM.loadOnlineShows()
                let updated = await combinedVM.fetchMergedShows(isOnline: true)
                if !updated.isEmpty {
                    await MainActor.run {
                        shows = updated
                        isLoading = false
                    }
                    let concreteUpdated = updated.compactMap { $0 as? ShowDetails }
                    try? showCache.saveLocally(concreteUpdated)
                }
            }
        }
    }

    
    
    
}

#Preview {
    @Previewable @State var combinedVM = CombinedViewModel()
    ContentView()
        .environment(combinedVM)
}
