//
//  CustomerRestaurantCardView.swift
//  TrackBite
//
//  Created by D F on 8/3/25.
//

import SwiftUI
import Kingfisher

struct CustomerRestaurantCardView: View{
    let restaurant: RestaurantOwnerSnapshotModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            
            if let urlString = restaurant.imageURL,
               let url = URL(string: urlString),
               !urlString.isEmpty {
                KFImage(url)
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
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipped()
                
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                HStack{
                    Image(systemName: "fork.knife")
                        .foregroundColor(.rose)
                        .font(.caption2)
                    Text(restaurant.restaurantName)
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.7))
                    
                }
                
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.rose)
                        .font(.caption2)
                    Text(restaurant.address)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
              
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 3)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    
    let restaurantModel = RestaurantOwnerSnapshotModel(
        id: UUID(),
        userId: UUID(),
        userName: "",
        userEmail: "",
        restaurantId: UUID(),
        restaurantName: "",
        snapshotCreatedAt: Date(),
        description: "",
        imageURL: "",
        address: "",
        phone: ""
    )
    
    CustomerRestaurantCardView(restaurant: restaurantModel)
}
