//
//  PublicUserViewModel.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import Foundation

import Supabase
import Observation
import SwiftData

@Observable
class PublicUserViewModel {
    
    var users: [PublicUserModel] = []
    var errorMessage: String?
    var isLoading = false
    
    private let client = SupabaseManager.shared.client
    
    func fetchRecentUsers(context: ModelContext) async {
        isLoading = true
        errorMessage = nil
        defer {isLoading = false}
        
        do {
            let response = try await client
                .from("public_recent_users")
                .select()
                .order("created_at", ascending: false)
                .limit(50)
                .execute()
            
            let data = response.data
            let newUsers = try JSONDecoder().decodeSupabase([PublicUserModel].self, from: data)
            
            // Only assign when successful
            users = newUsers
            for user in users {
                let fetchRequest = FetchDescriptor<UserProfile>(
                    predicate: #Predicate { $0.id == user.id }
                )
                do {
                    let existing = try context.fetch(fetchRequest)
                    if existing.isEmpty {
                        let cached = UserProfile(id: user.id, username: user.username, created_at: user.createdAt)
                        context.insert(cached)
                    }
                } catch {
                    print("⚠️ Failed to fetch existing user: \(error.localizedDescription)")
                }
            }
            
            
            try context.save()
            
        }
        catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
}
