//
//  CustomerRoleView.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI

struct CustomersRoleView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(RestaurantOwnerSnapshotVM.self) var restaurantOwnerSnapshotVM
    @Environment(RestaurantOrderViewModel.self) var restaurantOrderViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16){
                ForEach(restaurantOwnerSnapshotVM.groupedByUser.keys.sorted(), id: \.self) { user in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Posted by:")
                                .font(.caption)
                                .foregroundColor(.black.opacity(0.8))
                            Text(user)
                                .font(.title2.bold())
                                .foregroundColor(.darkRedBackground)
                        }
                        ForEach(restaurantOwnerSnapshotVM.groupedByUser[user] ?? []) { restaurant in
                            NavigationLink(value: restaurant) {
                                CustomerRestaurantCardView(restaurant: restaurant)
                            }
                        }
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
        .navigationTitle("Available Restaurants")
        .scrollContentBackground(.hidden)
        .bodyBackground(color: .lightWhite)
        .navigationDestination(for: RestaurantOwnerSnapshotModel.self) { restaurant in
            CustomerOrderingView(restaurant: restaurant)
                .environment(localAuthVM)
                .environment(restaurantOrderViewModel)
        }
        .navigationBarColor(background: .darkRedBackground , titleColor: .lightWhite)
    }
}

#Preview {
    let localAuthVM = LocalAuthVM.shared
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
    
    CustomersRoleView()
        .environment(localAuthVM)
        .environment(restaurantOwnerSnapshotVM)
        .environment(restaurantOrderViewModel)
}
