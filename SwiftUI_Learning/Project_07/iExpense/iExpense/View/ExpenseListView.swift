//
//  ExpenseListView.swift
//  iExpense
//
//  Created by D F on 7/8/25.
//

import SwiftUI
import SwiftData

struct ExpenseListView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var expenses: [ExpenseItem]

    let sortOrder: [SortDescriptor<ExpenseItem>]

    init(
        predicate: Predicate<ExpenseItem>? = nil,
        sortOrder: [SortDescriptor<ExpenseItem>] = []
    ) {
        self.sortOrder = sortOrder
        _expenses = Query(filter: predicate, sort: sortOrder)
    }

    func delete(at offsets: IndexSet, forType type: String) {
        let filtered = expenses.filter { $0.type == type }
        let itemsToDelete = offsets.map { filtered[$0] }
        for item in itemsToDelete {
            modelContext.delete(item)
        }
    }

    var body: some View {
        List {
            Section("Personal") {
                let personal = expenses.filter { $0.type == "Personal" }
                ForEach(personal) { item in
                    ExpenseRow(item: item)
                }
                .onDelete { offsets in
                    delete(at: offsets, forType: "Personal")
                }
            }

            Section("Business") {
                let business = expenses.filter { $0.type == "Business" }
                ForEach(business) { item in
                    ExpenseRow(item: item)
                }
                .onDelete { offsets in
                    delete(at: offsets, forType: "Business")
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}


#Preview {
    ExpenseListView(sortOrder: [SortDescriptor(\ExpenseItem.amount)])
        .modelContainer(for: ExpenseItem.self)
}
