//
//  FullScreenMediaView.swift
//  EntertainmentZone
//
//  Created by D F on 6/23/25.
//

import SwiftUI

struct FullScreenMediaView: View {
    let mediaViewModel: [MediaViewModel]
    @State private var currentPage = 0
    
    @State private var selectedMedia: MediaViewModel? = nil
    @State private var showDetails = false
    
    var body: some View {
        SnapPagingView(pageCount: mediaViewModel.count, currentPage: $currentPage) { width, height in
            VStack(spacing: 0) {
                ForEach(mediaViewModel.reversed(), id: \.id) { mediaVM in
                    ZStack(alignment: .top){
                        
                        if let url = URL(string: mediaVM.media.imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: width, height: height)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: width, height: height)
                                        .clipped()
                                    
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:width, height: height)
                                        .clipped()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
                        OverlayEffectView()
                        VStack{
                            HStack{
                                Spacer()
                                Button{
                                    selectedMedia = mediaVM
                                    showDetails = true
                                } label:{
                                    Image(systemName:"info.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(.red.opacity(0.5))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                        
                        VStack{
                            Spacer()
                            Text(mediaVM.media.title)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                                .padding(10)
                                .background(.red.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius:10))
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 80)
                        }
                    }
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
                    
                }
            }
            .frame(maxWidth: .infinity)
        }
        .navigationDestination(isPresented: $showDetails){
            if let media = selectedMedia {
                MediaDetailView(mediaViewModel: media)
            }else {
                Text("No Media Selected")
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    let media: [Media] = Bundle.main.decode("media.json")
    let cast: [Cast] = Bundle.main.decode("cast.json")
    let mediaVMs = media.map { MediaViewModel(media: $0, allCast: cast) }
    
    NavigationStack { 
        FullScreenMediaView(mediaViewModel: mediaVMs)
    }
    
}
