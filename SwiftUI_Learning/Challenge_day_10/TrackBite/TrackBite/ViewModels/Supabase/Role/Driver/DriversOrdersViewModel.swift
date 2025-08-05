//
//  DriversOrdersViewModel.swift
//  TrackBite
//
//  Created by D F on 8/5/25.
//

import Foundation
import MapKit

@Observable
class DriversOrdersViewModel {
    var isLoading = false
    var errorMessage: String?
    private let client = SupabaseManager.shared.client
    let restaurantOwnerSnapshotVM = RestaurantOwnerSnapshotVM.shared
    let localSaver = SaveDataLocallyVM<RestaurantOrderModel>(fileName: "drivers_delivery_orders.json")
    
    static let shared = DriversOrdersViewModel(
        orderModel: RestaurantOrderModel(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "",
            status: .inProgress,
            estimatedTimeMinutes: 0,
            deliveryFee: 0.0,
            isPickedUp: true,
            isDelivered: false,
            orderType: .pickup,
            createdAt: Date(),
            updatedAt: Date()
        )
    )
    
    
    init (orderModel: RestaurantOrderModel) {
        self.orderModel = orderModel
    }
    

    var orderModel: RestaurantOrderModel
    var ordersTable = TableName.orders
    var restaurantTable  = TableName.restaurants
    var restaurantDeliveryOrders:[RestaurantOrderModel] = []
    var restaurants: [RestaurantModel] = []
    
    func restaurantCoordinate(for order: RestaurantOrderModel) -> CLLocationCoordinate2D? {
        guard let restaurant = restaurants.first(where: { $0.id == order.restaurantId }) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
    }
    
    func restaurant(for order: RestaurantOrderModel) -> RestaurantModel? {
        restaurants.first(where: { $0.id == order.restaurantId })
    }


    @MainActor
    func fetchRestaurantsByIds(_ ids: [UUID]) async throws -> [RestaurantModel] {
        try await client
            .from(restaurantTable.rawValue)
            .select()
            .in("id", values: ids)
            .execute()
            .value
    }

    
    
    @MainActor
    func fetchAllDeliveryOrdersFromAllRestaurants() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch orders
            let orders: [RestaurantOrderModel] = try await client
                .from(ordersTable.rawValue)
                .select()
                .eq("order_type", value: OrderType.delivery.rawValue)
                .order("created_at", ascending: false)
                .execute()
                .value
            
            self.restaurantDeliveryOrders = orders
            
            // Extract unique restaurant IDs from orders
            let restaurantIds = Array(Set(orders.compactMap { $0.restaurantId }))
            
            // Fetch restaurants with those IDs
            self.restaurants = try await fetchRestaurantsByIds(restaurantIds)
            
            print("✅ Fetched \(orders.count) orders and \(restaurants.count) restaurants")
            
            try localSaver.saveLocally(orders)
            
        } catch {
            print("❌ Failed to fetch delivery orders or restaurants: \(error.localizedDescription)")
            errorMessage = "Failed to fetch delivery orders."
        }
        
        isLoading = false
    }


}
