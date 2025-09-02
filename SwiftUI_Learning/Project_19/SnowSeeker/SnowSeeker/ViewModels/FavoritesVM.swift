//
//  FavoritesVM.swift
//  SnowSeeker
//
//  Created by D F on 9/2/25.
//

import SwiftUI


@Observable
class FavoritesVM {
    // the actual resorts the user has favorited
    private var resorts: Set<String> {
        didSet {
            save()
        }
    }
    
    
    // the key we're using to read/write in UserDefaults
    private let key = "Favorites"
    
    init() {
        // load our saved data
        if let saved = UserDefaults.standard.stringArray(forKey: key) {
            resorts = Set(saved)
        } else {
            // still here? Use an empty array
            resorts = []
        }
    }
    
    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    // adds the resort to our set and saves the change
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    // removes the resort from our set and saves the change
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    private func save() {
         let array = Array(resorts)
         UserDefaults.standard.set(array, forKey: key)
     }
    
}
