//
//  UserProfileView.swift
//  TrackBite
//
//  Created by D F on 8/1/25.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.supabaseAuthVM) private var authVM: Bindable<SupabaseAuthVM>?
    @State private var newEmail: String = ""
    @State private var newName: String = ""
    @State private var newUsername: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    
    var body: some View {
        VStack {
            if let email = authVM?.wrappedValue.auth.currentUser?.email,
               let name = authVM?.wrappedValue.auth.currentUser?.name,
               let username = authVM?.wrappedValue.auth.currentUser?.username {
                
                VStack(alignment:.leading, spacing: 12){
                    Text("New Email")
                        .foregroundColor(.black.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    CustomTextField(name:"\(email)", text: $newEmail, keyboardType: .emailAddress, textColor: .darkRedBackground)
                        .background(RoundedRectangle(cornerRadius:8).stroke(Color.black.opacity(0.5), lineWidth: 2))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(10)
                VStack(alignment:.leading, spacing: 12){
                    Text("New Name")
                        .foregroundColor(.black.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    CustomTextField(name:"\(name)", text: $newName, textColor: .darkRedBackground)
                        .background(RoundedRectangle(cornerRadius:8).stroke(Color.black.opacity(0.5), lineWidth: 2))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(10)
                
                VStack(alignment:.leading, spacing: 12){
                    Text("New Username")
                        .foregroundColor(.black.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    CustomTextField(name:"\(username)", text: $newUsername, textColor: .darkRedBackground)
                        .background(RoundedRectangle(cornerRadius:8).stroke(Color.black.opacity(0.5), lineWidth: 2))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(10)
                
                Button("Save") {
                  
                    Task {
                        do {
                            try await authVM?.wrappedValue.updateAccountInfo(
                                email: newEmail.isEmpty ? email : newEmail,
                                name: newName.isEmpty ? name : newName,
                                username: newUsername.isEmpty ? username : newUsername
                            )
                            
                            alertTitle = "Success"
                            alertMessage = "Your account data has been updated."
                            showAlert = true
                            newEmail = ""
                            newName = ""
                            newUsername = ""

                        } catch {
                            alertTitle = "Error"
                            alertMessage = error.localizedDescription
                            showAlert = true
                            
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            } else {
                Text("Not logged in")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .navigationTitle("Update Account")
        .backButton()
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        
    }
}


#Preview {
    NavigationStack {
        UserProfileView()
    }
}
