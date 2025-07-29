//
//  StepView.swift
//  TrackBite
//
//  Created by D F on 7/28/25.
//

import SwiftUI

struct CustomerStepView: View {
    @Environment(CustomerVM.self) var customerVM
    let step: CustomerOnboardingStep
    var onNext: () -> Void = {}
    var body: some View {
        Group{
            switch step {
            case .address:
                AddressView(step:step, onNext: onNext)
                
            case .phoneNumber:
                PhoneNumberView(step: step, onNext: onNext)
                
            case .preferredPayment:
                PreferredPaymentView(step: step, onNext: onNext)
                
            case .summary:
                CustomerSummaryView(step: step, onNext: onNext)
                
            }
        }
        .onboardingNavigation(title: step.title, progress: step.progressText)
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
    CustomerStepView(step: .address, onNext: {})
        .environment(customerVM)
}
