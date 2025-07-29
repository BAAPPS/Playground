//
//  UserRole.swift
//  TrackBite
//
//  Created by D F on 7/24/25.
//

import Foundation


enum UserRole: String, Codable, CaseIterable {
    case driver
    case customer
    case restaurant
}

extension UserRole {
    var displayName: String {
        switch self {
        case .driver: return "Driver"
        case .customer: return "Customer"
        case .restaurant: return "Restaurant"
        }
    }

    static var allDisplayNames: [String] {
        UserRole.allCases.map { $0.displayName }
    }
}
