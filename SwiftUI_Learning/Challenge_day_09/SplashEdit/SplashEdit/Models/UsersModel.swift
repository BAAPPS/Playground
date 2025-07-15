//
//  UsersModel.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import Foundation
import SwiftData

@Model
class UsersModel {
    @Attribute(.unique) var id: UUID
    var username: String
    var created_at: Date
    
    init(id: UUID, username: String, created_at: Date) {
        self.id = id
        self.username = username
        self.created_at = created_at
    }
}
