//
//  Goal.swift
//  PathLog
//
//  Created by D F on 6/20/25.
//

import Foundation

enum GoalStatus: String, Codable, CaseIterable {
    case notStarted = "Not Yet Started"
    case inProgress = "Working On It"
    case completed = "Completed"
    case failed = "Failed"
    case abandoned = "Abandoned"
}

struct Goal: Codable, Identifiable{
    let name: String
    var id = UUID()
    var status: GoalStatus = .notStarted
    var dueDate: Date?
    var isOverdue: Bool {
        guard let due = dueDate else { return false }
        return Date() > due && status != .completed
    }
    var startDate: Date?
}
