//
//  RoleDestinationView.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI

struct RoleDestinationView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(RestaurantVM.self) var restaurantVM
    @Environment(RestaurantOwnerSnapshotVM.self) var restaurantOwnerSnapshotVM
    @Environment(RestaurantOrderViewModel.self) var restaurantOrderViewModel
    var body: some View {
        switch localAuthVM.currentUser?.role {
        case .restaurant:
            RestaurantRoleView()
                .environment(localAuthVM)
                .environment(restaurantVM)
                .environment(restaurantOrderViewModel)
        case .customer:
            CustomersRoleView()
                .environment(localAuthVM)
                .environment(restaurantOwnerSnapshotVM)
                .environment(restaurantOrderViewModel)
        case .driver:
            DriversRoleView()
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
    
    let restaurantOwnerSnapshotVM =  RestaurantOwnerSnapshotVM(
        snapshotModel: RestaurantOwnerSnapshotModel(
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
    )
    
    let restaurantOrderViewModel = RestaurantOrderViewModel(orderModel: RestaurantOrderModel(id: UUID(), customerId: UUID(), restaurantId: UUID(), driverId: UUID(), deliveryAddress: "", status: .inProgress, estimatedTimeMinutes: 0, deliveryFee: 8.0, isPickedUp: false, isDelivered: false, orderType: .pickup, createdAt: Date(), updatedAt: Date()))
    RoleDestinationView()
        .environment(localAuthVM)
        .environment(restaurantVM)
        .environment(restaurantOwnerSnapshotVM)
        .environment(restaurantOrderViewModel)
}
