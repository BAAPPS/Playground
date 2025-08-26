//
//  CardStorageModel.swift
//  Flashzilla
//
//  Created by D F on 8/26/25.
//

import Foundation

struct CardStorage {
    static let filename = "cards.json"

    static let sampleCards: [Card] = [
        Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker"),
        Card(prompt: "What is the capital of France?", answer: "Paris"),
        Card(prompt: "What is the largest planet in our solar system?", answer: "Jupiter"),
        Card(prompt: "What is the chemical symbol for gold?", answer: "Au"),
        Card(prompt: "Who wrote 'Romeo and Juliet'?", answer: "William Shakespeare"),
        Card(prompt: "What is the tallest mountain in the world?", answer: "Mount Everest"),
        Card(prompt: "Which element has the atomic number 1?", answer: "Hydrogen"),
        Card(prompt: "What year did the Titanic sink?", answer: "1912"),
        Card(prompt: "Who painted the Mona Lisa?", answer: "Leonardo da Vinci"),
        Card(prompt: "What is the smallest prime number?", answer: "2"),
        Card(prompt: "Who developed the theory of relativity?", answer: "Albert Einstein"),
        Card(prompt: "What is the largest mammal in the world?", answer: "Blue Whale"),
        Card(prompt: "Which planet is known as the Red Planet?", answer: "Mars"),
        Card(prompt: "What is the freezing point of water in Celsius?", answer: "0"),
        Card(prompt: "Who discovered penicillin?", answer: "Alexander Fleming")
    ]

    // Load cards and return array
    static func load() -> [Card] {
        if let saved = FileManager.load(filename, as: [Card].self) {
            return saved
        } else {
            // First launch: save defaults
            save(sampleCards)
            return sampleCards
        }
    }

    // Save cards
    static func save(_ cards: [Card]) {
        FileManager.save(cards, to: filename)
    }

    // Convenience for views
    static func loadData() -> [Card] {
        return load()
    }

    static func saveData(_ cards: [Card]) {
        save(cards)
    }
}
