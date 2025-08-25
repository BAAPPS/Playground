//
//  GenreShowsView.swift
//  DramaBox
//
//  Created by D F on 8/25/25.
//

import SwiftUI

struct GenreShowsView: View {
    let genre: Genre
    let shows: [ShowDetails]
    @Binding var path: NavigationPath

    var body: some View {
        List(shows, id: \.id) { show in
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
        .navigationTitle(genre.rawValue)
    }
}

#Preview {
    @Previewable @State var pathStore = PathStore()
    GenreShowsView(genre: .action, shows: [ShowDetails(
        schedule: "25 Episodes",
        subtitle: "輕．功",
        genres: ["Action","Drama","Family"],
        year: "2022",
        description: "Combining warmth and humor, Qing·gong tells the joys, sorrows and joys of a group of former filmmakers...",
        thumbImageURL: "https://img.tvbaw.com/eyJidWNrZXQiOiJ0dmJhdy1uYSIsImtleSI6ImltYWdlcy9wb3N0ZXIvMWQ1MTY3NjctOWNlMS00NzU0LWJhMjQtYjVmYWU3Y2Y5ZDc1LnBuZyIsImVkaXRzIjp7InJlc2l6ZSI6IHsiZml0IjoiY292ZXIifSB9fQ==",
        cast: ["Wayne Lai","Mimi Kung Tse-Yan"],
        title: "Go With The Float",
        bannerImageURL: "https://img.tvbaw.com/eyJidWNrZXQiOiJ0dmJhdy1uYSIsImtleSI6ImltYWdlcy9iYW5uZXIvMjZkZDkxYjItYzVkMS00MDVmLWI2MjAtZTU4ZjRmYjVkMzkxLmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6IHsiZml0IjoiY292ZXIifSB9fQ==",
        episodes: [
            Episode(
                title: "Episode 01",
                url: "https://tvbanywherena.com/english/videos/365-GoWithTheFloat/1750790321631766971",
                thumbnailURL: "https://cf-images.us-east-1.prod.boltdns.net/v1/jit/5324042807001/575dee99-bbff-4c18-8da2-ea46bd47f03d/main/1920x1080/21m28s224ms/match/image.jpg"
            )
        ]
    )], path: $pathStore.path)
}
