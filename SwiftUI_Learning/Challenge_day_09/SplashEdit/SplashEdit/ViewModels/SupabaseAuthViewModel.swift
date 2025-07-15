//
//  SupabaseAuthViewModel.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import Foundation
import Supabase
import Observation

@Observable
class SupabaseAuthViewModel {
    var isLoading = false
    var errorMessage: String?
    
    private let client = SupabaseManager.shared.client
    
    private let userDefaultKey = "currentUserCached"
    
    
    var currentUser: SupabaseUsersModel?
    
    func cachedCurrentUser(_ profile: SupabaseUsersModel) {
        let data = try? JSONEncoder().encode(profile)
        UserDefaults.standard.set(data, forKey: userDefaultKey)
    }
    
    func loadCachedUser() -> SupabaseUsersModel? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultKey),
              let user = try? JSONDecoder().decode(SupabaseUsersModel.self, from: data) else {
            return nil
        }
        
        return user
    }
    
    func signUp(email: String, password: String, username:String) async {
        isLoading = true
        errorMessage = nil
        do {
            let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            print("Attempting signup with email: \(cleanEmail)")
            
            let session = try await client.auth.signUp(
                email: cleanEmail,
                password: password
            )
            
            let user = session.user
            
            let createUser = SupabaseUsersModel(id: user.id, username:username, created_at: Date())
            
            try await client
                .from("users")
                .insert(createUser)
                .execute()
            
            currentUser = createUser
            
            cachedCurrentUser(createUser)
            
        }catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let session = try await client.auth.signIn(email: cleanEmail, password: password)
            let user = session.user
            
            let id = user.id
            let idString = id.uuidString
            
            do {
                let response = try await client
                    .from("users")
                    .select()
                    .eq("id", value: idString)
                    .single()
                    .execute()
                
                let userData = response.data
                
                print(String(data: userData, encoding: .utf8) ?? "No data")
                
                let decodeUser = try JSONDecoder().decodeSupabase(SupabaseUsersModel.self, from: userData)
                
                currentUser = decodeUser
                
                cachedCurrentUser(decodeUser)
                
            } catch {
                errorMessage = "Failed to decode user: \(error.localizedDescription)"
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
}
