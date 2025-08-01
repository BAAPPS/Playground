//
//  RestaurantModel.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import Foundation

struct RestaurantModel: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var description: String?
    var imageURL: String?
    var address: String
    let latitude: Double
    let longitude: Double
    var phone: String?
    var website: String?
    let ownerID: UUID
    let createdAt: Date
    
    struct RestaurantUpdatePayload: Encodable {
        var name: String
        var description: String?
        var imageURL: String?
        var address: String
        let latitude: Double
        let longitude: Double
        var phone: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case description
            case imageURL = "image_url"
            case address
            case latitude
            case longitude
            case phone
        }
    }
    

    enum CodingKeys: String, CodingKey {
        case id, name, address, latitude, longitude, phone, website
        case description
        case imageURL = "image_url"
        case ownerID = "owner_id"
        case createdAt = "created_at"
    }
}
