//
//  ArtistDetailView.swift
//  HKPopTracks
//
//  Created by D F on 6/29/25.
//

import SwiftUI
import Kingfisher


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
                            
                            Text(detail.releaseDate != nil ? detailVM.formattedDate(detail.releaseDate!) : "Unknown")
                                .font(.subheadline)

                            Text(detail.trackExplicitness ?? "Unknown")
                                .font(.subheadline)
                                .padding(.top, 2)
                                .foregroundColor(.black.opacity(0.7))
                        
                        }
                        
                        
                        Spacer()
                        KFImage(URL(string: detail.artworkUrl100 ?? ""))
                            .placeholder {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                            }
                            .onFailure { error in
                                print("Kingfisher failed to load image: \(error)")
                            }
                            .resizable()
                            .scaledToFit()
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
