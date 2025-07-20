//
//  ProflleSettingView.swift
//  SplashEdit
//
//  Created by D F on 7/20/25.
//

import SwiftUI

struct ProflleSettingView: View {
    
    @Bindable var authVM: SupabaseAuthViewModel
    
    @State private var username = ""
    @State private var isUpdating = false
    @State private var updateMessage: String?
    
    @Binding var showProfileSetting: Bool
    
    func updateUsername() async {
        isUpdating = true
        let result = await authVM.updateUsername(username: username)
        updateMessage = result ? "✅ Updated!" : "⚠️ Failed to update"
        isUpdating = false
        if result {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            showProfileSetting = false
        }
    }
    
    var body: some View {
        ZStack {
            if authVM.networkMonitor.isConnected {
                VStack(spacing: 20) {
                    Text("Update Username")
                        .foregroundColor(Color(hex: "#30434a"))
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    CustomTextField(name: "username", text: $username)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "#30434a"), lineWidth: 2))

                    Button {
                        Task {
                            await updateUsername()
                        }
                    } label: {
                        Text(isUpdating ? "Updating..." : "Update Profile")
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 10)
                    .buttonStyle(.borderedProminent)
                    .disabled(isUpdating || username.trimmingCharacters(in: .whitespaces).isEmpty)

                    if let message = updateMessage, !isUpdating {
                        Text(message)
                            .foregroundColor(message.contains("✅") ? .green : .red)
                            .font(.callout)
                            .transition(.opacity)
                    }
                }
                .padding(30)
                .frame(maxWidth: 400)
            } else {
                Text("Offline - Profile update unavailable")
                    .foregroundColor(Color(hex:"#acc6cd"))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    let vm = SupabaseAuthViewModel()
    vm.currentUser = SupabaseUsersModel(id: UUID(), username: "MockUser", created_at: Date())
    return NavigationView {
        ProflleSettingView(authVM: vm, showProfileSetting: .constant(true))
    }
}
