//
//  SupabaseAuthView.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import SwiftUI

struct LoginAuthView: View {
    
    @State var authVM: SupabaseAuthViewModel
    @State private var email = "testAcc@gmail.com"
    @State private var password = "testAcc12a"
    @Binding var isSigningUp: Bool
    
    var body: some View {
        ZStack{
            Color(hex: "#7fa8b1")
                .ignoresSafeArea()
            
            VStack{
                Text("Log in to SplashEdit ")
                    .foregroundColor(Color(hex: "#edf2f4"))
                    .font(.largeTitle)
                    .offset(y: 50)
                Spacer()
                CustomTextField(name:"email", text: $email, keyboardType: .emailAddress)
                PasswordTextField(name: "Password", text: $password)
                    .padding(.vertical, 10)
                ReusableTaskButton(name:"Log in") {
                    await authVM.signIn(email: email, password: password)
                }
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(Color(hex:"#edf2f4"))
                    Button{
                        isSigningUp = true
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
    LoginAuthView(authVM: SupabaseAuthViewModel(), isSigningUp:.constant(false))
}
