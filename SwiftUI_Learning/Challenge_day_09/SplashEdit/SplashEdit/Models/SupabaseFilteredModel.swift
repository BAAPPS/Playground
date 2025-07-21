//
//  SupabaseFilteredModel.swift
//  SplashEdit
//
//  Created by D F on 7/20/25.
//

import Foundation

struct SupabaseFilteredModel: Codable, Identifiable {
    let id: UUID?
    let liked_photo_id: UUID?
    let created_user: UUID
    let filtered_name: String
    let filtered_url: String
    let original_url: String
    let created_at: Date?       
}
