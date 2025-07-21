//
//  SupabaseManager.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient
    let url: URL
    
    private init() {
        client = SupabaseClient(supabaseURL: SupabaseClientModel.url, supabaseKey: SupabaseClientModel.anonKey)
        url = SupabaseClientModel.url
    }
}
