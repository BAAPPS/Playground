//
//  AddView.swift
//  iExpense
//
//  Created by D F on 6/20/25.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = "New Expenses"
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types =  ["Business", "Personal"]
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Type of Expense"){
                    Picker("Type", selection: $type){
                        ForEach(types, id: \.self){
                            Text($0)
                        }
                    }
                }
                
                Section("Amount of Expense"){
                    TextField("Amount", value:$amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle($name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar{
                
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        let item = ExpenseItem(name:name, type: type, amount: amount)
                        modelContext.insert(item)
                        
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddView()
        .modelContainer(for: ExpenseItem.self)
}
