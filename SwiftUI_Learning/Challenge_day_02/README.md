# Tic Tac Toe

This self-directed challenge tests and reinforces my SwiftUI skills — covering state management, modifiers, custom containers, and real-time user input handling — by building  a Tic Tac Toe game from scratch.

---

## 🎯 What You’ll Build

In this project, you'll build a fully functional **Tic Tac Toe** game using **SwiftUI**, a modern UI framework for Apple platforms. 

This classic two-player game challenges users to take turns placing their symbols (X or O) on a 3x3 grid, aiming to align three of their marks horizontally, vertically, or diagonally.

By the end of this project, you will have:

* Built a dynamic 3x3 grid-based game board.
* Enabled turn-based gameplay between two players.
* Implemented game logic to detect:

  * A **win condition** for either player.
  * A **draw** when the board is full with no winner.
* Displayed player icons using a symbol picker for customization.
* Added game state management using `@State` and logic handling with clean, modular functions.
* Reset functionality to start a new game.
* Created an interactive and responsive UI that reflects real-time game state changes.

This project is great for improving your understanding of **state management**, **event handling**, **conditional rendering**, and **user interaction** in SwiftUI.

---

## What You’ll Learn

By building this Tic Tac Toe game with SwiftUI, you’ll strengthen your understanding of key Swift and SwiftUI development concepts, including:

* **State Management**: Learn how to manage dynamic data in your UI using `@State` and how to update the interface reactively.
* **Conditional Rendering**: Render different UI elements depending on the game state (e.g., win, draw, ongoing).
* **View Composition**: Structure and organize your UI using SwiftUI’s declarative syntax and component-based design.
* **Custom Game Logic**: Implement your own win-checking and draw-detection algorithms using pure Swift.
* **Reusable Functions**: Build modular functions to handle moves, resets, and game outcome checks.
* **Player Interaction**: Handle user input with gesture recognizers and tap interactions.
* **Testing Game Scenarios**: Manually test win and draw conditions, and reset scenarios for game robustness.
* **User Interface Skills**: Improve your ability to create clean, intuitive UIs with feedback based on app state.

---


## Project Structure

This project is organized to clearly separate UI elements from game logic, making it easier to understand, maintain, and extend. 

Below is an overview of the core components:

### 1. Input Controls

* **Game Grid Tap Handler:**
  The method `handleCellTapped(row:col:)` handles the main interaction. When a user taps a cell:

  * It checks if the cell is empty.
  * Assigns the current player's icon (e.g., ❌ or ⭘).
  * Checks for a win condition or a draw.
  * Switches turns between players if the game continues.

* **Reset Button:**

  Allows users to reset the board at any time. It clears the grid, resets the player, and removes any win/draw messages.

### 2. Conversion Logic

* **Win Detection:**
  The game checks for a win condition after every move using the `winner(row:col:)` function, verifying if any row, column, or diagonal contains the same player icon.

* **Draw Detection:**
  When the board is full and no player has won, the game declares a draw using the `isBoardFull()` function.

* **Player Switching:**
  After each valid move, the turn switches between Player 1 and Player 2 using a simple ternary operation.

* **State Management:**
  Game state is maintained using SwiftUI’s `@State` properties, including:

  * `gridIcons`: Stores the icons placed on the board.
  * `selectedUser`: Tracks whose turn it is.
  * `isWinner`: Boolean flag if there's a winner.
  * `isDraw`: Boolean flag for a draw.
  * `winnerPlayer`: Stores which player won.

This separation ensures the code is clean, testable, and easy to navigate for future modifications or enhancements.

---

## Final Thought

Building this Tic Tac Toe app was a great exercise in combining SwiftUI’s declarative UI design with essential game logic and state management. It showcases how simple user interactions can drive dynamic and interactive 
interfaces while keeping the code clean and modular. This project also allowed me to bring together concepts I had learned from previous projects and connect them to create a fully functional app.

This project I learned to use `Binding` with custom getters and setters in a Picker, which added more flexibility to the UI state management. Additionally, how to add images to a grid using a custom container and safely 
unwrap optional values with `if let` — for example, displaying an icon on the grid with this code:

```swift
if let iconName = gridIcons[row][col] {
    imageAsset(name: iconName)
        .frame(width: 24, height: 24)
}
```

This was especially useful for managing the state of the game board, which I stored as a 2D array of optional strings:

```swift
@State private var gridIcons: [[String?]] = Array(
    repeating: Array(repeating: nil, count: 3),
    count: 3
)
```

Studying matrices in data structures and algorithms (DSA) also helped me understand how to check boundaries on a grid efficiently. 

This knowledge was key when implementing the winner-checking logic, where I checked all directions (right, down, diagonal) with boundary checks to avoid out-of-range errors:

```swift
// Directions to check (right, down, down-right, down-left)
let directions = [(0, 1), (1, 0), (1, 1), (1, -1)]

for (dx, dy) in directions {
    var count = 1
    
    // Check forward direction
    var x = row + dx
    var y = col + dy
    
    while x >= 0 && x < size && y >= 0 && y < size && gridIcons[x][y] == player {
        count += 1
        x += dx
        y += dy
    }
    // Check backward direction
    x = row - dx
    y = col - dy
    
    while x >= 0 && x < size && y >= 0 && y < size && gridIcons[x][y] == player {
        count += 1
        x -= dx
        y -= dy
    }
    
    if count >= 3 {
        return true
    }
}
```

This combination of UI, state management, and algorithmic thinking made the project both challenging and rewarding.

