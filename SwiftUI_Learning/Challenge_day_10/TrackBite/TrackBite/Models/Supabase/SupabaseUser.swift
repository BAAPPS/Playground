//
//  UserModel.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import Foundation

struct SupabaseUser: Codable, Identifiable {
    let id : String
    let email: String
    let username: String
    let name: String
    let role: UserRole
    let created_at: Date?
}
