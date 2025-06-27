//
//  ContentView.swift
//  HKPopTracks
//
//  Created by D F on 6/27/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.red.opacity(0.5)
                .ignoresSafeArea()
            Text("HKPopTracks")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

#Preview {
    ContentView()
}
