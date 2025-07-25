//
//  SupabaseManager.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient
    let url: URL
    
   private init(){
        client = SupabaseClient(supabaseURL: Client.url, supabaseKey: Client.anonkey)
        url = Client.url
    }
}
