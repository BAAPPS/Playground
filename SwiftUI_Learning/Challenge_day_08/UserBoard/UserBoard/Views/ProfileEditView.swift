//
//  ProfileEditView.swift
//  UserBoard
//
//  Created by D F on 7/13/25.
//

import SwiftUI

struct ProfileEditView: View {
    @Bindable var authVM: SupabaseAuthViewModel
    @Binding var showEditProfile: Bool
    
    @State private var username = ""
    @State private var isUpdating = false
    @State private var updateMessage: String?
    
    
    var body: some View {
        
        VStack(spacing: 20) {
            ZStack {
                Text("Update Profile")
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.8))
                    .frame(maxWidth:.infinity)
                    .multilineTextAlignment(.center)
                HStack {
                    Spacer()
                    Button {
                        showEditProfile = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.black.opacity(0.7))
                            .padding()
                    }
                }
            }
            VStack(spacing: 16) {
                if authVM.networkMonitor.isConnected {
                    Form {
                        CustomTextField(name: "Username", text: $username, textColor: .black.opacity(0.8))
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black.opacity(0.5), lineWidth: 2)
                            )
                        
                        Button {
                            Task {
                                isUpdating = true
                                let result = await authVM.updateCurrentUserProfile(username: username)
                                updateMessage = result ? "✅ Updated!" : "⚠️ Failed to update"
                                isUpdating = false
                                
                                // Give time for user to read success before closing
                                if result {
                                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
                                    showEditProfile = false
                                }
                            }
                        } label: {
                            Text(isUpdating ? "Updating..." : "Update Profile")
                        }
                        .offset(x: -20)
                        .frame(maxWidth:.infinity, alignment: .bottomTrailing)
                        .buttonStyle(.borderedProminent)
                        .disabled(isUpdating || username.trimmingCharacters(in: .whitespaces).isEmpty)
                        
                        // Show update result message
                        if let message = updateMessage, !isUpdating {
                            Text(message)
                                .foregroundColor(message.contains("✅") ? .green : .red)
                                .font(.callout)
                                .transition(.opacity)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                } else {
                    Text("Offline — profile updates unavailable")
                        .foregroundColor(.gray)
                }
            }
            
        }
    }
}

#Preview {
    ProfileEditView(authVM: SupabaseAuthViewModel(), showEditProfile: .constant(true))
}
