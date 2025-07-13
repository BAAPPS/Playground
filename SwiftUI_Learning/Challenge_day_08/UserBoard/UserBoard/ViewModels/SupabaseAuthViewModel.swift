//
//  SupabaseAuthViewModel.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import Foundation
import Supabase
import Observation

extension Notification.Name {
    static let userDidUpdate = Notification.Name("userDidUpdate")
}



@Observable
class SupabaseAuthViewModel {
    var isLoading = false
    var errorMessage: String?
    var networkMonitor = NetworkMonitorModel()
    
    private let client = SupabaseManager.shared.client
    
    private let userDefaultsKey = "cachedCurrentUser"
    
    
    // Private backing storage
      private var _currentUser: SupabaseProfileModel?
      
      // Computed property with setter logic
      var currentUser: SupabaseProfileModel? {
          get { _currentUser }
          set {
              let oldValue = _currentUser
              _currentUser = newValue
              
              // Only notify if username changed (or you can customize this)
              if oldValue?.username != newValue?.username {
                  print("✅ currentUser changed: \(oldValue?.username ?? "nil") → \(newValue?.username ?? "nil")")
                  
                  // Notify observers
                  NotificationCenter.default.post(name: .userDidUpdate, object: newValue)
              }
          }
      }
    
    func cacheCurrentUser(_ profile: SupabaseProfileModel) {
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func loadCachedUser() -> SupabaseProfileModel? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let profile = try? JSONDecoder().decode(SupabaseProfileModel.self, from: data) else {
            return nil
        }
        return profile
    }
    
    func restoreSession() async {
        print("🔁 Attempting to restore session...")
        
        do {
            let session = try await client.auth.session
            print("✅ Supabase session exists for user: \(session.user.email ?? "unknown")")
        } catch {
            print("⚠️ No active Supabase session found: \(error)")
        }
        
        if let cachedUser = loadCachedUser() {
            print("✅ Loaded cached user: \(cachedUser.username)")
            currentUser = cachedUser
        } else {
            print("🚫 No cached user found")
        }
    }
    
    
    func clearCachedUser() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    func updateCurrentUserProfile(username: String) async -> Bool {
        guard let user = currentUser else {
            errorMessage = "No current user to update"
            return false
        }
        
        guard networkMonitor.isConnected else {
            errorMessage = "No internet connection. Cannot update profile"
            return false
        }
        isLoading = true
        errorMessage = nil
        
        do
        {
            let updatedProfile = SupabaseProfileModel(id: user.id, username: username, createdAt: user.createdAt)
            try await client
                .from("profiles")
                .update(updatedProfile)
                .eq("id", value: user.id.uuidString)
                .execute()
            
            currentUser = updatedProfile
            cacheCurrentUser(updatedProfile)
            
            isLoading = false
            return true
            
        }
        catch {
            errorMessage = "Failed to update profile: \(error.localizedDescription)"
        }
        
        isLoading = false
        
        return false
    }
    
    
    
    func signUp(email: String, password: String, username: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
            print("Attempting signup with email: \(cleanEmail)")
            
            
            let session = try await client.auth.signUp(email: cleanEmail, password: password)
            let user = session.user
            
            
            
            // Create the profile model with current date/time
            let profile = SupabaseProfileModel(id: user.id, username: username, createdAt: Date())
            
            // Insert profile into your 'profiles' table
            try await client
                .from("profiles")
                .insert(profile)
                .execute()
            
            // Update the currentUser property to trigger UI updates
            currentUser = profile
            
            
            cacheCurrentUser(profile)
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signIn(email: String, password:String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let session = try await client.auth.signIn(email: cleanEmail, password: password)
            let user = session.user
            
            let id = user.id
            let idString = id.uuidString
            
            do{
                let response = try await client
                    .from("profiles")
                    .select()
                    .eq("id", value: idString)
                    .single()
                    .execute()
                
                
                
                let profileData = response.data
                print(String(data: profileData, encoding: .utf8) ?? "No data")
                
                let profile = try JSONDecoder().decodeSupabase(SupabaseProfileModel.self, from: profileData)
                currentUser = profile
                cacheCurrentUser(profile)
                
            }
            catch {
                errorMessage = "Failed to decode profile: \(error.localizedDescription)"
            }
            
        }
        catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    
    func logout() async {
        isLoading = true
        errorMessage = nil
        
        do{
            try await client.auth.signOut()
            currentUser = nil
            
            clearCachedUser()
        }
        catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
}

