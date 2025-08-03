//
//  OrderType.swift
//  TrackBite
//
//  Created by D F on 8/3/25.
//

import Foundation

enum OrderType: String, CaseIterable, Codable, Identifiable {
    case pickup
    case delivery
    
    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .pickup: return "Pickup"
        case .delivery: return "Delivery"
        }
    }
}
