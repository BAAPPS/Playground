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


extension View {
    func bodyBackground(color: Color = Color(hex: "#801c20")) -> some View {
        self.modifier(BodyBackgroundModifier(color: color))
    }
    
    func textStyle(color: Color = Color(hex: "#edf2f4"), font: Font = .title3) -> some View {
        self.modifier(textStyleModifier(color: color, font: font))
    }
    
}
