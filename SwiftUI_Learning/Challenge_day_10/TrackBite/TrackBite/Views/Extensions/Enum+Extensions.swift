//
//  Enums+Extensions.swift
//  TrackBite
//
//  Created by D F on 8/4/25.
//

import Foundation
import SwiftUI

extension OrderStatus {
    var backgroundColor: Color {
        switch self {
        case .pending:
            return .darkRedBackground.opacity(0.6)
        case .inProgress:
            return .offWhite
        case .completed:
            return .green
        case .cancelled:
            return .darkRedBackground
        }
    }
    
    var foregroundDeliveryTextColor: Color {
        switch self{
        case .inProgress:
            return .gray.opacity(0.7)
        case .completed:
            return .offWhite.opacity(0.7)
        case  .cancelled, .pending:
            return .offWhite
        }
    }
    
    var foregroundOrderColor: Color {
        switch self{
        case .inProgress:
            return .gray.opacity(0.7)
        case .pending:
            return .offWhite
        case  .completed, .cancelled:
            return .offWhite.opacity(0.7)
        }
    }
    
    var foregroundDisplayNameColor: Color {
        switch self{
        case .pending, .inProgress:
            return .darkRedBackground
        case .completed, .cancelled:
            return .offWhite
        }
    }
    
    var foregroundCreatedDateColor: Color {
        switch self{
        case .inProgress, .completed:
            return .darkRedBackground.opacity(0.7)
        case  .cancelled, .pending:
            return .offWhite.opacity(0.6)
        }
    }
}
