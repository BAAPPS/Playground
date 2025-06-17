//
//  GameScreen.swift
//  FlipAndSum
//
//  Created by D F on 6/17/25.
//

import SwiftUI

struct Card:Identifiable{
    let id = UUID()
    let value: Int
    var isFlipped: Bool = false
}

struct GameData {
    let cards: [Card]
    let targetSum: Int
    
    init() {
        // Generate random card values first
        let values = (1...5).map { _ in Int.random(in: 1...20) }
        
        self.cards = values.map { Card(value: $0) }
        
        // Pick 2 random card values and sum them to ensure the target is reachable
        let picked = values.shuffled().prefix(2)
        self.targetSum = picked.reduce(0, +)
    }
}

struct GameScreen: View {
    @State private var gameData = GameData()
    @State private var cards: [Card] = []
    @State private var score = 0
    @State private var currentSum = 0
    @State private var currentMoves = 0
    @State private var targetReached = false
    
    
    func resetGame(){
        targetReached = false
        currentSum = 0
        currentMoves = 0
        score = 0
        gameData = GameData()
        cards = gameData.cards
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                RadialGradient( stops: [
                    .init(color: Color(red: 0.76, green: 0.9, blue: 0.95), location: 0.1),
                    .init(color: Color(red: 0.0, green: 0.34, blue: 0.72), location: 0.5)
                ], center: .bottom, startRadius: 200, endRadius: 3000)
                .ignoresSafeArea()
                
                VStack(alignment:.center){
                    
                    HStack{
                        Spacer()
                        Text("Moves:")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                        Text("\(currentMoves)")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.0, green: 0.34, blue: 0.72))
                        Spacer()
                        Text("Current Sum:")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                        Text("\(currentSum)")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.0, green: 0.34, blue: 0.72))
                        Spacer()
                    }
                    
                    HStack{
                        
                        Spacer()
                        
                        Text("Score: \(score)")
                            .padding(.vertical, 20)
                            .padding(.horizontal, 30)
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .background(Color(red: 0.0, green: 0.34, blue: 0.72))
                            .cornerRadius(10)
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    ZStack{
                        ForEach(cards) { card in
                            if let index = cards.firstIndex(where: {$0.id == card.id}){
                                FlipCardView(number: card.value, isFlipped: $cards[index].isFlipped) {
                                    
                                    currentSum += cards[index].value
                                    
                                    currentMoves += 1
                                    
                                    if currentSum >= gameData.targetSum {
                                        score = currentSum - gameData.targetSum
                                        targetReached = true
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        withAnimation {
                                            cards.removeAll { $0.id == card.id }
                                        }
                                    }
                                }
                                .offset(y: card.isFlipped ? -60 : CGFloat(index * 20) )
                                .animation(.spring(), value: card.isFlipped)
                            }
                        }
                    }
                    .frame(height:500)
                    .clipped()
                    .background(.clear)
                    
                    Spacer()
                }
                .padding()
                
                
            }
            .toolbar{
                ToolbarItem(placement: .principal){
                    HStack{
                        Text("Target Sum:")
                            .font(.system(size: 22))
                            .foregroundColor(Color(red: 0.76, green: 0.9, blue: 0.95))
                        Text("\(gameData.targetSum)")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.0, green: 0.34, blue: 0.72))
                    }
                    
                }
            }
        }
        .onAppear{
            if cards.isEmpty{
                cards = gameData.cards
            }
        }
        .alert("CONGRATS", isPresented: $targetReached){
            Button("Play Again"){
                resetGame()
            }
        } message :{
            Text("You reached the target sum! Any points earned beyond the target have been added to your score.")
        }
    }
}

#Preview {
    GameScreen()
}
