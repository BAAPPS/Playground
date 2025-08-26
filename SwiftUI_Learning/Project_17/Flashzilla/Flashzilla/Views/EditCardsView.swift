//
//  EditCardsView.swift
//  Flashzilla
//
//  Created by D F on 8/25/25.
//

import SwiftUI
import SwiftData




struct EditCardsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @Query(sort: \CardEntity.prompt) private var cardEntities: [CardEntity]

    
    @State private var cards: [Card] = []
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .onAppear {
                let loaded = CardStorage.loadData()
                // fall back to sampleCards if nothing was loaded
                cards = loaded.isEmpty ? CardStorage.sampleCards : loaded
            }
        }
    }
    
    func done() {
        dismiss()
    }
    
    
    
    // MARK: - UserDefaults
    
    //    func loadData() {
    //        if let data = UserDefaults.standard.data(forKey: "Cards") {
    //            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
    //                cards = decoded
    //            }
    //        }
    //    }
    //
    //    func saveData() {
    //        if let data = try? JSONEncoder().encode(cards) {
    //            UserDefaults.standard.set(data, forKey: "Cards")
    //        }
    //    }
    
    // MARK: - SwiftData Actions

    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard !trimmedPrompt.isEmpty, !trimmedAnswer.isEmpty else { return }

        let cardEntity = CardEntity(prompt: trimmedPrompt, answer: trimmedAnswer)
        context.insert(cardEntity)

        do {
            try context.save()
            newPrompt = ""
            newAnswer = ""
        } catch {
            print("Failed to save card:", error)
        }

        // MARK: - JSON FILE
        // let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        // cards.insert(card, at: 0)
        // CardStorage.saveData(cards)
    }

    func removeCards(at offsets: IndexSet) {
        for index in offsets {
            let entity = cardEntities[index]
            context.delete(entity)
        }

        do {
            try context.save()
        } catch {
            print("Failed to delete card:", error)
        }

        // MARK: - JSON FILE (commented out)
        // cards.remove(atOffsets: offsets)
        // CardStorage.saveData(cards)
    }
}

#Preview {
    EditCardsView()
}
