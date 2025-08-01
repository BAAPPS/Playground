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
    static let shared = SupabaseAuthVM()
    private let client = SupabaseManager.shared.client
    let auth = LocalAuthVM.shared
    
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
            
            try await auth.cacheUserLocally(user)
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
                
                let createUser = SupabaseUser(id: user.idString, email: email, username: String(username), name: name, role: role, created_at: Date(),  hasCompletedOnboarding: false)
                
                
                try await client
                    .from("users")
                    .insert(createUser)
                    .execute()
                
                
                let success = KeychainManager.save(key: "supabase_refresh_token", value: session.refreshToken)
                if !success {
                    print("❌ Failed to save refresh token to Keychain.")
                }
                
                do {
                    try await auth.cacheUserLocally(createUser)
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
    
    func signIn(email: String, password: String) async throws -> SupabaseUser {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let session = try await client.auth.signIn(email: cleanEmail, password: password)
        
        // Store refresh token
        UserDefaults.standard.set(session.refreshToken, forKey: "supabase_refresh_token")
        
        let user = session.user
        
        let response = try await client
            .from("users")
            .select()
            .eq("id", value: user.idString)
            .single()
            .execute()
        
        let userData = response.data
        
        let decodedUser = try JSONDecoder().decodeSupabase(SupabaseUser.self, from: userData)
        
        print("✅ User fetched with onboarding status: \(decodedUser.hasCompletedOnboarding)")
        
        
        try await auth.cacheUserLocally(decodedUser)
        
        return decodedUser
    }
    
    func signOut() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        let isConnected = NetworkMonitorVM().networkMonitor.isConnected
        
        // Always clear local session
        auth.currentUser = nil
        auth.clearCachedUser()
        
        // Try to revoke remote session only if connected
        if isConnected {
            do {
                try await client.auth.signOut()
            } catch {
                errorMessage = "Signed out locally, but failed to revoke server session: \(error.localizedDescription)"
            }
        } else {
            errorMessage = "You're offline. Signed out locally, but your server session remains active."
        }
    }
    
    func updateAccountInfo(email: String, name: String, username: String) async throws {
        guard let userId = auth.currentUser?.id else {
            throw NSError(domain: "LocalAuthVM", code: 2, userInfo: [NSLocalizedDescriptionKey: "No current user"])
        }

    
        do {
            // Attempt to update the email in Supabase Auth
            // NOTE: This can fail if the email is invalid, not verified,
            // or if Supabase requires email confirmation for changes.
            // Since dummy or unverified emails are often rejected by Auth,
            // this update may throw an error, even though updating the users table succeeds.
            try await client.auth.update(user: UserAttributes(email: email))
//            print("✅ Email update initiated.")
        } catch {
            // Log the failure but continue to update the users table
//            print("❌ Auth email update failed:", error)
        }



        // 2. Update your own users table
        try await client
            .from("users")
            .update(["email": email, "name": name, "username": username])
            .eq("id", value: userId)
            .execute()

        // 3. Fetch updated user from Supabase
        if let updatedSupabaseUser = try await fetchCurrentUser() {
            try await auth.cacheUserLocally(updatedSupabaseUser)
        }
    }

    
    
    
}
