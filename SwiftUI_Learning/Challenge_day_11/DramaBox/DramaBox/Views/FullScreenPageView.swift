//
//  FullScreenPageView.swift
//  DramaBox
//
//  Created by D F on 8/15/25.
//

import SwiftUI
import Kingfisher


struct FullScreenPageView: View {
    let shows: [ShowDetails]
    @State private var currentPage = 0
    
    
    var body: some View {
        if shows.isEmpty {
            ProgressView("Loading shows…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            SnapPagingView(pageCount:shows.count, currentPage: $currentPage) { width, height in
                LazyVStack(spacing: 0, pinnedViews: []) {
                    ForEach(shows, id: \.id) { show in
                        ZStack(alignment: .top){
                            if let urlString = show.thumbImageURL,
                               let url = URL(string: urlString) {
                                KFImage(url)
                                    .placeholder {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.gray)
                                            .opacity(0.5)
                                    }
                                    .onFailure { error in
                                        print("Kingfisher failed:", error)
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: height)
                                    .clipped()
                                    .onAppear {
                                        print("Current page:", currentPage)
                                        print("Raw URL:", show.thumbImageURL ?? "nil")
                                        if let encoded = show.thumbImageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                                            print("Encoded URL:", encoded)
                                        } else {
                                            print("Encoding failed")
                                        }
                                        print("TITLE:", show.title)
                                    }
                            }
                            else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: width, height: height)
                                    .foregroundColor(.gray)
                            }
                            
                        }
                    }
                }
                .background(Color.black.opacity(0.5))
                .overlayEffect()
            }
            
            .onChange(of: currentPage) {oldPage, newPage in
                let currentShow = shows[newPage]
                print("Current page:", newPage)
                print("URL:", currentShow.thumbImageURL ?? "nil")
                print("TITLE:", currentShow.title)
            }
        }
    }
}


#Preview {
    FullScreenPageView(shows: [
        ShowDetails(schedule:"25 Episodes",
                    subtitle:"輕．功",
                    genres:["Action","Drama","Family"],
                    year:"2022",
                    description:"Combining warmth and humor, Qing·gong tells the joys, sorrows and joys of a group of former filmmakers. A dragon and tiger martial artist who is thought to know Qinggong is under the same roof again with the children of the flat people who leave the nest. Nuclear bomb-level contradictions.",
                    thumbImageURL:"https://img.tvbaw.com/eyJidWNrZXQiOiJ0dmJhdy1uYSIsImtleSI6ImltYWdlcy9wb3N0ZXIvMWQ1MTY3NjctOWNlMS00NzU0LWJhMjQtYjVmYWU3Y2Y5ZDc1LnBuZyIsImVkaXRzIjp7InJlc2l6ZSI6IHsiZml0IjoiY292ZXIifSB9fQ==",
                    cast:["Wayne Lai","Mimi Kung Tse-Yan"],
                    title:"Go With The Float",
                    bannerImageURL:"https://img.tvbaw.com/eyJidWNrZXQiOiJ0dmJhdy1uYSIsImtleSI6ImltYWdlcy9iYW5uZXIvMjZkZDkxYjItYzVkMS00MDVmLWI2MjAtZTU4ZjRmYjVkMzkxLmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6IHsiZml0IjoiY292ZXIifSB9fQ==",
                    episodes: [Episode( title:"Episode 01",url:"https://tvbanywherena.com/english/videos/365-GoWithTheFloat/1750790321631766971",thumbnailURL:"https://cf-images.us-east-1.prod.boltdns.net/v1/jit/5324042807001/575dee99-bbff-4c18-8da2-ea46bd47f03d/main/1920x1080/21m28s224ms/match/image.jpg")
                              ]
                   )
    ]
    )
}
