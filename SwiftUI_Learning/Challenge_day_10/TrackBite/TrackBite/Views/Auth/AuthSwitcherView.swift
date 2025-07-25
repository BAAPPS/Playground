//
//  AuthSwitcherView.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import SwiftUI
import SwiftData

struct AuthSwitcherView: View {
    
    @State private var isSigningUp = true
    @Bindable var authVM: SupabaseAuthVM
    
    var body: some View {
        ZStack {
            if isSigningUp {
                SignUpView(authVM: authVM, isSigningUp: $isSigningUp)
                    .transition(.move(edge: .leading))
            } else{
                LogInView(authVM: authVM, isSigningUp: $isSigningUp)
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut, value: isSigningUp)
    }
}

#Preview {
    let authVM = SupabaseAuthVM()
    AuthSwitcherView(authVM: authVM)
}
