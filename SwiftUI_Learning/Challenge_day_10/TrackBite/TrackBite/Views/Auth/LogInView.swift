//
//  LogInView.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import SwiftUI

struct LogInView: View {
    
    @State var authVM: SupabaseAuthVM
    @Binding var isSigningUp: Bool
    @State private var email = "Jackayy@gmail.com"
    @State private var password = "Jackayy123"
    
    var body: some View {
        ZStack {
            VStack(spacing:20){
                Text("Log in to TrackBite ")
                    .textStyle(font: .largeTitle)
                    .padding(.top, 50)
                Spacer()
                CustomTextField(name:"email", text: $email, keyboardType: .emailAddress)
                PasswordTextField(name: "Password", text: $password)
                    .padding(.vertical, 10)
                ReusableTaskButton(name:"Log in ") {
                    
                    await authVM.signIn(email: email, password: password)
                    
                }
                
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
            .padding()
        }
        .bodyBackground()
    }
}

#Preview {
    LogInView(authVM: SupabaseAuthVM(), isSigningUp: .constant(false))
}
