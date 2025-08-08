//
//  LogInView.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import SwiftUI

struct LogInView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    static  let dummyUsersData: DummyUsersModel = Bundle.main.decode("dummyUsers.json")
    @State var authVM: SupabaseAuthVM
    @Binding var isSigningUp: Bool
    @State private var email = dummyUsersData.drivers.first?.email ?? "default@example.com"
    @State private var password = dummyUsersData.drivers.first?.password ?? "defaultPassword123"
    
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
                    
                    do {
                        let user = try await authVM.signIn(email: email, password: password)
                        
                        print("logged in user: \(user.email)")
                        
                    }catch {
                        print("Login error: \(error.localizedDescription)")
                    }
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
    let localAuthVM = LocalAuthVM.shared
    LogInView(authVM: SupabaseAuthVM(), isSigningUp: .constant(false))
        .environment(localAuthVM)
}
