//
//  LocalUsers.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import Foundation
import SwiftData

@Model
class LocalUser {
    @Attribute(.unique) var id: String
    var email: String
    var username: String
    var name: String
    var role: UserRole
    var created_at: Date?
    
    init(id: String, email: String, username: String, name: String, role: UserRole, created_at: Date? = .now) {
        self.id = id
        self.email = email
        self.username = username
        self.name = name
        self.role = role
        self.created_at = created_at
    }
}
