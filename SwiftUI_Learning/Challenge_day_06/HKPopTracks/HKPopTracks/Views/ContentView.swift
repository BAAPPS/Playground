//
//  ContentView.swift
//  HKPopTracks
//
//  Created by D F on 6/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ArtistViewModel()

    var body: some View {
        NavigationView {
            ZStack{
                Color.red.opacity(0.5)
                    .ignoresSafeArea()
                ArtistView(viewModel: viewModel)
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
            }
        }
        .task {
            await viewModel.fetchArtist()
        }
    }
}

#Preview {
    ContentView()
}
