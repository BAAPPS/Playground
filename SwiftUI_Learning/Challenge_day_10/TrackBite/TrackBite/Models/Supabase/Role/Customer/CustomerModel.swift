//
//  CustomerModel.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import Foundation

struct CustomerModel: Codable, Identifiable {
    let id: UUID
    let address: String
    let phoneNumber: String
    let preferredPayment: String
    let deletedAt: Date?
    let createdAt: Date
    
    struct CustomerUpdatePayload: Encodable {
        let address: String
        let phoneNumber: String
        let preferredPayment: String
        
        enum CodingKeys: String, CodingKey {
            case address
            case phoneNumber = "phone_number"
            case preferredPayment = "preferred_payment"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case address
        case phoneNumber = "phone_number"
        case preferredPayment = "preferred_payment"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
    }
}
