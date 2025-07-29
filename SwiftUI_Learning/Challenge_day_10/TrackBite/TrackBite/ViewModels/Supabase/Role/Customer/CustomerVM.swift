//
//  CustomerVM.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import Foundation
import Observation

@Observable
class CustomerVM {
    var isLoading = false
    var errorMessage: String?
    private let client = SupabaseManager.shared.client
    var customerModel: CustomerModel
    
    init(customerModel: CustomerModel) {
        self.customerModel = customerModel
        self.address = customerModel.address
        self.phoneNumber = customerModel.phoneNumber
        self.preferredPayment = customerModel.preferredPayment
    }
    var address: String = ""
    var phoneNumber: String = ""
    var preferredPayment: String = ""
    var onboardingPath: [CustomerOnboardingStep] = []
    
    func advanceToNextStep(from step: CustomerOnboardingStep) {
        guard let currentIndex = CustomerOnboardingStep.allCases.firstIndex(of: step),
              currentIndex + 1 < CustomerOnboardingStep.allCases.count else { return }
        
        let nextStep = CustomerOnboardingStep.allCases[currentIndex + 1]
        onboardingPath.append(nextStep)
    }

        
    func onboardingComplete() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let payload = CustomerModel.CustomerUpdatePayload(address: address, phoneNumber: phoneNumber, preferredPayment: preferredPayment)
            
            print("Updating ID: \(customerModel.id.uuidString)")

            let response = try await client
                .from("customers")
                .update(payload)
                .eq("id", value:customerModel.id.uuidString)
                .execute()
            
            print("Response: \(response)")
            
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
