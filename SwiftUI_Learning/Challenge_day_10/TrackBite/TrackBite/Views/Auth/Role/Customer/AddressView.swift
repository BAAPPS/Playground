//
//  AddressView.swift
//  TrackBite
//
//  Created by D F on 7/28/25.
//

import SwiftUI

struct AddressView: View {
    @Environment(CustomerVM.self) var customerVME
    var step: CustomerOnboardingStep = .address
    var onNext: () -> Void
    var body: some View {
        @Bindable var customerVM = customerVME
        VStack(spacing:24) {
            Spacer()
            Text("Enter your address")
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
                .foregroundColor(.offWhite)
            
            LabeledTextFieldView(label:"Address", text: $customerVM.address)
                .frame(maxWidth: .infinity, alignment: .center)
            
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
    AddressView(step: .address, onNext: { })
        .environment(customerVM)
}
