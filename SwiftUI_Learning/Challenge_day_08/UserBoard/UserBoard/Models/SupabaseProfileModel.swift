//
//  SupabaseProfileModel.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import Foundation

struct SupabaseProfileModel: Codable, Identifiable {
    let id: UUID
    let username: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id
        case username
        case createdAt = "created_at"
    }
    
}
