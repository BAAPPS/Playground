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
    @Environment(\.supabaseAuthVM) private var authVM: Bindable<SupabaseAuthVM>?
    @Environment(RestaurantOrderViewModel.self) var restaurantOrderViewModel

    var body: some View {
        Group{
            switch localAuthVM.currentUser?.role {
            case .restaurant:
                RestaurantProfileSettingView()
                    .environment(localAuthVM)
                    .environment(restaurantVM)
                    .environment(\.supabaseAuthVM, authVM)
            case .customer:
                CustomerProfileSettingView()
                    .environment(localAuthVM)
                    .environment(\.supabaseAuthVM, authVM)
                    .environment(restaurantOrderViewModel)
            case .driver:
                DriverProfileSettingView()
                    .environment(localAuthVM)
            case .none:
                Text("No role assigned.")
            }
        }
        .toolbar{
            ToolbarItem{
                Button{
                    Task{
                        await SupabaseAuthVM.shared.signOut()
                    }
                }label:{
                    Image(systemName: "door.right.hand.open")
                        .foregroundColor(.offWhite)
                }

            }
        }
        .backButton()
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
    
    let restaurantOrderViewModel = RestaurantOrderViewModel(orderModel: RestaurantOrderModel(id: UUID(), customerId: UUID(), restaurantId: UUID(), driverId: UUID(), deliveryAddress: "", status: .inProgress, estimatedTimeMinutes: 0, deliveryFee: 8.0, isPickedUp: false, isDelivered: false, orderType: .pickup, createdAt: Date(), updatedAt: Date()))
    
    NavigationStack {
        SettingDestinationView()
            .environment(localAuthVM)
            .environment(restaurantVM)
            .environment(restaurantOrderViewModel)
    }
}
