//
//  SupabaseAuthViewModel.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//
// NOTE:
// Refresh tokens are currently stored in UserDefaults for development ease.
// For production, migrate token storage to the iOS Keychain for security.

import Foundation
import Supabase
import Observation


@Observable
class SupabaseAuthViewModel {
    var isLoading = false
    var errorMessage: String?
    var networkMonitor = NetworkMonitorModel()
    
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
    
    func restoreSession() async {
        print("🔁 Attempting to restore session...")
        
        if !networkMonitor.isConnected {
            print("⚠️ Offline: loading cached user without refreshing session")
            if let cachedUser = loadCachedUser() {
                currentUser = cachedUser
            }
            return
        }
        
        // MARK: - TODO (Production)
        // Currently using UserDefaults to store refresh tokens for simplicity during development.
        // For production apps, **store sensitive tokens securely in the Keychain** instead of UserDefaults,
        // to protect user privacy and prevent unauthorized access.
        guard let refreshToken = UserDefaults.standard.string(forKey: "supabase_refresh_token") else {
            print("🚫 No refresh token found")
            return
        }
        
        do {
            let session = try await client.auth.refreshSession(refreshToken: refreshToken)
            print("✅ Session restored for: \(session.user.email ?? "unknown") with the following id: \(session.user.id.uuidString)")
            
            // Fetch your custom user from your "users" table
            let idString = session.user.id.uuidString
            
            let response = try await client
                .from("users")
                .select()
                .eq("id", value: idString)
                .single()
                .execute()
            
            let userData = response.data
            let decodeUser = try JSONDecoder().decodeSupabase(SupabaseUsersModel.self, from: userData)
            
            self.currentUser = decodeUser
            cachedCurrentUser(decodeUser)
            
            // Re-store updated refresh token if Supabase gives you a new one
            let newRefreshToken = session.refreshToken
            
            UserDefaults.standard.set(newRefreshToken, forKey: "supabase_refresh_token")
            
            
        } catch {
            print("❌ Failed to refresh session: \(error.localizedDescription)")
            // Optionally: log out completely if the refresh token is invalid
            self.currentUser = nil
            UserDefaults.standard.removeObject(forKey: "supabase_refresh_token")
            UserDefaults.standard.removeObject(forKey: userDefaultKey)
        }
    }
    
    
    func clearCachedUser(){
        UserDefaults.standard.removeObject(forKey: userDefaultKey)
    }
    
    
    
    
    func signUp(email: String, password: String, username:String) async {
        isLoading = true
        errorMessage = nil
        do {
            let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            print("Attempting signup with email: \(cleanEmail)")
            
            let response = try await client.auth.signUp(email: cleanEmail, password: password)
            
            if let session = response.session {
                let user = session.user
                
                let createUser = SupabaseUsersModel(id: user.id, username: username, created_at: Date())
                
                try await client
                    .from("users")
                    .insert(createUser)
                    .execute()
                
                currentUser = createUser
                cachedCurrentUser(createUser)
                
                // Save refresh token
                UserDefaults.standard.set(session.refreshToken, forKey: "supabase_refresh_token")
                
            } else {
                print("ℹ️ Sign-up successful, but session is nil (maybe needs email confirmation?)")
                // Optionally show user a message to confirm email
            }
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
            
            // Store refresh token
            UserDefaults.standard.set(session.refreshToken, forKey: "supabase_refresh_token")
            
            
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
    
    
    func toggleLike(for photo: PhotoModel) async -> Bool {
        guard let userId = client.auth.currentUser?.id else {
            print("User not logged in")
            return false
        }

        do {
            // Check if the photo is already liked by user
            let response = try await client
                .from("liked_photo")
                .select()
                .eq("user_id", value: userId.uuidString)
                .eq("unsplash_id", value: photo.unsplash_id)
                .execute()

            let likedPhotos = try JSONDecoder.supabaseJSONDecoder().decode([PhotoModel].self, from: response.data)

            if let existing = likedPhotos.first {
                // Safely unwrap existing.id, assuming id is optional
                guard let existingID = existing.id else {
                    print("Error: existing liked photo missing id")
                    return false
                }

                try await client
                    .from("liked_photo")
                    .delete()
                    .eq("id", value: existingID.uuidString)
                    .execute()

                print("💔 Like removed")
                return false
            } else {
                // Insert like (add liked photo)
                try await client
                    .from("liked_photo")
                    .insert([
                        "user_id": userId.uuidString,
                        "unsplash_id": photo.unsplash_id,
                        "original_url": photo.original_url,
                        "liked_by": photo.liked_by
                    ])
                    .execute()

                print("❤️ Photo liked")
                return true
            }
        } catch {
            print("Error toggling like: \(error.localizedDescription)")
            return false
        }

    }

    
    func hasUserLikedPhoto(unsplashID: String) async -> Bool {
        guard let userId = client.auth.currentUser?.id else {
            print("User not logged in")
            return false
        }

        do {
            let response = try await client
                .from("liked_photo")
                .select()
                .eq("user_id", value: userId.uuidString)
                .eq("unsplash_id", value: unsplashID)
                .execute()

            // Since response.data is Data, decode to [PhotoModel] or a smaller model representing liked photos
            let likedPhotos = try JSONDecoder.supabaseJSONDecoder().decode([PhotoModel].self, from: response.data)
            return !likedPhotos.isEmpty
        } catch {
            print("Error checking like status: \(error.localizedDescription)")
            return false
        }
    }


    
}
