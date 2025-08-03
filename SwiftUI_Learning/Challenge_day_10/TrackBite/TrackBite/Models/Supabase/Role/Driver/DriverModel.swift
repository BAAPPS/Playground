//
//  DriverModel.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import Foundation

struct DriverModel: Codable, Identifiable {
    let id: UUID
    let vehicle: Vehicle
    let licensePlate: String
    let isAvailable: Bool
    let createdAt: Date
    let deletedAt: Date?
    
    struct Vehicle: Codable {
        let make: String
        let model: String
        let year: Int
        let color: String
        let type: String
    }
    
    struct DriverUpdatePayload: Encodable {
        let vehicle: Vehicle
        let licensePlate: String
        let isAvailable: Bool
        
        enum CodingKeys: String, CodingKey {
            case vehicle
            case licensePlate = "license_plate"
            case isAvailable = "is_available"
        }
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case vehicle
        case licensePlate = "license_plate"
        case isAvailable = "is_available"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
    }
    
}
