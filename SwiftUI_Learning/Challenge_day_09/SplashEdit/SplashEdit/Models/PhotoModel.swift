//
//  PhotoModel.swift
//  SplashEdit
//
//  Created by D F on 7/18/25.
//

import Foundation

struct PhotoModel: Codable, Identifiable {
    let id: UUID?                // Optional since DB generates this on insert
    let user_id: UUID
    let unsplash_id: String
    let original_url: String
    let liked_by: String
    let created_at: Date?        // Optional timestamp
}
