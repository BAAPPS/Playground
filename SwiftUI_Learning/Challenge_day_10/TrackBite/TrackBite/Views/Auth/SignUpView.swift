//
//  SignUpView.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import SwiftUI
import SwiftData

struct SignUpView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
   static  let dummyUsersData: DummyUsersModel = Bundle.main.decode("dummyUsers.json")
    

    @State var authVM: SupabaseAuthVM
    @Binding var isSigningUp: Bool
    @State private var name = dummyUsersData.restaurants.first?.name ?? "Default Name"
    @State private var email = dummyUsersData.restaurants.first?.email ?? "default@example.com"
    @State private var password = dummyUsersData.restaurants.first?.password ?? "defaultPassword123"
    @State private var navigateToOnboarding = false

    @State private var selectedRole: UserRole = .driver
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing:20){
                    Text("Welcome to TrackBite ")
                        .textStyle(font: .largeTitle)
                        .padding(.top, 50)
                    
                    VStack(spacing:12){
                        Text("Sign Up As")
                            .textStyle()
                        CustomSegmentedControl(
                            selectedIndex: Binding(
                                get: { UserRole.allCases.firstIndex(of: selectedRole) ?? 0 },
                                set: { selectedRole = UserRole.allCases[$0] }
                            ),
                            segments: UserRole.allDisplayNames,
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
                        await authVM.signUp(name: name, email: email, password: password, role: selectedRole)
                        navigateToOnboarding = true
            

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
            .navigationDestination(isPresented: $navigateToOnboarding){
                OnboardingView(userRole: selectedRole )
                    .navigationBarBackButtonHidden()
            }
            .bodyBackground()
        }
        
    }
    
}
#Preview {
    let authVM = SupabaseAuthVM()
    let localAuthVM = LocalAuthVM.shared
    SignUpView(authVM: authVM, isSigningUp: .constant(true))
        .environment(localAuthVM)
}
