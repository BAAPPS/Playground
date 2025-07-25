// AuthCoordinator.swift
// TrackBite
//
// Created by D F on 7/24/25.
//

import Foundation

class AuthCoordinator {
    let supabaseAuthVM: SupabaseAuthVM
    let localAuthVM: LocalAuthVM

    init(supabaseAuthVM: SupabaseAuthVM, localAuthVM: LocalAuthVM) {
        self.supabaseAuthVM = supabaseAuthVM
        self.localAuthVM = localAuthVM
    }
    
    /// Synchronizes user data from Supabase to local cache.
    func syncUserData() async {
        do {
            // 1. Fetch current user info from Supabase (you'll need to add method for this)
            guard let supabaseUser = try await supabaseAuthVM.fetchCurrentUser() else {
                print("No logged-in user found on Supabase.")
                return
            }
            
            // 2. Cache user locally
            try await localAuthVM.cacheUserLocally(supabaseUser)
            
            // 3. Update any relevant UI or state here, e.g., notify listeners or post notifications
            
            print("✅ Successfully synced user data.")
            
        } catch {
            print("❌ Failed to sync user data: \(error.localizedDescription)")
        }
    }
}
