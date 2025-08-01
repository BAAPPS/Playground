//
//  RestaurantCardView.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI

struct RestaurantCardView: View {
    let restaurant: RestaurantModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(restaurant.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(restaurant.address)
                .font(.subheadline)
                .foregroundColor(.gray)

        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}


#Preview {
    let restaurantModel = RestaurantModel(
        id: UUID(),
        name: "Tartine Bakery",
        description: "The best bakery you can ever find in the bay area!",
        imageURL: nil,
        address: "600 Guerrero St, San Francisco, CA 94110",
        latitude: 37.7615,
        longitude: -122.4241,
        phone: nil,
        website: nil,
        ownerID: UUID(),
        createdAt: Date()
    )
    RestaurantCardView(restaurant: restaurantModel)
}
