//
//  ResortSearchVM.swift
//  SnowSeeker
//
//  Created by D F on 9/2/25.
//

import SwiftUI

@Observable
class ResortSearchVM {
    let resorts: [Resort]
    
    var searchText: String = ""
    var sortOrder: SortOrder = .defaultOrder
    
    enum SortOrder: String, CaseIterable, Identifiable {
        case defaultOrder = "Default"
        case alphabetical = "Alphabetical"
        case country = "Country"
        
        var id: String { rawValue }
    }
    
    init(resorts: [Resort]) {
        self.resorts = resorts
    }
    
    // Computed property to return filtered and sorted resorts
    var filteredResorts: [Resort] {
        var result: [Resort]
        
        if searchText.isEmpty {
            result = resorts
        } else {
            result = resorts.filter { $0.name.localizedStandardContains(searchText) }
        }
        
        switch sortOrder {
        case .alphabetical:
            result.sort { $0.name < $1.name }
        case .country:
            result.sort { $0.country < $1.country }
        case .defaultOrder:
            break
        }
        
        return result
    }
}
