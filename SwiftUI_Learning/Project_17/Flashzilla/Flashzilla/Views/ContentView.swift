//
//  ContentView.swift
//  Flashzilla
//
//  Created by D F on 8/25/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // MARK: - Using SwiftData
    @Environment(\.modelContext) private var context
    @Query(sort: \CardEntity.prompt) private var cardEntities: [CardEntity]
    
    @State private var cards: [Card] = []
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    @State private var showingEditScreen = false
    @State private var isActive = true
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    // MARK: - UserDefaults
    
    //    func loadData() {
    //        if let data = UserDefaults.standard.data(forKey: "Cards") {
    //            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
    //                cards = decoded
    //            }
    //        }
    //    }
    
    func removeCard(_ card: Card, wrongAnswer: Bool = false) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        let removedCard = cards.remove(at: index)
        
        if wrongAnswer {
            var newCard = removedCard
            newCard.id = UUID() // ensure SwiftUI treats it as a new view
            cards.insert(newCard, at: 0) // add back at the front
        }
        
        // MARK: - SwiftData: Remove from persistent storage
        if let entity = cardEntities.first(where: { $0.id == card.id }) {
            context.delete(entity)
            do {
                try context.save()
            } catch {
                print("Failed to save context after removing card:", error)
            }
        }
        
        // MARK: - JSON FILE (commented out)
        // CardStorage.saveData(cards)
        
        if cards.isEmpty {
            isActive = false
        }
    }

    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        // MARK: - SwiftData: Load cards from SwiftData
        if cardEntities.isEmpty {
            // Fallback: load sample data if nothing exists
            cards = CardStorage.sampleCards
        } else {
            cards = cardEntities.map { Card(id: $0.id, prompt: $0.prompt, answer: $0.answer) }
        }
        
        // MARK: - JSON FILE 
        // let loaded = CardStorage.loadData()
        // cards = loaded.isEmpty ? CardStorage.sampleCards : loaded
    }
    
    func index(of card: Card) -> Int {
        cards.firstIndex(where: { $0.id == card.id }) ?? 0
    }
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                ZStack {
                    ForEach(cards) { card in
                        let cardIndex = index(of: card)
                        let isTopCard = card == cards.last
                        
                        CardView(card: card) { wrongAnswer in
                            withAnimation {
                                removeCard(card, wrongAnswer: wrongAnswer)
                            }
                        }
                        .stacked(at: cardIndex, in: cards.count)
                        .allowsHitTesting(isTopCard)
                        .accessibilityHidden(!isTopCard)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(cards.last!, wrongAnswer: true)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(cards.last!)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCardsView.init)
        .onAppear(perform: resetCards)
        .onReceive(timer) { _ in
            guard isActive else { return }
            if timeRemaining > 0 { timeRemaining -= 1 }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active && !cards.isEmpty {
                isActive = true
            } else {
                isActive = false
            }
        }
    }
}

#Preview {
    ContentView()
}


