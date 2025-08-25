//
//  CategoryListView.swift
//  DramaBox
//
//  Created by D F on 8/24/25.
//

import SwiftUI

struct CategoryListView: View {
    @Environment(CombinedViewModel.self) var combinedVM
    @State private var networkMonitor = NetworkMonitorModel()
    @State private var showsByGenre: [Genre: [ShowDetails]] = [:]
    
    @Binding var path: NavigationPath
    var genres: [Genre] = Genre.allCases
    
    var body: some View {
        List {
            ForEach(genres, id: \.self) { genre in
                if let shows = showsByGenre[genre], !shows.isEmpty {
                    Section(header: Text(genre.rawValue).font(.headline)) {
                        ForEach(shows, id: \.id) { show in
                            NavigationLink(value: show) {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(show.title).font(.headline)
                                        if let subtitle = show.subtitle {
                                            Text("(\(subtitle))").font(.caption)
                                        }
                                    }
                                    Text(show.year).font(.subheadline)
                                    Text(show.genres.joined(separator: ", "))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 70)
        .navigationTitle("Shows by Genre")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: networkMonitor.isConnected) {
            await fetchAndGroupShows()
        }
    }
    
    @MainActor
    private func fetchAndGroupShows() async {
        // Only fetch if showsByGenre is empty or network just became online
        if showsByGenre.isEmpty || networkMonitor.isConnected {
            let fetchedShows = await combinedVM.showSQLVM.fetchShows(isOnline: networkMonitor.isConnected)
            
            // Update the shows in SQL VM for other views
            combinedVM.showSQLVM.shows = fetchedShows
            
            // Group by genre
            var grouped: [Genre: [ShowDetails]] = [:]
            for genre in Genre.allCases {
                grouped[genre] = fetchedShows.filter { $0.genres.contains(genre.rawValue) }
            }
            showsByGenre = grouped
        }
    }
    
}

#Preview {
    @Previewable @State var navPath = NavigationPath()
    @Previewable @State  var pathStore = PathStore()
    @Previewable @State var combinedVM = CombinedViewModel()
    
    NavigationStack {
        CategoryListView(path: $navPath)
            .environment(combinedVM)
            .navigationDestination(for: ShowDetails.self) { show in
                FullScreenDetailView(show: show, pathStore: $pathStore)
            }
    }
}
