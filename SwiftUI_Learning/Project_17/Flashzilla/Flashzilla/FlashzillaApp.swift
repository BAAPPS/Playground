//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by D F on 8/25/25.
//

import SwiftUI
import SwiftData

@main
struct FlashzillaApp: App {
    @Environment(\.modelContext) private var context
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [CardEntity.self])
                .onAppear {
                   loadSampleDataIfNeeded(context: context)
                }
        }
        
    }
}
