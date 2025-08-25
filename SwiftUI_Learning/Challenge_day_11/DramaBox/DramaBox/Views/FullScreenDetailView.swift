//
//  FullScreenDetailView.swift
//  DramaBox
//
//  Created by D F on 8/21/25.
//

import SwiftUI
import Kingfisher

struct FullScreenDetailView: View {
    let show: ShowDetails
    @Binding var pathStore: PathStore
    var body: some View {
        VStack {
            KFImage.url(from: show.bannerImageURL)
                .placeholder {
                    ZStack {
                        Color.black.opacity(0.2)
                        ProgressView()
                    }
                }
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .bannerSafeArea()
                .accessibilityLabel("\(show.title) banner image")
                .accessibilityAddTraits(.isImage)
            
            HStack(alignment: .center, spacing: 8){
                HStack(spacing: 8) {
                    Image(systemName: "textformat.alt")
                        .foregroundColor(.indigo.opacity(0.9))
                        .accessibilityHidden(true)
                    Text(show.subtitle ?? "")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                }
                
                shortDivider()
                HStack(spacing: 8) {
                    Image(systemName: "tv")
                        .foregroundColor(.indigo.opacity(0.9))
                        .accessibilityHidden(true)
                    Text(show.schedule)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                }
                shortDivider()
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .foregroundColor(.indigo.opacity(0.9))
                        .accessibilityHidden(true)
                    Text(show.year)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                }
                
            }
            .frame(maxWidth:.infinity, alignment: .center)
            .padding()
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                "Subtitle: \(show.subtitle ?? "N/A"), Total Episodes: \(show.schedule), Release Year: \(show.year)"
            )
            
            HStack(spacing: 8) {
                Image(systemName: "tag")
                    .foregroundColor(.indigo.opacity(0.9))
                    .accessibilityHidden(true)
                
                Text(show.genres.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                    .accessibilityLabel("Genres")
                    .accessibilityValue(show.genres.joined(separator: ", "))
            }
            
            HStack(spacing: 8) {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.indigo.opacity(0.9))
                    .accessibilityHidden(true)
                Text(show.cast.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                    .accessibilityLabel("Cast")
                    .accessibilityValue(show.cast.joined(separator: ", "))
            }
            .padding(.top, 5)
            
            ZStack(alignment: .bottom) {
                ScrollView(.vertical) {
                    Text(show.description)
                        .padding()
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.leading)
                }
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 30)
            }
            
            VStack {
                Text("All Episodes")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.headline)
                    .padding(.vertical)
                
                if let episodes = show.episodes {
                    let sortedEpisodes = episodes.dedupAndSort()
                    
                    ZStack(alignment: .bottom) {
                        List(sortedEpisodes, id: \.title) { episode in
                            HStack(spacing: 12) {
                                KFImage.url(from: episode.thumbnailURL)
                                    .placeholder {
                                        ZStack {
                                            Color.black.opacity(0.2)
                                            ProgressView()
                                        }
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                                
                                Text(episode.title)
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.8))
                            }
                            .padding(.vertical, 4)
                        }
                        .listStyle(.plain)
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 30)
                    }
                }
            }
            
            
            Spacer()
            
            
        }
        .navigationTitle(show.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    pathStore.path = NavigationPath()
                }){
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var pathStore = PathStore()
    NavigationStack {
        FullScreenDetailView(
            show:
                ShowDetails(schedule:"25 Episodes",
                            subtitle:"輕．功",
                            genres:["Action","Drama","Family"],
                            year:"2022",
                            description:"Combining warmth and humor, Qing·gong tells the joys, sorrows and joys of a group of former filmmakers. A dragon and tiger martial artist who is thought to know Qinggong is under the same roof again with the children of the flat people who leave the nest. Nuclear bomb-level contradictions.",
                            thumbImageURL:"https://img.tvbaw.com/eyJidWNrZXQiOiJ0dmJhdy1uYSIsImtleSI6ImltYWdlcy9wb3N0ZXIvMWQ1MTY3NjctOWNlMS00NzU0LWJhMjQtYjVmYWU3Y2Y5ZDc1LnBuZyIsImVkaXRzIjp7InJlc2l6ZSI6IHsiZml0IjoiY292ZXIifSB9fQ==",
                            cast:["Wayne Lai","Mimi Kung Tse-Yan"],
                            title:"Go With The Float",
                            bannerImageURL:"https://img.tvbaw.com/eyJidWNrZXQiOiJ0dmJhdy1uYSIsImtleSI6ImltYWdlcy9iYW5uZXIvMjZkZDkxYjItYzVkMS00MDVmLWI2MjAtZTU4ZjRmYjVkMzkxLmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6IHsiZml0IjoiY292ZXIifSB9fQ==",
                            episodes: [Episode( title:"Episode 01",url:"https://tvbanywherena.com/english/videos/365-GoWithTheFloat/1750790321631766971",thumbnailURL:"https://cf-images.us-east-1.prod.boltdns.net/v1/jit/5324042807001/575dee99-bbff-4c18-8da2-ea46bd47f03d/main/1920x1080/21m28s224ms/match/image.jpg") ]
                           ), pathStore: $pathStore)
    }
}
