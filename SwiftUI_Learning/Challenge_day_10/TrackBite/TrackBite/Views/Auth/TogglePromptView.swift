//
//  TogglePromptView.swift
//  TrackBite
//
//  Created by D F on 7/25/25.
//

import SwiftUI

struct TogglePromptView: View {
    @Binding var isSignUp: Bool
    var body: some View {
        Text(isSignUp ? "Login" : "Sign Up")
            .textStyle()
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
