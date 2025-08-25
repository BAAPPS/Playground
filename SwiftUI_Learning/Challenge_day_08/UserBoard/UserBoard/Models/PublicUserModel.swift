//
//  PublicUserModel.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import Foundation

struct PublicUserModel: Codable, Identifiable {
    var id = UUID()
    let username: String
    let createdAt: Date
    
    
    enum CodingKeys: String, CodingKey{
        case username
        case createdAt = "created_at"
    }
}

extension PublicUserModel: UserDisplayable {}
