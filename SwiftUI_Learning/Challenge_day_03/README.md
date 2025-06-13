# Connect 4 

A fun and interactive **Connect 4** game built using **SwiftUI**. Two players take turns to drop discs into a 7-column, 6-row grid. 

The first player to align four of their discs horizontally, vertically, or diagonally wins the game.

## What You’ll Build

- A complete two-player Connect 4 game interface.
- A dynamic and responsive grid that updates in real time.
- Game logic that checks for a winner after each move.
- A visual turn indicator to track which player's turn it is.
- Clean separation between UI and logic for better maintainability.

---

## What You’ll Learn

By completing this project, you'll gain experience in:

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

### Main Components

* **ContentView\.swift**: The main SwiftUI view that renders the game board and player UI.

* **Game Logic**:

* `handleCellTapped`: Handles user tap, drops the disc in the lowest empty row of the tapped column.

* `checkWinner`: Checks for winning conditions after every move.

* `isBoardFull`: Determines if the board is full by checking for any empty cells

* `updateIcons(newIcon:)`: Allows players to update their disc icon, ensuring the opponent’s icon is automatically switched to avoid conflicts

* `resetGame()`: Resets all game state variables to start a new game:

---

## Final Thought

Building Connect Four in SwiftUI was both a fun and instructive experience — it gave me the chance to sharpen my SwiftUI skills, especially around state management, game logic, and customizing UI components. But like most 
real-world projects, it came with an unexpected hurdle.

### The `.inline` Picker Problem: A UI That Looked Right but Didn’t Work

One surprising issue was with SwiftUI’s `Picker` when using the `.inline` style — a subtle UI bug that took a bit of time to identify and solve.

#### What I Wanted to Do

We wanted players to be able to choose an icon (emoji) for their token. A `Picker` seemed perfect:

```swift
Picker("", selection: selectedBinding) {
    ForEach(Icons.allCases, id: \.self) { icon in
    HStack(spacing: 12) {
    ImageAsset(name: icon.rawValue)
    .frame(width: 20, height: 20)

    Text(icon == .red ? "Red" : "Yellow")
    .subHeadLineStyle()
    .frame(width: 60, alignment: .center)
    }
    .frame(width: 140, alignment: .center)
    }
}
.pickerStyle(.inline)
```

This placed the options visibly in the form, without the need for a dropdown — great for user experience.

#### What Went Wrong

Despite appearing in the UI and responding visually to taps, the `Picker` **didn’t actually reupdate** when tapping on a new `icon`

In other words:

* Tapping an icon **looked like it worked**, but `playerOneIcon` stayed the same. However, if the user decided to change to a new `icon`, it didn't let them

#### Why It Happened

Upon doing some researching, this turned out to be a **known issue in SwiftUI**, particularly:

* When a `.pickerStyle(.inline)` is used **within a `NavigationStack` or `Form`**, it can **break two-way binding**.
* The view updates **visually**, but the actual state-binding (in our case, `@State`) **does not get triggered**.

#### How We Fixed It

I switched the `pickerStyle` to a different one that’s known to work well in forms and stacks:

```swift
.pickerStyle(.wheel)
```

This updated the UI and state correctly, solving the problem. The `wheel` picker also fits nicely in our game setup screen, giving a clean and interactive experience.


### Subtle SwiftUI State Bugs
SwiftUI encourages a declarative style, but that comes with the challenge of unexpected state behavior. At times, views would re-render in ways that caused `@State`  variables to become stale or inconsistent. 
Debugging these issues required a clear mental model of how and when SwiftUI updates the view hierarchy, and occasionally restructuring how state was propagated.

### Win-Checking Logic in a Matrix
Implementing a win-detection system required traversing a 2D matrix in all four cardinal directions (horizontal, vertical, and both diagonals). This involved careful handling of bounds checking to avoid crashes when 
approaching the edges of the grid. The logic had to be both efficient and readable, with conditions that short-circuit early to avoid unnecessary computation once a win was detected.

### Visual vs. Logical Debugging
A major pain point was distinguishing between visual glitches and underlying logic bugs. SwiftUI’s debugging tools are still limited, especially when it comes to observing real-time state changes. This often meant 
inserting temporary UI elements (like debug text overlays) or print() statements to manually trace the logic path and spot where state diverged from expectations.

