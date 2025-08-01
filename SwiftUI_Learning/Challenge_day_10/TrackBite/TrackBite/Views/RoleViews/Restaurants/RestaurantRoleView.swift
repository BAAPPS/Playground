//
//  RestaurantRoleView.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI

struct RestaurantRoleView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(RestaurantVM.self) var restaurantVM
    // 2-column grid layout
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns:columns, spacing:16){
                ForEach(restaurantVM.restaurants) { restaurant in
                    NavigationLink(value: restaurant) {
                        RestaurantCardView(restaurant: restaurant)
                    }
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: (UIApplication.shared.connectedScenes
                    .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
                    .first ?? 90) + 30) // add 30 for nav bar height
            }

        }
        .navigationTitle("Your Restaurants")
        .scrollContentBackground(.hidden)
        .bodyBackground(color: .lightWhite)
        .navigationDestination(for: RestaurantModel.self) { restaurant in
            RestaurantUpdateView(restaurant: restaurant)
        }
        .navigationBarColor(background: .darkRedBackground , titleColor: .lightWhite)
    }
}

#Preview {
    let localAuthVM = LocalAuthVM.shared
    let restaurantVM = RestaurantVM(
       restaurantModel: RestaurantModel(
           id: UUID(),
           name: "",
           description: nil,
           imageURL: nil,
           address: "",
           latitude: 0.0,
           longitude: 0.0,
           phone: nil,
           website: nil,
           ownerID: UUID(),
           createdAt: Date()
       )
   )
    NavigationStack {
        RestaurantRoleView()
            .environment(localAuthVM)
            .environment(restaurantVM)
    }
}
