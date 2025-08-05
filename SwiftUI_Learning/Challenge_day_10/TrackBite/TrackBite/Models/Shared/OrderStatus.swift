//
//  OrderStatus.swift
//  TrackBite
//
//  Created by D F on 8/3/25.
//

import Foundation

enum OrderStatus: String, Codable, CaseIterable {
    case pending
    case inProgress = "in progress"
    case completed
    case cancelled
}
