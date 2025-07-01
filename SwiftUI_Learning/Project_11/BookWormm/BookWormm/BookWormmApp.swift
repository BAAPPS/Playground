//
//  BookWormmApp.swift
//  BookWormm
//
//  Created by D F on 7/1/25.
//

import SwiftUI
import SwiftData

@main
struct BookWormmApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
