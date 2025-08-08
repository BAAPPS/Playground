//
//  ContentView.swift
//  WordScramble
//
//  Created by D F on 6/13/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    
    @State private var pointsEarned =  0
    
    
    func wordError(title:String, message: String){
        errorTitle = title
        errorMessage = message
        showError = true
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {return}
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard !isBadAnswer(word: answer) else {
            wordError(title: "Word cannot be used", message: "Must be 3+ letters and not the root word")
            return
        }
        
        withAnimation{
            usedWords.insert(answer, at: 0)
            pointsEarned += wordPoints(for: answer)
        }
        
        newWord = ""
        
    }
    
    func wordPoints(for word: String) -> Int{
        let trimmedWord = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch trimmedWord.count {
        case _ where trimmedWord.count == rootWord.count:
            return rootWord.count
        case 4...:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    
    func isBadAnswer(word: String) -> Bool {
        let trimmedWord = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        return trimmedWord.count < 3 || trimmedWord == rootWord.lowercased()
    }
    
    
    
    func startGame(){
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordURL, encoding: .ascii){
                let allWords = startWords.components(separatedBy: "\n")
                
                rootWord = allWords.randomElement() ?? "Denny"
                
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word:String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word{
            if let pos = tempWord.firstIndex(of: letter)
            {
                tempWord.remove(at:pos)
            }else{
                return false
            }
        }
        return true
    }
    
    func isReal(word:String) -> Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return  misspelledRange.location == NSNotFound
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section{
                    TextField("Enter you word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .autocapitalization(.none)
                }
                
                Section{
                    ForEach(usedWords, id:\.self){ word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        .accessibilityElement()
                        .accessibilityLabel("\(word), \(word.count) letters")
                    }
                }
                
            }
            .navigationTitle(rootWord)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: startGame) {
                        Label("New Word", systemImage: "arrow.clockwise")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Score: \(pointsEarned)")
                        .font(.headline)
                }
            }
        }
        .onSubmit(addNewWord)
        .onAppear(perform: startGame)
        
        .alert(errorTitle, isPresented: $showError){
            Button("OK"){}
        } message: {
            Text(errorMessage)
        }
        
    }
}

#Preview {
    ContentView()
}
