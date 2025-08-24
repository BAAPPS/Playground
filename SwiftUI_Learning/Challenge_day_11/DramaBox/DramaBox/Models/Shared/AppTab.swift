//
//  AppTab.swift
//  DramaBox
//
//  Created by D F on 8/20/25.
//

import SwiftUI

enum AppTab: Int, CaseIterable, Identifiable {
    case newest
    case genres
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .newest: return "Newest"
        case .genres : return "Genres"
        }
    }
    
    var systemIcon: String {
        switch self {
        case .newest: return "film"
        case .genres: return "square.grid.3x2"
        }
    }
}
