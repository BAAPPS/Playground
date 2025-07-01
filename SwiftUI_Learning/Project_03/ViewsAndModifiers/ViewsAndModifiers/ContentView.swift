//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by D F on 6/9/25.
//

import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    @ViewBuilder let content: (Int, Int) -> Content  // Supports multiple views per cell
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)  // Render content for each cell
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var useRedText = false
    
    var body: some View {
        GridStack(rows: 3, columns: 3) { row, col in
            Image(systemName: "\(row * 4 + col).circle")
            Text("R\(row) C\(col)")
        }
        
    }
}

#Preview {
    ContentView()
}
