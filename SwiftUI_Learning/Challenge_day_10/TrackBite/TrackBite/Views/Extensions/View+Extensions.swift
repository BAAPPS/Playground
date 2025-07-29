//
//  View+Extensions.swift
//  TrackBite
//
//  Created by D F on 7/25/25.
//

import SwiftUI

struct BodyBackgroundModifier: ViewModifier {
    var color: Color = Color(hex: "#801c20") // default color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color)
            .ignoresSafeArea()
    }
}

struct textStyleModifier: ViewModifier {
    var color: Color = Color(hex: "#edf2f4")
    var font: Font = .title3
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .font(font)
    }
}


struct OnboardingNavigationStyle: ViewModifier {
    let title: String
    let progressText: String
    
    func body(content: Content) -> some View {
        content
            .toolbarBackground(Color(hex: "#801c20"), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle(title) // <- Used ONLY for back button label
            .navigationBarTitleDisplayMode(.inline)
            .opacity(0.99) // <- Prevents SwiftUI from removing view hierarchy (SwiftUI workaround for center tool bar + nav title back button)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(progressText)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
    }
}


extension View {
    func bodyBackground(color: Color = Color(hex: "#801c20")) -> some View {
        self.modifier(BodyBackgroundModifier(color: color))
    }
    
    func textStyle(color: Color = Color(hex: "#edf2f4"), font: Font = .title3) -> some View {
        self.modifier(textStyleModifier(color: color, font: font))
    }
    
    func onboardingNavigation(title: String, progress: String) -> some View {
        self.modifier(OnboardingNavigationStyle(title: title, progressText: progress))
    }
    
    
}
