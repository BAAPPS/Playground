//
//  PublicUserViewModel.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import Foundation

import Supabase
import Observation

@Observable
class PublicUserViewModel {
    
    var users: [PublicUserModel] = []
     var errorMessage: String?
     var isLoading = false
    
    private let client = SupabaseManager.shared.client
    
    func fetchRecentUsers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await client
                .from("public_recent_users")
                .select()
                .order("created_at", ascending: false)
                .limit(50)
                .execute()
            
            let data = response.data
            
            users = try JSONDecoder().decodeSupabase([PublicUserModel].self, from: data)
           
        }
        catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
}
