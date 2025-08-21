//
//  AppTab.swift
//  DramaBox
//
//  Created by D F on 8/20/25.
//

import SwiftUI

enum AppTab: Int, CaseIterable, Identifiable {
    case newest
    case favorite
    case list
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .newest: return "Newest"
        case .favorite : return "Favorite"
        case .list: return "List"
        }
    }
    
    var systemIcon: String {
        switch self {
        case .newest: return "film"
        case .favorite: return "heart"
        case .list: return "list.bullet"
        }
    }
}
