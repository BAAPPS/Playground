//
//  ArtistDetailView.swift
//  HKPopTracks
//
//  Created by D F on 6/29/25.
//

import SwiftUI

struct ArtistDetailView: View {
    let artistId: Int
    @Bindable var detailVM: ArtistDetailViewModel
    
    var body: some View {
        let tracks = detailVM.getDetails(for: artistId).filter { $0.wrapperType == "track" }
        
        
        List {
            ForEach(tracks) { detail in
                VStack{
                    HStack {
                        VStack(alignment:.leading){
                            Text(detail.trackName ?? "Unknown")
                                .font(.headline)
                                .padding(.bottom, 2)
                            Text(detail.primaryGenreName ?? "Unknown")
                                .font(.subheadline)
                        }
                        Spacer()
                        AsyncImage(url: URL(string: detail.artworkUrl100 ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .opacity(0.5)
                        }
                        .frame(width: 100, height: 100)
                        
                    }
                }
            }
            
        }
        .navigationTitle("Artist Albums")
        .onAppear {
            Task {
                await detailVM.fetchArtistDetailsById(for: artistId)
            }
        }
    }
}



#Preview {
    @Previewable @State var detailVM = ArtistDetailViewModel()
    // andy lau
    NavigationView {
        ArtistDetailView(artistId: 19345683, detailVM: .mock)
    }
}
