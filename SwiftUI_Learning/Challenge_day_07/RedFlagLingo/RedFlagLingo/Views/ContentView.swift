//
//  ContentView.swift
//  RedFlagLingo
//
//  Created by D F on 7/4/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
