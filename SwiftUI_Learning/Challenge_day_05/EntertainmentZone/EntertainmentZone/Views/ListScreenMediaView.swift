//
//  ListDetailView.swift
//  EntertainmentZone
//
//  Created by D F on 6/24/25.
//

import SwiftUI

struct ListScreenMediaView: View {
    let mediaViewModel: [MediaViewModel]
    
    @Binding  var showingList: Bool
    var body: some View {
        ZStack {
            Color.red.opacity(0.7)
                .ignoresSafeArea()
     
            
            List{
                ForEach(mediaViewModel.reversed(), id:\.id){ mediaVM in
                    NavigationLink(value:mediaVM.media){
                        HStack{
                            Text(mediaVM.media.title)
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            if let url = URL(string: mediaVM.media.imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 100, height: 100)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                        
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:100, height: 100)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.red.opacity(0.7))
                }
            }
            .scrollContentBackground(.hidden)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button{
                        withAnimation{
                            showingList = false
                        }
                    } label:{
                        Image(systemName: "display")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(.black.opacity(0.5))
                            .clipShape(Circle())
                            .offset(x:-4,y: -10)
                    }
                }
            }
        }
    }
}

#Preview {
    let media: [Media] = Bundle.main.decode("media.json")
    let cast: [Cast] = Bundle.main.decode("cast.json")
    let mediaVMs = media.map { MediaViewModel(media: $0, allCast: cast) }
    NavigationStack{
        ListScreenMediaView(mediaViewModel:mediaVMs, showingList: .constant(false) )
    }
}
