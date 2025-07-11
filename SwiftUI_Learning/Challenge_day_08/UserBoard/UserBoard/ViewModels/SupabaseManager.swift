//
//  SupabaseClient.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(
            supabaseURL: SupabaseClientModel.url,
            supabaseKey: SupabaseClientModel.anonKey
        )
    }
}

