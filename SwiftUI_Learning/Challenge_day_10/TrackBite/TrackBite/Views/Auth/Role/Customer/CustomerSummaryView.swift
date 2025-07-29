//
//  CustomerSummaryView.swift
//  TrackBite
//
//  Created by D F on 7/28/25.
//

import SwiftUI

struct CustomerSummaryView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(CustomerVM.self) var customerVME
    var step: CustomerOnboardingStep = .phoneNumber
    var onNext: () -> Void
    var body: some View {
        @Bindable var customerVM = customerVME
        VStack(spacing:24) {
            Spacer()
            Text("Your address: \(customerVME.address)")
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
                .foregroundColor(.offWhite)
            Text("Your phone number: \(customerVME.phoneNumber)")
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
                .foregroundColor(.offWhite)
            Text("Preferred payment type: \(customerVME.preferredPayment)")
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
                .foregroundColor(.offWhite)
     
            Spacer()
            
            Button(action: {
                Task{
                    await customerVME.onboardingComplete()
                    localAuthVM.hasCompletedOnboarding = true
                    print("Set hasCompletedOnboarding to \(localAuthVM.hasCompletedOnboarding)")
                }
            }) {
                Text("Finish")
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
    let localAuthVM = LocalAuthVM.shared
    let sampleCustomerModel = CustomerModel(
        id: UUID(),
        address: "123 Main St",
        phoneNumber: "555-1234",
        preferredPayment: "Credit Card",
        deletedAt: nil,
        createdAt: Date()
    )
    let customerVM = CustomerVM(customerModel: sampleCustomerModel)
    CustomerStepView(step: .summary, onNext: { })
        .environment(localAuthVM)
        .environment(customerVM)
}
