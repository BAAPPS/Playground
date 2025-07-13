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
        ZStack {
            
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                if authVM.currentUser == nil {
                    Text(isSigningUp ? "Sign Up" : "Login")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white.opacity(0.8))
                    
                    CustomTextField(name:"Email",text: $email, keyboardType: .emailAddress)
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(.white)
                        .autocorrectionDisabled(true)
                        .padding(.horizontal, 12)
                        .frame(width: 300, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        )
                    
                    if isSigningUp {
                        CustomTextField(name:"Username",text: $username)
                    }
                    
                    if authVM.isLoading {
                        ProgressView()
                    }
                    
                    if let error = authVM.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                    }
                    
                    Button{
                        Task {
                            if isSigningUp {
                                await authVM.signUp(email: email, password: password, username: username)
                            } else {
                                await authVM.signIn(email: email, password: password)
                            }
                        }
                    } label:{
                        Text(isSigningUp ? "Create Account" : "Login")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                    .frame(width:250, height:25)
                    .padding(10)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 3)
                    .offset(y:10)
                    .disabled(authVM.isLoading)
                    
                    HStack {
                        Text(isSigningUp ? "Already have an account?" : "Don't have an account?")
                            .foregroundColor(.white)
                        Button{
                            isSigningUp.toggle()
                            authVM.errorMessage = nil
                        }label: {
                            TogglePromptView(isSignUp: $isSigningUp)
                        }
                        .font(.system(size:16))
                        .foregroundColor(.white)
                    }
                    .offset(y: 20)
                }
            }
            .padding()
        }
    }
}


#Preview {
    NavigationView{
        AuthView(authVM: SupabaseAuthViewModel())
    }
}
