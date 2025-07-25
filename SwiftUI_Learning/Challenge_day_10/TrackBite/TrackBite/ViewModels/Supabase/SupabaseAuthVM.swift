//
//  SupabaseAuthVM.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import Foundation
import Observation
import Supabase

@Observable
class SupabaseAuthVM {
    var isLoading = false
    var errorMessage: String?
    private let client = SupabaseManager.shared.client

    func fetchCurrentUser() async throws -> SupabaseUser? {
        do {
            let userId = try await client.auth.session.user.id
            let response = try await client
                .from("users")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
            
            let data = response.data
            
            let user = try JSONDecoder.supabaseJSONDecoder().decode(SupabaseUser.self, from: data)
            
            try await LocalAuthVM.shared.cacheUserLocally(user)
            return user
            
        } catch {
            print("Error fetching user:", error.localizedDescription)
            return nil
        }
        
    }
    
    
    func signUp(name:String, email: String, password: String, role: UserRole) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            print("Attempting signup with email: \(cleanEmail)")
            
            let response = try await client.auth.signUp(email: cleanEmail, password: password)
            print("✅ Sign-up response received")
            
            
            
            if let session = response.session {
//                print("✅ Session created: \(session)")
                let user = session.user
                let username = user.email?.split(separator: "@").first ?? ""
                
                let createUser = SupabaseUser(id: user.idString, email: email, username: String(username), name: name, role: role, created_at: Date())
                
                
                try await client
                    .from("users")
                    .insert(createUser)
                    .execute()
                
                
                let success = KeychainManager.save(key: "supabase_refresh_token", value: session.refreshToken)
                if !success {
                    print("❌ Failed to save refresh token to Keychain.")
                }
                
                do {
                    try await LocalAuthVM.shared.cacheUserLocally(createUser)
                } catch {
                    print("Failed to cache user locally: \(error.localizedDescription)")
                }
                
                
            }else {
                print("ℹ️ Sign-up successful, but session is nil (maybe needs email confirmation?)")
            }
            
        } catch {
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
            
            // Store refresh token
            UserDefaults.standard.set(session.refreshToken, forKey: "supabase_refresh_token")
            
            let user = session.user

            do {
                let response = try await client
                    .from("users")
                    .select()
                    .eq("id", value: user.idString)
                    .single()
                    .execute()
                
                let userData = response.data
                
                print(String(data: userData, encoding: .utf8) ?? "No data")
                
                let decodeUser = try JSONDecoder().decodeSupabase(SupabaseUser.self, from: userData)
                
                do {
                    try await LocalAuthVM.shared.cacheUserLocally(decodeUser)
                } catch {
                    print("Failed to cache user locally: \(error.localizedDescription)")
                }
                
            } catch {
                errorMessage = "Failed to decode user: \(error.localizedDescription)"
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
