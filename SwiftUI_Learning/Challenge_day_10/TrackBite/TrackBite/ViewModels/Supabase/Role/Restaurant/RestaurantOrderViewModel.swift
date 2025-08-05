//
//  RestaurantOrderViewModel.swift
//  TrackBite
//
//  Created by D F on 8/3/25.
//

import Foundation

@Observable

class RestaurantOrderViewModel {
    var isLoading = false
    var errorMessage: String?
    
    let localSaver = SaveDataLocallyVM<RestaurantOrderModel>(fileName: "restaurant_orders.json")
    
    static let shared = RestaurantOrderViewModel(
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
        self.deliveryAddress = orderModel.deliveryAddress
        self.status = orderModel.status
        self.estimatedTimeMinutes = orderModel.estimatedTimeMinutes
        self.deliveryFee = orderModel.deliveryFee
        self.isPickedUp = orderModel.isPickedUp
        self.isDelivered = orderModel.isDelivered
        self.orderType = orderModel.orderType
    }
    
    private let client = SupabaseManager.shared.client
    var orderModel: RestaurantOrderModel
    var ordersTable = TableName.orders
    var orders:[RestaurantOrderModel] = []
    var restaurantCustomerOrders:[RestaurantOrderModel] = []
    
    
    var deliveryAddress: String = ""
    var status: OrderStatus
    var estimatedTimeMinutes: Int? = 0
    var deliveryFee: Double? = 0.0
    var isPickedUp: Bool? = false
    var isDelivered: Bool? = false
    var orderType: OrderType
    var selectedOrder: RestaurantOrderModel?
    
    var groupedOrders: [GroupedOrderKey: [RestaurantOrderModel]] {
        Dictionary(grouping: restaurantCustomerOrders) {
            GroupedOrderKey(status: $0.status, type: $0.orderType)
        }
    }
    
    func updateCustomerOrder(_ order: RestaurantOrderModel) async  -> Bool {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false } 
        
        do {
            let updatePayload = RestaurantOrderModel.RestaurantOrderPayload(
                customer_id: order.customerId,
                restaurant_id: order.restaurantId,
                driver_id: order.driverId,
                delivery_address: deliveryAddress,
                status: order.status,
                estimated_time_minutes: order.estimatedTimeMinutes,
                delivery_fee: order.deliveryFee,
                is_picked_up: order.isPickedUp,
                is_delivered: order.isDelivered,
                order_type: orderType)
            
            print("Updated payload:", updatePayload)
            
            try await client
                .from("\(ordersTable)")
                .update(updatePayload)
                .eq("id",value: order.id)
                .execute()
            
            print("✅ Order updated.")
            
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Order update failed:", error)
            return false
        }
    }
    
    
    func addCustomerOrder(_ order: RestaurantOrderModel) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let payload = RestaurantOrderModel.CustomerRestaurantOrderPayload(
                customer_id: order.customerId,
                restaurant_id: order.restaurantId,
                delivery_address: order.deliveryAddress,
                order_type: order.orderType
            )
            
            
            print("payload:", payload)
            
            
            try await client
                .from("orders")
                .insert([payload])
                .execute()
            
            print("✅ Order Added.")
            
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Order insert failed:", error)
        }
        
        
        isLoading = false
    }
    
    @MainActor
    func fetchOrdersForCurrentUserRestaurants() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Step 1: Get the current user's restaurants
            await RestaurantVM.shared.fetchAllRestaurantsForCurrentUser()
            let userRestaurants = RestaurantVM.shared.restaurants
            
            guard !userRestaurants.isEmpty else {
                errorMessage = "No restaurants found for this user."
                isLoading = false
                return
            }
            
            // Step 2: Collect restaurant IDs
            let restaurantIDs = userRestaurants.map { $0.id.uuidString }
            
            // Step 3: Fetch all orders that match any of those restaurant IDs
            let fetchedOrders: [RestaurantOrderModel] = try await client
                .from("orders")
                .select("*")
                .in("restaurant_id", values: restaurantIDs)
                .order("created_at", ascending: false)
                .execute()
                .value
            
            if self.restaurantCustomerOrders != fetchedOrders {
                self.restaurantCustomerOrders = fetchedOrders
            }
            
            print("✅ Loaded \(fetchedOrders.count) orders from all your restaurants.")
            
            // Save locally
            try localSaver.saveLocally(fetchedOrders)
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Failed to fetch or cache orders:", error)
        }
        
        isLoading = false
    }
    
}

