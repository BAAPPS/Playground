//
//  FullScreenDetailView.swift
//  DramaBox
//
//  Created by D F on 8/21/25.
//

import SwiftUI

struct FullScreenDetailView: View {
    let show: ShowDetails
    @Binding var pathStore: PathStore
    var body: some View {
        VStack {
            
        }
        .padding()
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
    FullScreenDetailView(
        show:
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
                       ), pathStore: $pathStore)
}
