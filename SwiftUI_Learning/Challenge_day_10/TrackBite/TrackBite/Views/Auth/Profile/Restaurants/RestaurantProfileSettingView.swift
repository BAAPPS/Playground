//
//  ProfileSettingView.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI

struct RestaurantProfileSettingView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(RestaurantVM.self) var restaurantVM
    var body: some View {
        ZStack{
            
        }
        .navigationTitle(localAuthVM.currentUser?.name ?? "\( UserRole.restaurant.displayName)'s Profile")
        .navigationBarTitleDisplayMode(.inline)
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
        RestaurantProfileSettingView()
            .environment(localAuthVM)
            .environment(restaurantVM)
    }
}
