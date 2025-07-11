//
//  UserBoardApp.swift
//  UserBoard
//
//  Created by D F on 7/8/25.
//

import SwiftUI
import SwiftData

@main
struct UserBoardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: UserProfile.self)
    }
}
