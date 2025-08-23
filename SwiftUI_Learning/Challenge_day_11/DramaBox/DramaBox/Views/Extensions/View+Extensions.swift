//
//  OverlayEffectView.swift
//  DramaBox
//
//  Created by D F on 8/15/25.
//

import SwiftUI

struct OverlayEffectModifier: ViewModifier {
    var opacity: Double = 0.5
    var color: Color = .black
    
    func body(content: Content) -> some View {
        content
            .overlay(
                color
                    .opacity(opacity)
                    .ignoresSafeArea()
            )
        
    }
}

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    var duration: Double = 1.2
    var tint: Color = Color.white.opacity(0.6)
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [tint.opacity(0.3), tint, tint.opacity(0.3)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: -300 + phase * 600) // move gradient across the view
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

struct BannerSafeAreaModifier: ViewModifier {
    var allowUnderNavBar: Bool
    
    func body(content: Content) -> some View {
        if allowUnderNavBar {
            content.ignoresSafeArea(edges: .top)
        } else {
            content
        }
    }
}

struct DividerModifier: ViewModifier {
    var height: CGFloat = 25
    var color: Color = .black.opacity(0.6)
    
    func body(content: Content) -> some View {
        Divider()
            .frame(height: height)
            .background(color)
    }
}


extension View {
    func overlayEffect(opacity: Double = 0.5, color: Color = .black) -> some View {
        modifier(OverlayEffectModifier(opacity: opacity, color: color))
    }
    func shimmer(duration: Double = 1.2, tint: Color = Color.white.opacity(0.6)) -> some View {
        modifier(ShimmerModifier(duration: duration, tint: tint))
    }
    
    func bannerSafeArea(allowUnderNavBar: Bool = false) -> some View {
        modifier(BannerSafeAreaModifier(allowUnderNavBar: allowUnderNavBar))
    }
    
    func shortDivider(height: CGFloat = 25, color: Color = .black.opacity(0.6)) -> some View {
        self.modifier(DividerModifier(height: height, color: color))
    }
}

