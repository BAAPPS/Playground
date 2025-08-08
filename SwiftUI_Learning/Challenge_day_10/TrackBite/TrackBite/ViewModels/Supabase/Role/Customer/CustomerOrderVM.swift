//
//  CustomerOrderVM.swift
//  TrackBite
//
//  Created by D F on 8/4/25.
//

import Foundation

@Observable
class CustomerOrderVM {
    var isLoading = false
    var errorMessage: String?
    private let client = SupabaseManager.shared.client
    
    var orderModel: RestaurantOrderModel
    var orders:[RestaurantOrderModel] = []
    var enrichedOrders: [(order: RestaurantOrderModel, restaurant: RestaurantOwnerSnapshotModel)] = []
    let restaurantOwnerSnapshotVM = RestaurantOwnerSnapshotVM.shared
    var localSaver: SaveDataLocallyVM<RestaurantOrderModel> {
        guard let userID = LocalAuthVM.shared.currentUser?.id else {
            return SaveDataLocallyVM(fileName: "customers-order.json")
        }
        return SaveDataLocallyVM(fileName: "customers-order-\(userID).json")
    }
    
    static let shared = CustomerOrderVM(orderModel: RestaurantOrderModel(id: UUID(), customerId: UUID(), restaurantId: UUID(), driverId: UUID(), deliveryAddress: "", status: .inProgress, estimatedTimeMinutes: 0, deliveryFee: 8.0, isPickedUp: false, isDelivered: false, orderType: .pickup, createdAt: Date(), updatedAt: Date()))
    
    
    
    init (orderModel: RestaurantOrderModel) {
        self.orderModel = orderModel
    }
    
    private func enrichOrders(_ orders: [RestaurantOrderModel]) {
        // Step 1: Extract restaurant IDs from the current orders
        let orderRestaurantIds = Set(orders.map { $0.restaurantId })

        // Step 2: Filter snapshots to just the restaurants in those orders
        let matchingSnapshots = restaurantOwnerSnapshotVM.allUserRestaurants.filter {
            orderRestaurantIds.contains($0.restaurantId)
        }

        // Step 3: Build enriched order list
        self.enrichedOrders = orders.compactMap { order in
            guard let matchingSnapshot = matchingSnapshots.first(where: { $0.restaurantId == order.restaurantId }) else {
                return nil
            }
            return (order, matchingSnapshot)
        }

        print("✅ Enriched orders for customer:", self.enrichedOrders.count)
    }

    
    @MainActor
    func currentUserOrders(forceRefresh: Bool = false) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Try to load from local cache first, unless forceRefresh is true
            if !forceRefresh {
                do {
                    let cachedOrders = try localSaver.loadLocally()
                    self.orders = cachedOrders
                    print("✅ Loaded orders from local cache: \(orders.count)")
                    
                    enrichOrders(cachedOrders)
                    isLoading = false
                    return
                } catch {
                    print("⚠️ Local cache missing or invalid. Fetching from server instead.")
                    // Fallback: proceed to fetch fresh data below
                }
            }
            
            // Fetch fresh data from Supabase
            guard let userID = LocalAuthVM.shared.currentUser?.id,
                  let userUUID = UUID(uuidString: userID) else {
                errorMessage = "No user ID found."
                isLoading = false
                return
            }
            
            let fetchedOrders: [RestaurantOrderModel] = try await client
                .from("orders")
                .select("*")
                .eq("customer_id", value: userUUID)
                .order("created_at", ascending: false)
                .execute()
                .value
            
            self.orders = fetchedOrders
            print("✅ Fetched customer orders: \(orders.count)")
            
            try localSaver.saveLocally(fetchedOrders)
            print("✅ Orders saved locally.")
            
            // Enrich with restaurant snapshots
            enrichOrders(fetchedOrders)
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Failed to fetch or cache orders:", error)
        }
        
        isLoading = false
    }
    
}
