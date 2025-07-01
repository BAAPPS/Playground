//
//  ExpenseRow.swift
//  iExpense
//
//  Created by D F on 6/20/25.
//

import SwiftUI

struct ExpenseRow: View {
    let item: ExpenseItem
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            Spacer()
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .listRowBackground(item.amountColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .foregroundColor(.white)
    }
}

#Preview {
    ExpenseRow(item: ExpenseItem(name: "Coffee", type: "Personal", amount: 10.0))
}
