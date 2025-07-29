//
//  CustomerOnboardingStep.swift
//  TrackBite
//
//  Created by D F on 7/28/25.
//

import Foundation

enum CustomerOnboardingStep: Int, CaseIterable, Hashable {
    case address = 0
    case phoneNumber
    case preferredPayment
    case summary

    var title: String {
        switch self {
        case .address: return "Address"
        case .phoneNumber: return "Phone Number"
        case .preferredPayment: return "Preferred Payment"
        case .summary: return "Confirm Data"
        }
    }

    var stepNumber: Int {
        return Self.allCases.firstIndex(of: self)! + 1
    }

    static var totalSteps: Int {
        return Self.allCases.count
    }
    
    var progressText: String {
        return "\(stepNumber) of \(CustomerOnboardingStep.totalSteps)"
    }

}
