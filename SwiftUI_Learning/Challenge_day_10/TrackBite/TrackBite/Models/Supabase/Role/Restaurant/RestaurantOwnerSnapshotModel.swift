//
//  RestaurantOwnerSnapshot.swift
//  TrackBite
//
//  Created by D F on 8/3/25.
//

import Foundation

struct RestaurantOwnerSnapshotModel: Codable, Identifiable, Hashable {
    let id: UUID
    let userId: UUID
    let userName: String
    let userEmail: String
    let restaurantId: UUID
    let restaurantName: String
    let snapshotCreatedAt: Date
    var description: String?
    var imageURL: String?
    var address: String
    var phone: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case userName = "user_name"
        case userEmail = "user_email"
        case restaurantId = "restaurant_id"
        case restaurantName = "restaurant_name"
        case snapshotCreatedAt = "snapshot_created_at"
        case description
        case imageURL = "image_url"
        case address
        case phone
    }
}
