//
//  PreviewBindings.swift
//  SplashEdit
//
//  Created by D F on 7/18/25.
//

import SwiftUI

struct PreviewBindingsView<Value, Content: View>: View {
    @State private var value: Value
    var content: (Binding<Value>) -> Content

    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

