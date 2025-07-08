//
//  iExpenseApp.swift
//  iExpense
//
//  Created by D F on 6/19/25.
//

import SwiftUI
import SwiftData
@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
