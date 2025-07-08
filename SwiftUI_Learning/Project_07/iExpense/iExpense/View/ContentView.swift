//
//  ContentView.swift
//  iExpense
//
//  Created by D F on 6/19/25.
//

import SwiftUI
import SwiftData

import SwiftUI

enum FilterType: String, CaseIterable, Identifiable {
    case all = "All"
    case personal = "Personal"
    case business = "Business"
    
    var id: String { rawValue }
    
    var predicate: Predicate<ExpenseItem>? {
        switch self {
        case .all:
            return nil
        case .personal:
            return #Predicate<ExpenseItem> { $0.type == "Personal" }
        case .business:
            return #Predicate<ExpenseItem> { $0.type == "Business" }
        }
    }
}
enum SortType: String, CaseIterable, Identifiable {
    case name = "Name"
    case amount = "Amount"
    
    var id: String { rawValue }
    
    var descriptors: [SortDescriptor<ExpenseItem>] {
        switch self {
        case .name:
            return [SortDescriptor(\ExpenseItem.name)]
        case .amount:
            return [SortDescriptor(\ExpenseItem.amount)]
        }
    }
}



struct ContentView: View {
    
    @State private var filterType: FilterType = .all
    @State private var sortType: SortType = .name
    
    
    var body: some View {
        NavigationStack {
            ExpenseListView(predicate: filterType.predicate, sortOrder: sortType.descriptors)
  
                .navigationTitle("iExpense")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(destination: AddView()) {
                            Label("Add Expenses", systemImage: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .automatic) {
                        Menu("Filter", systemImage:"line.horizontal.3.decrease.circle") {
                            Picker("Filter", selection: $filterType) {
                                ForEach(FilterType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort by", selection: $sortType) {
                                ForEach(SortType.allCases){sort in
                                    Text(sort.rawValue).tag(sort)
                                }
                                
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseItem.self)
}
