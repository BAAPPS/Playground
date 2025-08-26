//
//  loadSampleDataIfNeeded.swift
//  Flashzilla
//
//  Created by D F on 8/26/25.
//


import Foundation
import SwiftData

func loadSampleDataIfNeeded(context: ModelContext) {
    do {
        // Check if there are any cards already stored
        let request = FetchDescriptor<CardEntity>()
        let existingCards = try context.fetch(request)
        
        guard existingCards.isEmpty else { return } // Already populated
        
        // Insert sample cards
        for item in CardStorage.sampleCards {
            let card = CardEntity(prompt: item.prompt, answer: item.answer)
            context.insert(card)
        }
        
        try context.save() // Persist to disk
        print("Sample cards saved to SwiftData")
    } catch {
        print("Failed to fetch or save sample cards:", error)
    }
}
