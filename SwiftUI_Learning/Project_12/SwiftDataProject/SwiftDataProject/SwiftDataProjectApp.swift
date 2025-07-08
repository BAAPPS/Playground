//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by D F on 7/8/25.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
