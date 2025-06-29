//
//  ArtistRowView.swift
//  HKPopTracks
//
//  Created by D F on 6/29/25.
//

import SwiftUI

struct ArtistRowView: View {
    let artist: ArtistModel
    var body: some View {
        HStack(alignment: .center) {
            Text(artist.artistName)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Text(artist.primaryGenreName.rawValue)
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

#Preview {
    @Previewable @State var viewModel = ArtistViewModel()
    NavigationView {
        ZStack {
            Color.red.opacity(0.5)
                .ignoresSafeArea()
            ArtistRowView(artist: ArtistModel(
                   artistName: "Eason Chan",
                   artistLinkUrl: "https://music.apple.com/hk/artist/eason-chan/5284630",
                   artistId: 5284630,
                   amgArtistId: nil,
                   primaryGenreName: .pop,
                   primaryGenreId: 16
               ))
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .task{
                    await viewModel.fetchArtist()
                }
        }
    }
}
