//
//  TogglePromptView.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import SwiftUI

import SwiftUI

struct TogglePromptView: View {
    @Binding var isSignUp: Bool
    var body: some View {
        Text(isSignUp ? "Login" : "Sign up")
            .foregroundColor(Color(hex:"#edf2f4"))
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
        Color(hex: "#7fa8b1")
            .ignoresSafeArea()
        TogglePromptView(isSignUp: .constant(false))
    }
}
