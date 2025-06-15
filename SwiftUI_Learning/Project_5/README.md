# Word Scramble

Welcome to **Word Scramble**! `Word Scramble` is a SwiftUI-based word game designed as a fun, hands-on way to explore more of Swift and SwiftUI’s core concepts. 

It’s ideal for developers learning SwiftUI who want to apply language features through a creative and interactive project.

---

## What You'll Learn

This project introduces several important Swift and SwiftUI concepts, including:

- `List` – to display previously entered words
- `onAppear()` – to trigger actions when the view loads
- `Bundle` – to load external resources like a word list
- `fatalError()` – to catch critical errors during development
- `@State` – for handling local view state
- `NavigationStack` – for managing navigation views
- `UITextChecker` – to validate English words

---

## What the App Does

In this game, players are shown a **randomly selected eight-letter word** and must create as many valid smaller words as possible using only the letters from that root word.

Each submission is checked for:

- ✅ Originality – the word hasn’t been used before  
- ✅ Possibility – the word can be formed from the root word  
- ✅ Reality – the word exists in the English language  

### ✨ Example

If the root word is **palettes**, valid submissions include:

- pale  
- step  
- seat  
- pest  
- leap  

Invalid submissions (e.g. repeats, fake words, or unmatchable words) are rejected with helpful error messages.

---

## Project Structure

- `ContentView.swift`  
  The main view of the app. It handles user input, validation, and display of the used words list.

- `start.txt`  
  A text file bundled into the app containing over 10,000 eight-letter words. One of these is randomly selected as the root word each time the game starts.

- `startGame()`  
  Loads `start.txt`, splits it into an array, and selects a random root word.

- Word validation methods:
  - `isOriginal(word:)`
  - `isPossible(word:)`
  - `isReal(word:)`

- `wordError(title:message:)`  
  A helper to show SwiftUI alerts when invalid input is detected.

---

## Final Thoughts

`Word Scramble` is a great way to reinforce your knowledge of SwiftUI while building a real, interactive app. 

You'll get hands-on practice with:

- working with local files in an app bundle  
- performing string manipulation and logic  
- integrating UIKit features into a SwiftUI workflow  
- managing state and view lifecycle  
- delivering polished user feedback with alerts

