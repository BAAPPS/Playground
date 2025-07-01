//
//  ContentView.swift
//  iExpense
//
//  Created by D F on 6/19/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var expenses = Expenses()
    @State private var showAddExpenseView = false
    
    func removeItems(at offset: IndexSet){
        expenses.items.remove(atOffsets: offset)
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section("Personal"){
                    ForEach(expenses.items.filter {$0.type == "Personal"}){ item in
                        ExpenseRow(item: item)
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section("Business"){
                    ForEach(expenses.items.filter {$0.type == "Business"}){
                        item in
                        ExpenseRow(item: item)
                    }
                    .onDelete(perform: removeItems)
                }
            }
            
            
            .navigationTitle("iExpense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                NavigationLink(destination: AddView(expenses: expenses)){
                    Label("Add Expenses", systemImage: "plus")
                }
                
            }
        }
        //        .sheet(isPresented: $showAddExpenseView){
        //            AddView(expenses: expenses)
        //        }
    }
    
}

#Preview {
    ContentView()
}
