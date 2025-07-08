//
//  ExpenseItem.swift
//  iExpense
//
//  Created by D F on 6/20/25.
//

import Foundation
import Observation
import SwiftUI
import SwiftData


@Model
class ExpenseItem{
    @Attribute(.unique) var id: UUID
    var name: String
    var type: String
    var amount: Double
    
    init(id: UUID = UUID(), name: String, type: String, amount: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
    }
}

extension ExpenseItem{
    var amountColor: Color {
        if amount < 10 {
            return .green
        }
        else if amount < 100{
            return .orange
        }
        else {
            return .blue
        }
    }
}
