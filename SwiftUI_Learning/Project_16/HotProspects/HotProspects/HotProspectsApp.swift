//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by D F on 8/8/25.
//

import SwiftUI
import SwiftData

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ProspectModel.self)
    }
}
