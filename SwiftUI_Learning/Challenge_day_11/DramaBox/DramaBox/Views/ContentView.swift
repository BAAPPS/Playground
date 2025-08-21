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
    
    
    
    var body: some View {
        NavigationStack {
            if shows.isEmpty {
                loadingView
            } else {
                CustomTabBarView(shows: shows)
            }
        }
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
        
        shows = await combinedVM.fetchMergedShows(isOnline: isOnline)
        isLoading = false
        
        
        // Scrape and upload new shows if online
        if isOnline {
            let result = await combinedVM.scrapeAndUploadNewShows(isOnline: true)
            switch result {
            case .success(let message):
                print("⬆️ Upload result:", message)
            case .failure(let error):
                print("❌ Upload failed:", error.localizedDescription)
            }
        }
    }
    
}

#Preview {
    ContentView()
}
