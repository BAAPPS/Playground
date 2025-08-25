//
//  TabBarContentView.swift
//  DramaBox
//
//  Created by D F on 8/20/25.
//

import SwiftUI

struct TabBarContentView: View {
    let selectedTab: Int
    let shows: [ShowDisplayable]
    @Environment(CombinedViewModel.self) var combinedVM
    @State private var pathStore = PathStore()
    
    
    
    var body: some View {
        NavigationStack(path:$pathStore.path){
            switch selectedTab {
            case 0:
                FullScreenPageView(shows: shows, year: "2025", path: $pathStore.path)
                    .navigationDestination(for:  ShowDetails.self) { show in
                        FullScreenDetailView(show: show, pathStore: $pathStore)
                    }
            case 1:
                CategoryListView(path: $pathStore.path)
                    .environment(combinedVM)
                    .navigationDestination(for: ShowDetails.self) {show in
                        FullScreenDetailView(show: show, pathStore: $pathStore)
                    }
                
            case 2:
                Color.blue.opacity(0.4).ignoresSafeArea()
                
            default:
                Color.black.ignoresSafeArea()
            }
        }
    }
}

#Preview {
    TabBarContentView(selectedTab: 0, shows: [
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
                   )
    ])
}
