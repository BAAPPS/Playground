//
//  RedFlagLingoApp.swift
//  RedFlagLingo
//
//  Created by D F on 7/4/25.
//

import SwiftUI
import SwiftData

@main
struct RedFlagLingoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [MessageModel.self, ScamAlertModel.self])
    }
}
