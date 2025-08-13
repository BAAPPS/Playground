//
//  SupabaseManager.swift
//  DramaBox
//
//  Created by D F on 8/12/25.
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

