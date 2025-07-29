//
//  RestaurantOnboardingStep.swift
//  TrackBite
//
//  Created by D F on 7/28/25.
//

import Foundation

enum RestaurantOnboardingStep: Int, CaseIterable, Hashable {
    case restaurantStoreInfo = 0
    case restaurantLocationInfo
    case summary

    var title: String {
        switch self {
        case .restaurantStoreInfo: return "Restaurant Information"
        case .restaurantLocationInfo: return "Location"
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
        return "\(stepNumber) of \(RestaurantOnboardingStep.totalSteps)"
    }

}
