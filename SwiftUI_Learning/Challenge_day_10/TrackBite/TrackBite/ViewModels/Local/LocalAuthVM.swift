//  LocalAuthVM.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import Foundation
import Observation
import SwiftData

@Observable
class LocalAuthVM {
    static let shared = LocalAuthVM()
    var client = SupabaseManager.shared.client
    var userDefaultsKey = "cachedUserID"
    
    var currentUser: LocalUser? = nil
    
    // Stored property that notifies SwiftUI
    var didCompleteOnboarding: Bool = false {
        didSet {
            UserDefaults.standard.set(didCompleteOnboarding, forKey: "hasCompletedOnboarding")
        }
    }

    var hasCompletedOnboarding: Bool {
        get {
            didCompleteOnboarding
        }
    }

    init() {
        // Load from UserDefaults at launch
        self.didCompleteOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }

    func setCompletedOnboarding() {
        self.didCompleteOnboarding = true
        print("✅ Onboarding completion flag saved to UserDefaults")
    }

    var modelContext: ModelContext? {
        didSet {
            Task {
                await loadCachedUserFromID()
            }
        }
    }
    
    // MARK: - Mark Onboarding Complete In Supabase
    func markOnboardingCompleteInSupabase() async {
        guard let currentUser = currentUser else {
            print("❌ No current user")
            return
        }

        do {
            try await client
                .from("users")
                .update(["hasCompletedOnboarding": true])
                .eq("id", value: currentUser.id)
                .execute()
            
            print("✅ Supabase updated: onboarding complete")

            // Persist locally too
            setCompletedOnboarding()
            
        } catch {
            print("❌ Failed to update onboarding status: \(error.localizedDescription)")
        }
    }

    
    
    // MARK: - Save login session + user data to SwiftData
    func cacheUserLocally(_ user: SupabaseUser) async throws {
        cacheUserID(user.id)
        
        try await MainActor.run {
            guard let modelContext = modelContext else {
                print("❌ ModelContext not set; cannot cache user")
                throw NSError(domain: "LocalAuthVM", code: 1, userInfo: [NSLocalizedDescriptionKey: "ModelContext is nil"])
            }
            
            let localUser = LocalUser(
                id: user.id,
                email: user.email,
                username: user.username,
                name: user.name,
                role: user.role,
                created_at: user.created_at
            )
            
            // Remove old user with same ID to prevent duplicates
            let existingDescriptor = FetchDescriptor<LocalUser>(predicate: #Predicate { $0.id == user.id })
            if let existing = try? modelContext.fetch(existingDescriptor).first {
                modelContext.delete(existing)
            }
            
            modelContext.insert(localUser)
            
            do {
                try modelContext.save()
                currentUser = localUser
                if user.hasCompletedOnboarding {
                    setCompletedOnboarding()
                    print("✅ Synced onboarding status from Supabase to UserDefaults")
                }

                print("✅ User cached and saved: \(user.email)")
            } catch {
                print("❌ Failed to save local user: \(error.localizedDescription)")
                throw error
            }
        }
    }
    
    // MARK: - Load cached user from UserDefaults
    
    @MainActor
    func loadCachedUserFromID() {
        guard let modelContext = modelContext else {
            print("❌ ModelContext not set; cannot load cached user")
            return
        }
        
        guard let cachedID = UserDefaults.standard.string(forKey: userDefaultsKey) else {
            print("No cached user ID in UserDefaults")
            return
        }
        
        let descriptor = FetchDescriptor<LocalUser>(predicate: #Predicate { $0.id == cachedID })
        
        do {
            if let user = try modelContext.fetch(descriptor).first {
                currentUser = user
                print("Loaded cached user from SwiftData: \(user.email)")
            } else {
                print("No matching user found in SwiftData for cached ID: \(cachedID)")
            }
        } catch {
            print("❌ Failed to fetch user: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Clear cached login + SwiftData user
    func clearCachedUser() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        
        guard let modelContext = modelContext else {
            print("❌ ModelContext not set; cannot clear cached user")
            return
        }
        
        if let user = currentUser {
            modelContext.delete(user)
            try? modelContext.save()
            currentUser = nil
            print("🧹 Cleared cached user")
        }
    }
    
    // MARK: - UserDefaults helpers
    private func cacheUserID(_ id: String) {
        UserDefaults.standard.set(id, forKey: userDefaultsKey)
        print("Cached user ID in UserDefaults: \(id)")
    }
    
    
    //MARK: - DEBUGGER
    func debugPrintAllLocalUsers() {
        guard let modelContext = modelContext else {
            print("❌ ModelContext is nil")
            return
        }
        
        let descriptor = FetchDescriptor<LocalUser>()
        
        do {
            let users = try modelContext.fetch(descriptor)
            if users.isEmpty {
                print("No users found in SwiftData")
            } else {
                print("SwiftData Users:")
                for user in users {
                    print("➡️ ID: \(user.id), Email: \(user.email), Name: \(user.name), Username: \(user.username) ")
                }
            }
        } catch {
            print("❌ Error fetching local users: \(error.localizedDescription)")
        }
    }
    
}

