
# Flip & Sum – Guess the Card Sum Value

**Flip & Sum** is an interactive SwiftUI game where your goal is to reach a randomly generated target sum by flipping hidden-value cards from a stacked deck. But there’s a twist — every flip counts as a move, and points 
above the target get added to your score!

---

## What You’ll Build

A fun and animated card game built entirely with SwiftUI where players:

* Are shown a **Target Sum** at the top.
* Flip cards to **reveal hidden values**.
* Try to match or exceed the target using **as few moves as possible**.
* Track **Current Sum**, **Moves**, and **Score**.
* See **instant feedback** through animations and a congratulatory alert once the target is reached.

---

## Features

* Random deck of cards generated each round.
* A guaranteed reachable **Target Sum**, based on two of the generated cards.
* Smooth **card flip animations** with 3D effects and offset stacking.
* **Current Sum**, **Move Counter**, and **Score Tracker** updated in real-time.
* **Alert** when the target is reached, including bonus points for overshooting the target.
* **Reset Button** regenerates a new deck, target, and resets all game stats.

---

## What You’ll Learn

This project helps you build deeper SwiftUI skills like:

* Using `@State` to manage UI-driven game logic (moves, sum, cards, score).
* Smooth animations with `.rotation3DEffect`, `.offset`, and `.spring()`.
* Creating reusable components like `FlipCardView` with **callback closures**.
* Displaying conditional `.alert` messages with `isPresented`.
* Structuring your code with **data models** like `Card` and `GameData` to separate logic from view state.
* Performing logic after animations using `DispatchQueue.main.asyncAfter`.

---


## Project Structure

* `**TitleScreen.swift**`: The launch screen of the app. Features:

  * Animated “Play Game” button with scaling and color change on press.
  * Overlapping **gradient-filled circles** using `HalfCircleScreen` for a custom background.
  * Uses `.fullScreenCover` to present the main game.
  * `HalfCircleScreen`: Helper view for the background gradient circles on the title screen.

* `**GameScreen**`: Core game logic and UI:

  * Tracks moves, score, and current sum.
  * Displays target sum in a toolbar.
  * Animates and removes cards once flipped.
  * Triggers a congratulatory alert when the target is reached.

* `**FlipCardView.swift**`: Reusable card view with:
  * Tap gesture handling.
  * Smooth **3D flip animation** using `.rotation3DEffect`.

* `**Card** and GameData`: Logic layer:

  * `Card`: Struct holding card value and flipped state.
  * `GameData`: Handles random card generation and ensures target is always achievable by summing two cards.

---

## Final Thoughts

This project is great for SwiftUI learners who want to explore animations, state management, and basic game logic in a fun and visually rewarding way.

You’ll finish with:

* A deeper understanding of **SwiftUI's data flow**.
* Confidence using `@State`, closures, and custom views.
* A fun project that’s easy to expand — add a timer, lives, levels, or multiplayer mode!

> Can you beat your best score using the fewest possible moves? Flip smart!

---

