//
//  SignUpView.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import SwiftUI
import SwiftData

struct SignUpView: View {
    @State var authVM: SupabaseAuthVM
    @Binding var isSigningUp: Bool
    @State private var name = "Jackayy"
    @State private var email = "Jackayy@gmail.com"
    @State private var password = "Jackayy123"
    
    @State private var selectedRoleIndex = 0
    let roles = UserRole.allCases.map { $0.rawValue.capitalized }
    
    
    
    var body: some View {
        ZStack {
            VStack(spacing:20){
                Text("Welcome to TrackBite ")
                    .textStyle(font: .largeTitle)
                    .padding(.top, 50)
                
                VStack(spacing:12){
                    Text("Sign Up As")
                        .textStyle()
                    CustomSegmentedControl(
                        selectedIndex: $selectedRoleIndex,
                        segments: roles,
                        selectedTintColor: UIColor(Color(hex:"#fef2f2")),
                        unselectedTintColor: UIColor(Color(hex:"#ffc9cb")),
                        backgroundColor: UIColor(Color(hex: "#801c20")),
                        selectedTextColor: UIColor(Color(hex:"#540b0e")),
                        font: UIFont.systemFont(ofSize: 14, weight: .medium)
                    )
                    .frame(height: 40)
                    
                    
                }
                Spacer()
                
                CustomTextField(name:"name", text: $name)
                CustomTextField(name:"email", text: $email, keyboardType: .emailAddress)
                PasswordTextField(name: "Password", text: $password)
                    .padding(.vertical, 10)
                ReusableTaskButton(name:"Sign Up") {
                    let selectedRole = UserRole.allCases[selectedRoleIndex]
                    await authVM.signUp(name: name, email: email, password: password, role: selectedRole)
                    
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
            .padding()
        }
        .bodyBackground()
    }
    
}
#Preview {
    let authVM = SupabaseAuthVM()
    SignUpView(authVM: authVM, isSigningUp: .constant(true))
}
