//
//  NetworkMonitorVM.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import Foundation
import Observation

@Observable
class NetworkMonitorVM {
    var networkMonitor = NetworkMonitorModel()
    
    @MainActor
    func restoreSession() async {
        let auth = LocalAuthVM.shared
        print("🔄 Attempting to restore session...")

        // Offline fallback – use cached SwiftData user
        guard networkMonitor.isConnected else {
            print("📴 No internet. Trying to load cached user.")
            auth.loadCachedUserFromID()
            return
        }

        // Step 1: Get refresh token
        guard let refreshToken = UserDefaults.standard.string(forKey: "supabase_refresh_token") else {
            print("🚫 No refresh token found. Skipping restore.")
            return
        }

        do {
            // Step 2: Refresh session with Supabase
            let session = try await auth.client.auth.refreshSession(refreshToken: refreshToken)
            let userID = session.user.id.uuidString
            print("✅ Session refreshed for: \(session.user.email ?? "unknown")")

            // Step 3: Fetch user data from Supabase `users` table
            let response = try await auth.client
                .from("users")
                .select()
                .eq("id", value: userID)
                .single()
                .execute()

            let data = response.data
            
            print("📦 Raw Supabase user data:", String(data: data, encoding: .utf8) ?? "nil")


            // Step 4: Decode and cache locally
            let supabaseUser = try JSONDecoder.supabaseJSONDecoder().decode(SupabaseUser.self, from: data)
            try await auth.cacheUserLocally(supabaseUser)

            // Step 5: Store new refresh token
            UserDefaults.standard.set(session.refreshToken, forKey: "supabase_refresh_token")
            print("🔐 Updated refresh token stored")
        } catch {
            print("❌ Failed to restore session: \(error.localizedDescription)")
           auth.clearCachedUser()
            UserDefaults.standard.removeObject(forKey: "supabase_refresh_token")
        }
    }

}
