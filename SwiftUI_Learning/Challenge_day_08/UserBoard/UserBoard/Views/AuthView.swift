//
//  AuthView.swift
//  UserBoard
//
//  Created by D F on 7/11/25.
//

import SwiftUI

struct AuthView: View {
   @State var authVM: SupabaseAuthViewModel
    
    @State private var email = "test@yahoo.com"
    @State private var password = "test123"
    @State private var username = "test Acc"
    @State private var isSigningUp = false
    
    var body: some View {
            VStack(spacing: 20) {
                if authVM.currentUser == nil {
                    Text(isSigningUp ? "Sign Up" : "Login")
                        .font(.largeTitle)
                        .bold()

                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(.roundedBorder)

                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)

                    if isSigningUp {
                        TextField("Username", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .textFieldStyle(.roundedBorder)
                    }

                    if authVM.isLoading {
                        ProgressView()
                    }

                    if let error = authVM.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                    }

                    Button(isSigningUp ? "Create Account" : "Login") {
                        Task {
                            if isSigningUp {
                                await authVM.signUp(email: email, password: password, username: username)
                            } else {
                                await authVM.signIn(email: email, password: password)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(authVM.isLoading)

                    Button(isSigningUp ? "Already have an account? Login" : "Don't have an account? Sign Up") {
                        isSigningUp.toggle()
                        authVM.errorMessage = nil
                    }
                    .font(.footnote)
                    .padding(.top)
                }
            }
            .padding()
            .navigationTitle("UserBoard Auth")
        }
}


#Preview {
    AuthView(authVM: SupabaseAuthViewModel())
}
