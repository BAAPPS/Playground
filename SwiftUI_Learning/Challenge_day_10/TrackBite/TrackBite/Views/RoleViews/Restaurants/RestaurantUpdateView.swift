//
//  RestaurantUpdateView.swift
//  TrackBite
//
//  Created by D F on 7/30/25.
//

import SwiftUI

struct RestaurantUpdateView: View {
    let restaurant: RestaurantModel

     var body: some View {
         Form {
             Text("Restaurant ID: \(restaurant.id.uuidString)")
             TextField("Restaurant Name", text: .constant(restaurant.name))
             // Add other fields here, prefilled with restaurant's data
         }
         .navigationTitle("Edit \(restaurant.name)")
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
    RestaurantUpdateView(restaurant: restaurantModel)
}
