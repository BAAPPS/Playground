//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by D F on 6/8/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var currentRound = 1
    @State private var showingFinalScore = false
    let MAX_ROUND = 8
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func flagTapped(_ number:Int){
        if number == correctAnswer{
            scoreTitle = "Let's goooo! That is correct!"
            userScore += 1
        }else{
            scoreTitle = "Wrong! That's the flag of \(countries[number])."
            userScore = max(userScore - 1, 0)
        }
        showingScore = true
        
        if currentRound == MAX_ROUND {
            showingFinalScore = true
        } else {
            showingScore = true
        }
        
        currentRound += 1
        
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame(){
        currentRound = 1
        userScore = 0
        askQuestion()
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red:0.16, green:0.1, blue:0.1), location: 0.1),
                .init(color: Color(red: 0.60, green: 0.15, blue: 0.20), location: 0.5),
            ], center: .top, startRadius: 100, endRadius: 800)
            .ignoresSafeArea()
            
            
            VStack {
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<min(9, countries.count), id:\.self){index in
                            Button{
                                flagTapped(index)
                            }label:{
                                Image(countries[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 60)
                                    .clipShape(.rect)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        
        .alert(isPresented: Binding(get: {
            showingScore || showingFinalScore
        }, set: { _ in
            showingScore = false
            showingFinalScore = false
        })) {
            if showingFinalScore {
                return Alert(
                    title: Text("Game Over"),
                    message: Text("Your final score was \(userScore) out of \(MAX_ROUND)."),
                    dismissButton: .default(Text("Play Again"), action: resetGame)
                )
            } else {
                return Alert(
                    title: Text(scoreTitle),
                    message: Text("Your score is \(userScore)"),
                    dismissButton: .default(Text("Continue"), action: askQuestion)
                )
            }
        }
        
    }
}

#Preview {
    ContentView()
}
