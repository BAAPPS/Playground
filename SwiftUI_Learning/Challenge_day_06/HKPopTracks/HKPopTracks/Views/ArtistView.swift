//
//  ArtistsView.swift
//  HKPopTracks
//
//  Created by D F on 6/29/25.
//

import SwiftUI

struct ArtistView: View {
    @State private var viewDetailModel = ArtistDetailViewModel()
    @Bindable var viewModel: ArtistViewModel
    
    var body: some View {
        List(viewModel.artists, id: \.artistId) { artist in
            NavigationLink{
                ArtistDetailView(artistId: artist.artistId, detailVM: viewDetailModel)
            } label:{
                ArtistRowView(artist: artist)
                    .padding(.vertical, 8)
            }
            .listRowBackground(Color.white.opacity(0.2))
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .navigationTitle("HK Pop Artists")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        
    }
}

#Preview {
    @Previewable @State var viewModel = ArtistViewModel()
    
    NavigationView {
        ZStack {
            Color.red.opacity(0.5)
                .ignoresSafeArea()
            ArtistView(viewModel: viewModel)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .task{
                    await viewModel.fetchArtist()
                }
        }
    }
}
