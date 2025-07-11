//
//  UserProfileModel.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import Foundation
import SwiftData

@Model
class UserProfile {
    var id: String
    var username: String
    var created_at: Date
    
    init(id: String, username: String, created_at: Date) {
        self.id = id
        self.username = username
        self.created_at = created_at
    }
}
