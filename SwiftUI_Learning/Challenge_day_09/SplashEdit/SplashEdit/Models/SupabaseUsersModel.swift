//
//  SupabaseUsersModel.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import Foundation

struct SupabaseUsersModel:Codable, Identifiable {
    let id: UUID
    let username: String
    let created_at: Date
}
