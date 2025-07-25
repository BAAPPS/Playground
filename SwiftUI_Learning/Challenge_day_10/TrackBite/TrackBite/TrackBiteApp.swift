//
//  TrackBiteApp.swift
//  TrackBite
//
//  Created by D F on 7/23/25.
//

import SwiftUI
import SwiftData

@main
struct TrackBiteApp: App {
    @State private var authVM = SupabaseAuthVM()

    var body: some Scene {
        WindowGroup {
            ContentView(authVM: authVM)
        }
        .modelContainer(for: LocalUser.self)
    }
}
