//
//  TogglePromptView.swift
//  UserBoard
//
//  Created by D F on 7/13/25.
//

import SwiftUI

struct TogglePromptView: View {
    @Binding var isSignUp: Bool
    var body: some View {
        Text(isSignUp ? "Login" : "Sign up")
            .foregroundColor(.white.opacity(0.8))
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.top, 21),
                alignment: .top
            )
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
        TogglePromptView(isSignUp: .constant(false))
    }
}
