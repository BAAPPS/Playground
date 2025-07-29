//
//  PreferredPaymentView.swift
//  TrackBite
//
//  Created by D F on 7/28/25.
//

import SwiftUI

enum PaymentOptions: String, CaseIterable, Identifiable, Codable {
    case creditCard = "Credit Card"
    case cash = "Cash"
    case debitCard = "Debit Card"
    
    var id: String { self.rawValue }
}

struct PreferredPaymentView: View {
    @Environment(CustomerVM.self) var customerVME
    var step: CustomerOnboardingStep = .phoneNumber
    var onNext: () -> Void
    
    
    var body: some View {
        @Bindable var customerVM = customerVME
        VStack(spacing:24) {
            Spacer()
            Text("Your preferred payment type")
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
                .foregroundColor(.offWhite)
            
            CustomSegmentedControl(
                selectedIndex: Binding(
                    get: {
                        PaymentOptions.allCases.firstIndex { $0.rawValue == customerVM.preferredPayment } ?? 0
                    },
                    set: {
                        customerVM.preferredPayment = PaymentOptions.allCases[$0].rawValue
                    }
                ),
                segments: PaymentOptions.allCases.map {$0.rawValue},
                selectedTintColor: UIColor(Color(hex:"#fef2f2")),
                unselectedTintColor: UIColor(Color(hex:"#ffc9cb")),
                backgroundColor: UIColor(Color(hex: "#801c20")),
                selectedTextColor: UIColor(Color(hex:"#540b0e")),
                font: UIFont.systemFont(ofSize: 14, weight: .medium)
            )
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            
            
            Spacer()
            
            Button(action: {
                onNext()
            }) {
                Text("Next")
                    .bold()
                    .foregroundColor(Color(hex:"#801c20"))
                    .frame(maxWidth: 100)
                    .padding()
                    .background(Color(hex: "#fee2e3"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .bodyBackground()
    }
}

#Preview {
    let sampleCustomerModel = CustomerModel(
        id: UUID(),
        address: "123 Main St",
        phoneNumber: "555-1234",
        preferredPayment: "Credit Card",
        deletedAt: nil,
        createdAt: Date()
    )
    let customerVM = CustomerVM(customerModel: sampleCustomerModel)
    PreferredPaymentView(step: .preferredPayment, onNext: { })
        .environment(customerVM)
}
