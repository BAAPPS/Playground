//
//  RestaurantOrderView.swift
//  TrackBite
//
//  Created by D F on 8/1/25.
//

import SwiftUI

struct RestaurantOrderView: View {
    @Environment(RestaurantOrderViewModel.self) var restaurantOrderViewModel
    
    var body: some View {
        VStack {
            if restaurantOrderViewModel.isLoading {
                ProgressView("Loading Orders...")
            } else if let error = restaurantOrderViewModel.errorMessage {
                Text("❌ \(error)")
                    .foregroundColor(.red)
            } else if restaurantOrderViewModel.restaurantCustomerOrders.isEmpty {
                ContentUnavailableView(
                    "No Orders Yet",
                    systemImage: "cart.badge.questionmark",
                    description: Text("Cusomters haven't placed any orders yet. Check back soon!")
                )
            } else {
                RestaurantOrdersListView()
            }
        }
        .navigationTitle("My Orders")
        .backButton()
        .task {
            await restaurantOrderViewModel.fetchOrdersForCurrentUserRestaurants()
            print("🧾 Orders:", restaurantOrderViewModel.restaurantCustomerOrders)
        }
    }
}

#Preview {
    let dummyOrders: [RestaurantOrderModel] = [
        RestaurantOrderModel(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "123 Main St",
            status: .pending,
            estimatedTimeMinutes: 15,
            deliveryFee: 5.0,
            isPickedUp: false,
            isDelivered: false,
            orderType: .delivery,
            createdAt: Date(),
            updatedAt: Date()
        ),
        RestaurantOrderModel(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "",
            status: .completed,
            estimatedTimeMinutes: 10,
            deliveryFee: 0.0,
            isPickedUp: true,
            isDelivered: true,
            orderType: .pickup,
            createdAt: Date().addingTimeInterval(-3600),
            updatedAt: Date()
        )
    ]

    let mockVM = RestaurantOrderViewModel(
        orderModel: dummyOrders.first!
    )
    mockVM.restaurantCustomerOrders = dummyOrders

    return NavigationStack {
        RestaurantOrderView()
            .environment(mockVM)
    }
}
