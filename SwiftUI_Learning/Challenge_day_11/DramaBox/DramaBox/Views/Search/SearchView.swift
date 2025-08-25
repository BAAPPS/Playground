//
//  SearchView.swift
//  DramaBox
//
//  Created by D F on 8/25/25.
//

import SwiftUI

struct SearchView: View {
    @Environment(CombinedViewModel.self) var combinedVM
    @State private var searchText = ""

    @Binding var path: NavigationPath
    
    var genres: [Genre] = Genre.allCases
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())] // 2-column grid
    
    var body: some View {
        VStack {
            // Search Bar
            TextField("Search shows...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchText) {oldValue, newValue in
                    combinedVM.filterShows(searchText: newValue)
                }
            
            if searchText.isEmpty {
                // Show genres grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(genres, id: \.self) { genre in
                            NavigationLink(value: genre) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue.opacity(0.3))
                                    Text(genre.rawValue)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .frame(height: 80)
                            }
                        }
                    }
                    .padding()
                }
            } else {
                // Show filtered shows
                List(combinedVM.filteredShows, id: \.id) { show in
                    NavigationLink(value: show) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(show.title).font(.headline)
                            if let subtitle = show.subtitle {
                                Text("(\(subtitle))").font(.caption)
                            }
                            Text(show.year).font(.subheadline)
                            Text(show.genres.joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("Search")
        .navigationDestination(for: Genre.self) { genre in
            GenreShowsView(genre: genre, shows: combinedVM.showsByGenre[genre] ?? [], path: $path)
        }
        .task {
            await combinedVM.fetchAndGroupShows()
        }
    }
    
}


#Preview {
    @Previewable @State var combinedVM = CombinedViewModel()
    @Previewable @State var pathStore = PathStore()
    SearchView(path:$pathStore.path)
        .environment(combinedVM)
}
