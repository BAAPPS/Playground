//
//  CustomerOnboardingView.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import SwiftUI

struct CustomerOnboardingView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(CustomerVM.self) var customerVM
    
    var body: some View {
        @Bindable var customerVM =  customerVM
        NavigationStack(path: $customerVM.onboardingPath){
            CustomerStepView(step: .address, onNext: {
                customerVM.onboardingPath.append(.phoneNumber)
            }).navigationDestination(for: CustomerOnboardingStep.self) { step in
                CustomerStepView(step: step, onNext: {
                    customerVM.advanceToNextStep(from: step)
                })
            }
            
        }
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
    let localAuthVM = LocalAuthVM.shared
    
    CustomerOnboardingView()
        .environment(localAuthVM)
        .environment(customerVM)
}

