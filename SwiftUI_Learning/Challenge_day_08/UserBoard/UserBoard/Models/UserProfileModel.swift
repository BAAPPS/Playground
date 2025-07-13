//
//  UserProfileModel.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import Foundation
import SwiftData

@Model
class UserProfile: Identifiable {
    @Attribute(.unique) var id: UUID
    var username: String
    var created_at: Date
    
    var createdAt: Date { created_at }


    init(id: UUID, username: String, created_at: Date) {
        self.id = id
        self.username = username
        self.created_at = created_at
    }
}

extension UserProfile: UserDisplayable {}
