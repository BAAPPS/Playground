//
//  SignUpAuthView.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import SwiftUI

struct SignUpAuthView: View {
    @State var authVM: SupabaseAuthViewModel
    @State private var email = "testAcc@gmail.com"
    @State private var password = "testAcc12a"
    @State private var username = "Test Account"
    @Binding var isSigningUp: Bool
    
    var body: some View {
        ZStack{
            Color(hex: "#7fa8b1")
                .ignoresSafeArea()
            
            VStack{
                Text("Welcome to SplashEdit ")
                    .foregroundColor(Color(hex: "#edf2f4"))
                    .font(.largeTitle)
                    .offset(y: 50)
                Spacer()
                CustomTextField(name:"email", text: $email, keyboardType: .emailAddress)
                CustomTextField(name:"username", text: $username)
                    .padding(.vertical, 10)
                PasswordTextField(name: "Password", text: $password)
                    .padding(.vertical, 10)
                ReusableTaskButton(name:"Sign Up") {
                    await authVM.signUp(email: email, password: password, username: username)
                }
                Spacer()
                
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(Color(hex:"#edf2f4"))
                    Button{
                        isSigningUp = false
                    } label: {
                        TogglePromptView(isSignUp: $isSigningUp)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    SignUpAuthView(authVM: SupabaseAuthViewModel(), isSigningUp: .constant(true))
}
