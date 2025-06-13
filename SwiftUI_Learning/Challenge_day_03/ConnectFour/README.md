# Challenge Day 3 - Connect 4

---

## Features

* **State Management**

State in SwiftUI allows the interface to react to changes in underlying data. The following `@State` properties manage the entire lifecycle and behavior of the Connect 4 game:

**Player and Turn Management**

```swift
@State private var playerOneIcon: Icons = .red
@State private var playerTwoIcon: Icons = .yellow
@State private var selectedIcon: Icons = .red
@State private var selectedUser: Users = .player1
```

* `playerOneIcon` / `playerTwoIcon`: Store each player's disc color or icon. These are used to render the appropriate color when placing a disc.
* `selectedIcon`: Keeps track of which icon should be placed next — changes every turn.
* `selectedUser`: Determines whose turn it is (`.player1` or `.player2`), allowing the game logic to alternate moves.


**Game Board State**

```swift
@State private var gridIcons:[[String?]] = Array(
repeating: Array(repeating: nil, count: ContentView.MAX_COLUMNS),
count: ContentView.MAX_ROWS
)
```

* `gridIcons`: A 2D array (`rows x columns`) representing the game board. Each cell stores a player's icon (`"red"` or `"yellow"`) or `nil` if empty. This state drives the entire visual representation of the board and is updated after each move.

**Win & Draw Tracking**

```swift
@State private var isWinner = false
@State private var winningUser: Users? = nil
@State private var isDraw = false
```

* `isWinner`: A flag to determine whether a winning condition has been met. When `true`, the game is over.
* `winningUser`: Stores which player has won the game.
* `isDraw`: Set to `true` if all cells are filled without any player winning — indicating a draw scenario.

**UI Interaction Support**

```swift
@State private var selectedIconForPicker: Icons = .red
```

`selectedIconForPicker`: Used for settings or user selection of their icon color before the game starts. This value is usually updated through a picker view and applied to `playerOneIcon` or `playerTwoIcon`.

**Winner Check Logic**

Each time a player drops a disc, a winner check is performed. 

The algorithm looks for **4 consecutive discs** in the following **four directions**:

```swift
let directions = [(0, 1), (1, 0), (1, 1), (1, -1)]
```

These represent:

* `(0, 1)` → **Right (horizontal)**
* `(1, 0)` → **Down (vertical)**
* `(1, 1)` → **Diagonal forward** ↘
* `(1, -1)` → **Diagonal backward** ↙

The logic checks the number of same-colored discs in both forward and backward directions for each of these, starting from the last move, ensuring optimal performance by avoiding full-board scanning.

---


## How the `checkWinner` Works

After each disc drop, we run a `checkWinner` function to detect if the latest move led to a win. 

It works by checking four directions from the last placed disc:

- **Horizontal (—)**
- **Vertical (|)**
- **Diagonal Forward (↘)** — bottom-left to top-right
- **Diagonal Backward (↙)** — top-left to bottom-right

Instead of manually iterating through every possible match, we use a loop that checks both sides of the current disc in each direction:

```swift
func checkWinner(row: Int, col: Int, icon:String) ->Bool{
let directions = [(0, 1),   // Right →
(1, 0),   // Down ↓
(1, 1),   // Down-Right ↘
(1, -1)]  // Down-Left ↙

for (dr, dc) in directions{
var count = 1

// Check in the positive direction
count += countMatches(row: row, col: col, dr: dr, dc: dc, icon: icon)
// Check in the negative direction
count += countMatches(row: row, col: col, dr: -dr, dc: -dc, icon: icon)

if count >= 4 {
return true
}
}
return false
}

func countMatches(row:Int, col: Int, dr: Int, dc:Int, icon:String) -> Int{
var r = row + dr
var c = col + dc

var matchCount = 0

let size = gridIcons.count


while r >= 0 && r < size && c >= 0 && c < size && c < gridIcons[0].count {
if gridIcons[r][c] == icon {
matchCount += 1
} else{
break
}
r += dr
c += dc
}

return matchCount
}

````

This technique is **efficient** and **concise**, allowing us to check all directions with minimal code and no unnecessary duplication.

---

## How the `handleCellTapped(row:col:)` Works

This function is triggered whenever a player taps a column on the board:

* **Disc dropping behavior:**
It finds the lowest empty row in the tapped column (`col`) by iterating from the bottom row upwards, ensuring discs "fall" naturally to the lowest available spot.

* **Updating the board:**
Once the correct position (`r`, `col`) is found, the current player's icon (red or yellow) is placed in the `gridIcons` 2D array.

* **Win check:**
Immediately after placing the disc, it calls `checkWinner` to verify if this move creates a winning condition (four consecutive discs).

* **Draw check:**
If no winner is found, it calls `isBoardFull` to check if all cells are filled, marking a draw if so.

* **Switching turns:**
If neither win nor draw occurs, it switches the active player for the next turn.


```swift 
func handleCellTapped(row:Int, col:Int) {
for r in (0..<ContentView.MAX_ROWS).reversed() {
if gridIcons[r][col] == nil {
let currentCoin = selectedUser == .player1 ? playerOneIcon : playerTwoIcon
gridIcons[r][col] = currentCoin.rawValue

// Check if the current move causes a win
if checkWinner(row: r, col: col, icon: currentCoin.rawValue) {
winningUser = selectedUser
isWinner = true
print("Winner is \(selectedUser)")
}
else if isBoardFull() {
isDraw = true
}
else {
selectedUser = selectedUser == .player1 ? .player2 : .player1
}

return
}
}
}

```

---

## How the `isBoardFull() -> Bool` Works

This helper function scans the entire `gridIcons` array to see if any cell is still empty (`nil`). If all cells are occupied, it returns `true` signaling the board is full and the game is a draw.

```swift 
func isBoardFull() -> Bool {
for row in gridIcons {
for cell in row {
if cell == nil {
return false
}
}
}
return true
}
```
---

## How the `updateIcons(newIcon:)` works

Allows players to change their disc icons dynamically before or during the game, ensuring no two players share the same icon. When one player’s icon updates, the other’s icon automatically switches to the alternate.

```swift
func updateIcons(newIcon: Icons) {
if selectedUser == .player1 {
playerOneIcon = newIcon
playerTwoIcon = Icons.allCases.first(where: { $0 != newIcon })!
} else {
playerTwoIcon = newIcon
playerOneIcon = Icons.allCases.first(where: { $0 != newIcon })!
}
}
```

---

## How the `resetGame()` works

Resets all game state variables and clears the board, readying the game for a new match. It resets the winner, draw status, current player, and clears all discs from `gridIcons`.

```swift
func resetGame() {
isDraw = false
isWinner = false
winningUser = nil
selectedUser = .player1
gridIcons = Array(
repeating: Array(repeating: nil, count: ContentView.MAX_COLUMNS),
count: ContentView.MAX_ROWS
)
}
```


--- 


## Why This Challenge?

I chose to build Connect 4 as a way to:

* Deepen my understanding of **SwiftUI layout and animation systems**
* Tackle **state management** for turn-based logic
* Learn how to build interactive board games from scratch
* Explore visual and user interface polish through gradients, shapes, and transitions

---


## What I Learned

### SwiftUI Quirks

  * `Picker` behaves inconsistently inside `Form`, `NavigationStack`, or `ScrollView`
  * State can **fail to bind or update silently** without warning
  * Troubleshooting tip: test with different `.pickerStyle` modifiers

### State Management

  * Managing gameplay with `@State`, `@Binding`, and model separation required clarity and rigor
  * Avoiding excessive view refresh and ensuring state propagation was key

### Custom UI Architecture

  * Created reusable **custom containers** and **modifiers** to enforce layout consistency
  * Prioritized modular views and separation of concerns for maintainability

### Matrix-Based Game Logic

  * Connect 4 board modeled as a `[[Cell]]` matrix (6 rows × 7 columns)
  * Win detection required matrix traversal in 4 directions:

    * **Horizontal** →
    * **Vertical** ↓
    * **Diagonal** ↘ and ↙

---

## Challenges and Problems Encountered

* Picker bindings would silently break depending on their placement in view hierarchy
* Subtle bugs due to SwiftUI view re-renders or stale state
* Writing robust **win-check logic** while avoiding out-of-bounds access in the matrix
* Diagnosing visual vs. logic-related issues with minimal SwiftUI debug tooling

