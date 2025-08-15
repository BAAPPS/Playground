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


extension View {
    func overlayEffect(opacity: Double = 0.5, color: Color = .black) -> some View {
        modifier(OverlayEffectModifier(opacity: opacity, color: color))
    }
}
