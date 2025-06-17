# Challenge Day 4 - Flip & Sum

---

## Features

* A **deck of cards** is randomly generated at the start of each game, each with a hidden number.
* A **Target Sum** is generated based on two random card values — guaranteeing the goal is achievable.
* Tap to **flip cards** and reveal their values.
* Flipped cards contribute to a **Current Sum**, with each flip also increasing the **Move Counter**.
* Once the Current Sum reaches or exceeds the Target Sum, any **excess points** are added to your **Score**.
* Game shows an **alert with a custom message** and allows replay with the same smooth experience.
* **Game reset** logic re-initializes cards, sum, and moves.
* Smooth card animations using `offset`, `zIndex`, and `.spring()` for fluid stacking and flipping.
* Clean UI: Responsive design, custom radial gradients, and color styling for clear visual feedback.

---

## Why This Challenge?

This project was built to help me practice:

* `@State` and `@Binding` for two-way data flow between parent and child views.
* Animating view transitions with `withAnimation`, `.offset`, and 3D effects.
* State-driven UI updates based on card flipping and dynamic scorekeeping.
* Designing interactive views and managing game logic within SwiftUI's declarative framework.

---

## What I Learned

* How to **design reusable custom views** like `FlipCardView` with flip logic and animations.
* How to **pass callbacks using closures** from a child view (`FlipCardView`) to update parent state.
* Using `@State` to manage dynamic values like score, current sum, and remaining cards.
* Leveraging ** `.onAppear` ** to initialize or restore game state when views load.
* How to perform logic after a view change using `DispatchQueue.main.asyncAfter`.
* The importance of layout structure: `Spacer`, `ZStack`, and `VStack` to **avoid shifting UI** during animations.
* Implementing `resetGame()` to regenerate state cleanly without re-initializing `@State` properties directly in `init`.
* Creating a custom `Title Screen` with `GeometryReader` and layered gradient backgrounds using reusable `HalfCircleScreen` views.
* Applying `.fullScreenCover` to transition from the title screen to the main game in a modal style.



---

## Challenges and Problems Encountered

### 1. Card Offset Issues

**Problem**: The **last card** in the stack wouldn’t animate upward after being flipped.
**Solution**: Switched from dynamic index-based offset to a consistent offset formula:

```swift
.offset(y: card.isFlipped ? -60 : CGFloat(index * 20))
```

### 2. `Current Sum` Text Moving on Flip

**Problem**: Flipping cards caused the **Current Sum text** to shift position unexpectedly.
**Solution**: Wrapped the card stack in a `.frame(height:)` and used `Spacer()` around the text in a fixed `HStack` to prevent layout shifts.

### 3. Navigation Transition from Title Screen

**Problem**: Using `.navigationStack` or `.navigationDestination` allowed unintended back-navigation to the Title Screen.
**Solution**: Replaced navigation with `.fullScreenCover(isPresented:)` to modally present `GameScreen`, providing a cleaner, one-way transition.

### 4. SwiftUI Init Error: `self used before all stored properties are initialized`

**Problem**: Attempting to reference `gameData` inside `init()` before all properties were initialized caused a runtime error.
**Solution**: Moved any dependent assignments (like `cards = gameData.cards`) to `.onAppear`, avoiding premature access to `self`.

### 5. Resetting the Game State

**Problem**: Could not reset `gameData`'s cards and target due to its use as a `let` constant inside a struct.
**Solution**: Refactored `gameData` into a mutable `@State` and created a `resetGame()` function to cleanly reset:

* `cards`
* `currentSum`
* `currentMoves`
* `score`
* `targetReached`

