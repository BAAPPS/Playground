//
//  ContentView.swift
//  SnowSeeker
//
//  Created by D F on 9/2/25.
//

import SwiftUI

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    @State private var searchText = ""
    @State private var favorites = FavoritesVM()
    @State private var searchVM = ResortSearchVM(resorts: Bundle.main.decode("resorts.json"))


    var body: some View {
        NavigationSplitView {
            VStack {
                Picker("Sort by", selection: $searchVM.sortOrder) {
                    ForEach(ResortSearchVM.SortOrder.allCases) { order in
                        Text(order.rawValue).tag(order)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                List(searchVM.filteredResorts) { resort in
                    NavigationLink(value: resort) {
                        HStack {
                            Image(resort.country)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 25)
                                .clipShape(
                                    .rect(cornerRadius: 5)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(resort.name)
                                    .font(.headline)
                                Text("\(resort.runs) runs")
                                    .foregroundStyle(.secondary)
                            }
                            if favorites.contains(resort) {
                                Spacer()
                                Image(systemName: "heart.fill")
                                    .accessibilityLabel("This is a favorite resort")
                                    .foregroundStyle(.red)
                            }
                        }
                        
                    }
                }
                .navigationTitle("Resorts")
                .navigationDestination(for: Resort.self) { resort in
                    ResortView()
                        .environment(ResortVM(resort: resort))
                }
                .searchable(text: $searchText, prompt: "Search for a resort")
            }
        } detail: {
            WelcomeView()
        }
        .environment(favorites)
        
        
    }
}



#Preview {
    ContentView()
}
