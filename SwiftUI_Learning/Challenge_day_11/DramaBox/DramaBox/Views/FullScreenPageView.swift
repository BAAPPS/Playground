//
//  FullScreenPageView.swift
//  DramaBox
//
//  Created by D F on 8/15/25.
//

import SwiftUI
import Kingfisher

// Safe array indexing to avoid out-of-bounds
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// Helper for KFImage
extension KFImage {
    static func url(from string: String?) -> KFImage {
        if let string, let url = URL(string: string) {
            return KFImage(url)
        }
        return KFImage(URL(string: ""))
    }
}

struct FullScreenPageView: View {
    let shows: [ShowDisplayable]
    let year: String
    @State private var currentPage = 0
    
    @Binding var path: NavigationPath

    private var filteredShows: [ShowDetails] {
        shows.compactMap { $0 as? ShowDetails }.filter { $0.year == year }
    }
    
    var body: some View {
        ZStack {
            SnapPagingView(pageCount: filteredShows.count, currentPage: $currentPage) { width, height in
                VStack(spacing: 0) {
                    ForEach(filteredShows.indices, id: \.self) { index in
                        let show = filteredShows[index]
                        KFImage.url(from: show.thumbImageURL)
                            .placeholder {
                                ZStack {
                                    Color.black.opacity(0.2)
                                    ProgressView()
                                }
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: height)
                            .clipped()
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.3), value: show.thumbImageURL)
                            .overlayEffect()
                    }
                }
                .ignoresSafeArea()
            }
            
            VStack {
                HStack {
                    Spacer()
                    if let currentShow = filteredShows[safe: currentPage] {
                        Button {
                            path.append(currentShow)
                        } label: {
                            Image(systemName: "info.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(.red.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @State var pathStore = PathStore()
    FullScreenPageView(shows: [
        ShowDetails(schedule:"25 Episodes",
                    subtitle:"輕．功",
                    genres:["Action","Drama","Family"],
                    year:"2022",
                    description:"Combining warmth and humor, Qing·gong tells the joys, sorrows and joys of a group of former filmmakers...",
                    thumbImageURL:"https://img.tvbaw.com/eyJidWNrZXQiOiJ0dmJhdy1uYSIsImtleSI6ImltYWdlcy9wb3N0ZXIvMWQ1MTY3NjctOWNlMS00NzU0LWJhMjQtYjVmYWU3Y2Y5ZDc1LnBuZyIsImVkaXRzIjp7InJlc2l6ZSI6IHsiZml0IjoiY292ZXIifSB9fQ==",
                    cast:["Wayne Lai","Mimi Kung Tse-Yan"],
                    title:"Go With The Float",
                    bannerImageURL:"https://img.tvbaw.com/eyJidWNrZXQiOiJ0dmJhdy1uYSIsImtleSI6ImltYWdlcy9iYW5uZXIvMjZkZDkxYjItYzVkMS00MDVmLWI2MjAtZTU4ZjRmYjVkMzkxLmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6IHsiZml0IjoiY292ZXIifSB9fQ==",
                    episodes: [Episode( title:"Episode 01",url:"https://tvbanywherena.com/english/videos/365-GoWithTheFloat/1750790321631766971",thumbnailURL:"https://cf-images.us-east-1.prod.boltdns.net/v1/jit/5324042807001/575dee99-bbff-4c18-8da2-ea46bd47f03d/main/1920x1080/21m28s224ms/match/image.jpg") ]
                   ),
        
        ShowDetails(schedule:"25 Episodes",
                    subtitle:"輕．功",
                    genres:["Action","Drama","Family"],
                    year:"2022",
                    description:"Combining warmth and humor, Qing·gong tells the joys, sorrows and joys of a group of former filmmakers...",
                    thumbImageURL:"https://img.tvbaw.com/eyJidWNrZXQiOiJ0dmJhdy1uYSIsImtleSI6ImltYWdlcy9wb3N0ZXIvMWQ1MTY3NjctOWNlMS00NzU0LWJhMjQtYjVmYWU3Y2Y5ZDc1LnBuZyIsImVkaXRzIjp7InJlc2l6ZSI6IHsiZml0IjoiY292ZXIifSB9fQ==",
                    cast:["Wayne Lai","Mimi Kung Tse-Yan"],
                    title:"Go With The Float",
                    bannerImageURL:"https://img.tvbaw.com/eyJidWNrZXQiOiJ0dmJhdy1uYSIsImtleSI6ImltYWdlcy9iYW5uZXIvMjZkZDkxYjItYzVkMS00MDVmLWI2MjAtZTU4ZjRmYjVkMzkxLmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6IHsiZml0IjoiY292ZXIifSB9fQ==",
                    episodes: [Episode( title:"Episode 01",url:"https://tvbanywherena.com/english/videos/365-GoWithTheFloat/1750790321631766971",thumbnailURL:"https://cf-images.us-east-1.prod.boltdns.net/v1/jit/5324042807001/575dee99-bbff-4c18-8da2-ea46bd47f03d/main/1920x1080/21m28s224ms/match/image.jpg") ]
                   )
    ], year:"2022", path: $pathStore.path)
}
