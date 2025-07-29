//
//  DriverOnboardingStep.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import Foundation

enum DriverOnboardingStep: Int, CaseIterable, Hashable {
    case vehicleType = 0
    case licensePlate
    case availability
    case summary

    var title: String {
        switch self {
        case .vehicleType: return "Vehicle Type"
        case .licensePlate: return "License Plate"
        case .availability: return "Availability"
        case .summary: return "Summary"
        }
    }

    var stepNumber: Int {
        return Self.allCases.firstIndex(of: self)! + 1
    }

    static var totalSteps: Int {
        return Self.allCases.count
    }
    
    var progressText: String {
        return "\(stepNumber) of \(DriverOnboardingStep.totalSteps)"
    }

}
