# ViewsAndModifiers

Welcome to **Views and Modifiers**, a deep dive into SwiftUI’s architecture and behavior.

---

## What You’ll Learn

* Why SwiftUI uses **structs** for views
* The purpose of `` `some View` `` and how it enables type erasure
* How **view modifiers** are applied and chained
* The **functional nature** of SwiftUI's rendering process

---

## What the App Does

Rather than building a specific UI, this project explores how SwiftUI works under the hood by experimenting with views, modifiers, and custom extensions.

---

## Project Structure

This is a **technique project** focused on experimentation and conceptual learning. 

We'll build small code examples in a new SwiftUI app called **ViewsAndModifiers** to understand how views are composed and modified.

---

### Part 1: Views and Modifiers Foundation 

Learn the basics of composing and styling SwiftUI views using modifiers, environment modifiers, and view properties to build clear, reusable UI components.

--- 

### Part 2: Applying Conditional Styling, Custom Views, and Modifiers

In this part, I focused on making my SwiftUI code cleaner, more reusable, and more dynamic by tackling three key challenges:

* **Challenge 1:** 

- In `WeSplit` app, I used a conditional modifier to change the color of the total amount text to red whenever the user selected a 0% tip. 

- This helped me practice how to apply conditional styling to views based on state.

* **Challenge 2:** 

- In `Guess The Flag` app, I replaced the plain `Image` views in my flag guessing game with a custom `FlagImage` view that encapsulates a set of modifiers for consistent sizing, clipping, and shadows.

- This made my code neater and improved reusability.

* **Challenge 3:** 

- Also in `Guess The Flag` app, I created a custom `ViewModifier` along with a `View` extension to define a reusable style for large, blue, prominent titles. 

- This gave me hands-on experience with extending SwiftUI views to keep styling code clean and maintainable.

---

## Final Thoughts

This project taught me how to:

* Use conditional modifiers to dynamically change view appearance

* Build reusable, composable custom views

* Create and apply custom view modifiers for consistent styling across the app

