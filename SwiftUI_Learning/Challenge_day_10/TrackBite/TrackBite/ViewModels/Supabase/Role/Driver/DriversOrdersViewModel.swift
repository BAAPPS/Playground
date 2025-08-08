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
    var localSaver: SaveDataLocallyVM<RestaurantOrderModel> {
        guard let userID = LocalAuthVM.shared.currentUser?.id else {
            return SaveDataLocallyVM(fileName: "drivers-orders.json")
        }
        return SaveDataLocallyVM(fileName: "drivers-orders-\(userID).json")
    }
    
    
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
    var orders: [RestaurantOrderModel] = []
    var enrichedOrders: [(order: RestaurantOrderModel, restaurant: RestaurantOwnerSnapshotModel)] = []
    
    
    private func enrichOrders(_ orders: [RestaurantOrderModel]) {
        let orderRestaurantIds = Set(orders.map { $0.restaurantId })
        let matchingSnapshots = restaurantOwnerSnapshotVM.allUserRestaurants.filter {
            orderRestaurantIds.contains($0.restaurantId)
        }
        
        self.enrichedOrders = orders.compactMap { order in
            guard let snapshot = matchingSnapshots.first(where: { $0.restaurantId == order.restaurantId }) else {
                return nil
            }
            return (order, snapshot)
        }
        
        print("✅ Enriched orders for driver:", self.enrichedOrders.count)
    }
    
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
                .eq("status", value: OrderStatus.pending.rawValue)
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
    
    
    func updateOrderAsDriver(_ order: RestaurantOrderModel) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let updatePayload = RestaurantOrderModel.RestaurantOrderPayload(
                customer_id: order.customerId,
                restaurant_id: order.restaurantId,
                driver_id: order.driverId,
                delivery_address: order.deliveryAddress,
                status: order.status,
                estimated_time_minutes: order.estimatedTimeMinutes,
                delivery_fee: order.deliveryFee,
                is_picked_up: order.isPickedUp,
                is_delivered: order.isDelivered,
                order_type: order.orderType
            )
            
            try await client
                .from(ordersTable.rawValue)
                .update(updatePayload)
                .eq("id", value: order.id)
                .execute()
            
            print("✅ Order updated by driver.")
            return true
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Driver order update failed:", error)
            return false
        }
    }
    
    @MainActor
    func fetchCurrentDriverOrders(forceRefresh: Bool = false) async {
        isLoading = true
        errorMessage = nil
        
        do {
            if !forceRefresh {
                do {
                    let cachedOrders = try localSaver.loadLocally()
                    if !cachedOrders.isEmpty {
                        self.orders = cachedOrders
                        print("✅ Loaded driver orders from local cache: \(orders.count)")
                        enrichOrders(cachedOrders)
                        isLoading = false
                        return
                    } else {
                        print("⚠️ Cached driver orders empty, fetching fresh data")
                    }
                } catch {
                    print("⚠️ No valid local cache, fetching from server.")
                }
            }
            
            
            guard let userID = LocalAuthVM.shared.currentUser?.id,
                  let userUUID = UUID(uuidString: userID) else {
                errorMessage = "No user ID found."
                isLoading = false
                return
            }
            
            print(userUUID)
            
            // Fetch orders assigned to this driver only
            let fetchedOrders: [RestaurantOrderModel] = try await client
                .from("orders")
                .select("*")
                .eq("driver_id", value: userUUID)
                .order("created_at", ascending: false)
                .execute()
                .value
            
            self.orders = fetchedOrders
            print("✅ Fetched driver orders: \(orders.count)")
            
            try localSaver.saveLocally(fetchedOrders)
            print("✅ Driver orders saved locally.")
            
            enrichOrders(fetchedOrders)
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Failed to fetch or cache driver orders:", error)
        }
        
        isLoading = false
    }
}

