//
//  AuthSwicherView.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import SwiftUI

struct AuthSwicherView: View {
    @State private var isSigningUp = false
    @Bindable var authVM: SupabaseAuthViewModel
    var body: some View {
        ZStack {
            if isSigningUp {
                SignUpAuthView(authVM: authVM, isSigningUp: $isSigningUp)
                    .transition(.move(edge: .trailing))
            } else{
                LoginAuthView(authVM: authVM, isSigningUp: $isSigningUp)
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: isSigningUp)
    }
}

#Preview {
    AuthSwicherView(authVM: SupabaseAuthViewModel())
}
