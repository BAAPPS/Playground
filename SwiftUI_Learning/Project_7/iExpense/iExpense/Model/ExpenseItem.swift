//
//  ExpenseItem.swift
//  iExpense
//
//  Created by D F on 6/20/25.
//

import Foundation
import Observation
import SwiftUI

struct ExpenseItem: Codable, Identifiable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem](){
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init()
    {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                self.items = decodedItems
                return
            }
        }
        items = []
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
