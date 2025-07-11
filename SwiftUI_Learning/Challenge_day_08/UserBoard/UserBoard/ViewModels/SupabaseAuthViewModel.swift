//
//  SupabaseAuthViewModel.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import Foundation
import Supabase
import Observation

@Observable
class SupabaseAuthViewModel {
    var isLoading = false
    var errorMessage: String?
    var currentUser: SupabaseProfileModel?
    
    private let client = SupabaseManager.shared.client
    
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
        }
        catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
}

