//
//  RestaurantOrderModel.swift
//  TrackBite
//
//  Created by D F on 8/3/25.
//

import Foundation

struct RestaurantOrderModel: Codable, Identifiable, Hashable {
    let id: UUID
    let customerId: UUID
    let restaurantId: UUID
    var driverId: UUID?
    
    var deliveryAddress: String
    var status: OrderStatus
    var estimatedTimeMinutes: Int?
    var deliveryFee: Double?
    var isPickedUp: Bool?
    var isDelivered: Bool?
    var orderType: OrderType
    var createdAt: Date?
    var updatedAt: Date?
    
    var isCompleted: Bool {
        status == .completed || isDelivered == true
    }
    
    var orderStatus: Bool {
        isPickedUp == true || isDelivered == true
    }
    
    
    struct RestaurantOrderPayload: Codable {
        var customer_id: UUID
        var restaurant_id: UUID
        var driver_id: UUID?
        var delivery_address: String
        var status: OrderStatus
        var estimated_time_minutes: Int?
        var delivery_fee: Double?
        var is_picked_up: Bool?
        var is_delivered: Bool?
        var order_type: OrderType
        
    }
    
    struct CustomerRestaurantOrderPayload: Codable {
        var customer_id: UUID
        var restaurant_id: UUID
        var delivery_address: String
        var order_type: OrderType
    }
    
    struct CustomerOrderLookUpPayload: Codable {
        var customer_id: UUID
    }
    
    enum CodingKeys: String,  CodingKey {
        case id
        case customerId = "customer_id"
        case restaurantId = "restaurant_id"
        case driverId = "driver_id"
        case deliveryAddress = "delivery_address"
        case status
        case estimatedTimeMinutes = "estimated_time_minutes"
        case deliveryFee = "delivery_fee"
        case isPickedUp = "is_picked_up"
        case isDelivered = "is_delivered"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case orderType = "order_type"
    }
}

