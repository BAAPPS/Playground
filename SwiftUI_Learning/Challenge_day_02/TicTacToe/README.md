# Challenge Day - Tic Tac Toe

This project is a **self-directed SwiftUI challenge** designed to deepen my understanding of building interactive UIs with SwiftUI by creating a classic Tic Tac Toe game from scratch.

---

## What You’ll Learn

- **SwiftUI fundamentals:** Building views, layouts, and handling user input  
- **State management:** Using `@State` and `@Binding` to track game state and player turns  
- **Modifiers & Custom Views:** Creating reusable UI components and styling with custom modifiers  
- **Real-time interactions:** Updating the UI in response to user actions immediately  
- **Game logic:** Implementing rules, win detection, and game resets

---

## Features

### Interactive 3x3 Grid

The board uses a custom `Grid` view that renders a 3x3 layout and listens for cell taps.

```swift
Grid(rows: 3, columns: 3) { row, col in
    Button(action: {
        handleCellTapped(row: row, col: col)
    }) {
        ZStack {
            Color.clear
                .frame(width: 100, height: 100)
                .contentShape(Rectangle())

            if let iconName = gridIcons[row][col] {
                imageAsset(name: iconName)
                    .frame(width: 24, height: 24)
            }
        }
    }
}
````

### Handling Cell Taps and Updating Game State

The core gameplay happens when a player taps a cell on the grid. 

The app checks if the tapped cell is empty and then updates the board state (`gridIcons`) accordingly. 

It uses `@State` to keep track of the board as a 2D array of optional strings representing the placed icons:

```swift
@State private var gridIcons: [[String?]] = Array(
    repeating: Array(repeating: nil, count: 3),
    count: 3
)
````

When a cell is tapped, `handleCellTapped` runs:

```swift
func handleCellTapped(row: Int, col: Int) {
    // Ignore taps on occupied cells
    guard gridIcons[row][col] == nil else { return }
    
    // Set the current player's icon in the tapped cell
    let currentIcon = selectedUser == .player1 ? playerOneIcon : playerTwoIcon
    gridIcons[row][col] = currentIcon.rawValue
    
    // Check for win or draw
    if winner(row: row, col: col) {
        winnerPlayer = selectedUser
        isWinner = true
    } else if isBoardFull() {
        isDraw = true
    } else {
        // Switch turns if no win or draw
        selectedUser = selectedUser == .player1 ? .player2 : .player1
    }
}
```

### Player Turn Tracking

The app keeps track of the current player and their associated icon using `@State`.

```swift
@State private var selectedUser: Users = .player1
@State private var playerOneIcon: Icons = .x
@State private var playerTwoIcon: Icons = .o
```

It dynamically updates:

```swift
selectedUser = selectedUser == .player1 ? .player2 : .player1
```

### Win & Draw Detection

Win detection checks rows, columns, and diagonals in all directions.

```swift
func winner(row: Int, col: Int) -> Bool {
    guard let player = gridIcons[row][col] else { return false }
    let directions = [(0, 1), (1, 0), (1, 1), (1, -1)]
    for (dx, dy) in directions {
        var count = 1
        // Check in both directions
        ...
        if count >= 3 { return true }
    }
    return false
}
```

Draws are handled when the board is full and no winner is found:

```swift
func isBoardFull() -> Bool {
    for row in gridIcons {
        for col in row {
            if col == nil { return false }
        }
    }
    return true
}
```

### Custom UI Components

Custom views improve modularity:

#### Icon Image View:

```swift
struct imageAsset: View {
    var name: String
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
    }
}
```

#### Title Style Modifier:

```swift
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}
```

### Styling and Feedback

Gradient backgrounds, icons, and segmented pickers enhance user experience:

```swift
RadialGradient(
    stops: [
        .init(color: Color(.white), location: 0.1),
        .init(color: Color(red: 0.2, green: 0.92, blue: 0.95), location: 0.9)
    ],
    center: .center,
    startRadius: 100,
    endRadius: 800
)
```

Game results use native SwiftUI alerts:

```swift
.alert("Game Over", isPresented: $isWinner) {
    Button("OK") { resetGame() }
} message: {
    Text("\(winnerPlayer?.rawValue ?? "Player") wins!")
}
```

### Game Reset Button

The game can be reset anytime after win or draw:

```swift
func resetGame() {
    gridIcons = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    selectedUser = .player1
    isWinner = false
    winnerPlayer = nil
    isDraw = false
}
```

---

## How to Use

* Tap any empty cell to place your mark (X or O)
* The game automatically switches turns
* When a player wins or the board is full, a message appears
* Use the reset button or alert to start a new game

---

## Why This Challenge?

Tic Tac Toe is a perfect beginner-friendly project that touches on many core SwiftUI concepts. 

It combines:

* UI design
* State management
* Basic AI/game logic
* User interaction

---


## What I Learned

* **State management with 2D arrays:** Managing the Tic Tac Toe board as a 2D array of optional strings (`[[String?]]`) helped me understand how to represent complex UI state in SwiftUI.
* **Conditional updates:** Using guards to prevent invalid moves (tapping occupied cells) ensures game rules are enforced properly.
* **Turn management:** Switching players dynamically after each valid move reinforced working with `@State` and binding UI behavior to state changes.
* **Win and draw detection integration:** Coupling the move handler with game logic like win/draw detection helped me see how UI and logic interact in real-time apps.
* **SwiftUI's reactive rendering:** The UI automatically re-renders based on changes in the `gridIcons` state, demonstrating the power of SwiftUI’s declarative model.

---

## Challenges and Problems Encountered

* **Handling state immutability:** Updating nested arrays inside a `@State` property required careful attention to avoid unintended side effects or inconsistent UI updates.
* **Edge case handling in win detection:** Ensuring that checking all possible win directions correctly worked without off-by-one errors took multiple iterations to debug.
* **Avoiding invalid moves:** Preventing users from tapping already occupied cells needed explicit checks early in the handler to avoid state corruption.
* **UI synchronization:** Making sure the turn switched only after a successful move, not prematurely, required carefully ordering state updates.
* **Managing multiple alerts:** Displaying different alerts for wins and draws without overlap or confusion involved toggling multiple `@State` booleans cleanly.

