//
//  TableName.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import Foundation

enum TableName: String, Codable, CaseIterable {
    case drivers
    case customers
    case restaurants
    case restaurant_owner_snapshots
    case orders
}
