# Guess the Flag: A SwiftUI Game App

Welcome to **Guess the Flag**, a beginner-friendly interactive game that teaches the **fundamentals of SwiftUI** by building a flag-guessing quiz.

You’ll create an engaging UI, manage state, respond to user input, and even handle game flow — all while learning how to think declaratively with SwiftUI.

---

## What You’ll Learn

* How to build layouts using **Stacks** (`VStack`, `HStack`, `ZStack`)
* How to **respond to user input** using `Button` and `@State`
* How to present **alerts** with `.alert()`
* How to use **images** from the asset catalog
* How to manage **game state**: score, current question, and game reset
* How to structure **custom layouts** and even build a **3×3 grid**

---

## What the App Does

* Shows the user **three country flags**
* Asks the user to **tap the flag** that matches a specific country name
* Shows an **alert** after each question, indicating right or wrong
* **Tracks and displays the score**
* **Ends after 8 questions** with a final score and option to restart

---

## Project Structure

This app is built in **three progressive parts**, each building on the last:

---

### Part 1: SwiftUI Foundations

* Create a vibrant UI using `ZStack`, `LinearGradient`, and custom styling
* Display images and style them with `.clipShape`, `.shadow`, and `.resizable`
* Learn how to bind state using `@State`

---

### Part 2: Interactive Logic

* Use `Button` and `ForEach` to render multiple flag choices
* Use `@State` to track game data like `score`, `correctAnswer`, and `showingScore`
* Show alerts conditionally to guide the player through each round

---

### Part 3: Challenges for Mastery

You’ll tackle **3 mini challenges** to reinforce your learning:

1. **Track and Display Score**
   Show the current score in real-time and in alerts — using `@State` with safety checks to avoid negative scores.

2. **Explain Wrong Answers**
   Update the alert to say:

   > “Wrong! That’s the flag of France.”
   > by using **string interpolation** with the tapped flag’s country name.

3. **Limit to 8 Questions and Restart**
   Add a question counter, and after 8 rounds show a final alert with the user’s **total score** and a **"Play Again"** button.

---

## Bonus: Layout Experiments

You’ll also explore **custom grid layouts**:

### Custom 3×3 Grid

Use nested `VStack` and `HStack` with `ForEach` to simulate a 3×3 layout manually, learning how to map 2D rows and columns into a flat array.

### LazyVGrid for Efficiency

Switch to `LazyVGrid` for cleaner, scalable code using this layout:

```swift
let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
]
```

This approach:

* Reduces boilerplate code
* Adapts gracefully to different screen sizes
* Improves performance by lazily loading views

---

## SwiftUI Quirks: Alert Limitations

You’ll discover an important SwiftUI constraint:

> You can only apply **one `.alert` modifier** per view.

If you try to use two `.alert()`s, only the **last one** is active — causing unexpected issues like double alerts or ignored messages.

### The Fix

Use a **single unified alert** that conditionally shows different messages based on game state:

```swift
.alert(isPresented: ...) {
    if showingFinalScore {
        // Final score alert
    } else {
        // Regular score alert
    }
}
```

---

## Final Thoughts

This project combines **fundamentals** with **fun**. 

By the end, you’ll understand:

* SwiftUI layout and user interaction
* State management with `@State`
* Handling game logic and UI feedback
* Designing dynamic UI with flexible layouts

Perfect for beginners looking to **build a complete, real-world SwiftUI app**.

