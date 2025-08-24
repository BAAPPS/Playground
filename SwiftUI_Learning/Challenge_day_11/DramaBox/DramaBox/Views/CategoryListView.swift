//
//  CategoryListView.swift
//  DramaBox
//
//  Created by D F on 8/24/25.
//

import SwiftUI

struct CategoryListView: View {
    @State private var showSQLVM = ShowSQLViewModel()
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
        .navigationTitle("Shows by Genre")
        .task(id: networkMonitor.isConnected) {
            await fetchAndGroupShows()
        }
    }
    
    @MainActor
    private func fetchAndGroupShows() async {
        await showSQLVM.fetchShows(isOnline: networkMonitor.isConnected)
        
        var grouped: [Genre: [ShowDetails]] = [:]
        for genre in Genre.allCases {
            grouped[genre] = showSQLVM.shows.filter { $0.genres.contains(genre.rawValue) }
        }
        showsByGenre = grouped
    }
}

#Preview {
    @Previewable @State var navPath = NavigationPath()
    @Previewable @State  var pathStore = PathStore()
    
    NavigationStack {
        CategoryListView(path: $navPath)
            .navigationDestination(for: ShowDetails.self) { show in
                FullScreenDetailView(show: show, pathStore: $pathStore)
            }
    }
}
