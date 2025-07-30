//
//  SettingDestinationView.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI

struct SettingDestinationView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(RestaurantVM.self) var restaurantVM
    var body: some View {
        switch localAuthVM.currentUser?.role {
        case .restaurant:
            RestaurantProfileSettingView()
                .environment(localAuthVM)
                .environment(restaurantVM)
        case .customer:
            CustomerProfileSettingView()
                .environment(localAuthVM)
        case .driver:
            DriverProfileSettingView()
                .environment(localAuthVM)
        case .none:
            Text("No role assigned.")
        }
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
    SettingDestinationView()
        .environment(localAuthVM)
        .environment(restaurantVM)
}
