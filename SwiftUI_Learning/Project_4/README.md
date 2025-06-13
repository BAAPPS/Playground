# BetterRest

Welcome to **BetterRest**! In this project, you'll be expanding your SwiftUI skills while diving into the fascinating world of **machine learning**.

## What You'll Learn

This project introduces a powerful and timely concept: teaching machines to think. As Swedish professor **Nick Bostrom** once said:

> "*Machine intelligence is the last invention that humanity will ever need to make.*"

Whether or not that's true, it's clear that **machine learning** is becoming an essential tool in the modern developer’s toolkit.

You’ll discover just how accessible machine learning can be within SwiftUI — it’s more natural and approachable than you might think.

In today’s session, you’ll explore:

* `Stepper`
* `DatePicker`
* `DateFormatter`
* `Core ML`
* SwiftUI layout using `Form`, `Section`, `Picker`, and `NavigationStack`

##  What the App Does

**BetterRest** helps users determine the *ideal bedtime* based on:

* Desired wake-up time
* Preferred amount of sleep
* Daily coffee intake

The app uses a trained **Core ML** model (`SleepCalculator.mlmodel`) to make personalized predictions. As users adjust their inputs, the app updates their recommended bedtime instantly using an on-device machine learning model.

## Project Structure

The app is structured in a clean SwiftUI architecture with a single main view (`ContentView.swift`), featuring:

* Real-time data binding with `@State`
* A built-in machine learning model for predictions
* Form-based layout using `Section` and `Picker` for modern UI interaction
* An `idealBedTime` computed property that returns live updates
* Clean formatting with `.formatted(date: .omitted, time: .shortened)`

---

### Part 1: Core Features

* Users set their **wake-up time** using `DatePicker`.
* They choose how many **hours of sleep** they want using a `Stepper`.
* They select their **daily coffee intake** using a `Picker`.

All inputs are tied to state variables, which feed directly into the Core ML model for real-time predictions.

---

### Part 2: UI Enhancements

* Replaced `VStack` with `Section` headers for a cleaner form layout.
* Swapped the coffee `Stepper` for a `Picker` to show 0–20 cups.
* Removed the "Calculate" button in favor of a **live-updating bedtime preview** with a large, readable font.

---

## Final Thoughts

Building **BetterRest** was a great introduction to using **Core ML** in real-world iOS apps. I learned how to integrate a machine learning model to make instant predictions based on user input, and explored **Create ML** 
to better understand how such models are trained. Seeing how easily Core ML fits into a SwiftUI project really opened my eyes to how powerful — and approachable — on-device intelligence can be. This project deepened my 
knowledge of both SwiftUI and machine learning, and showed me how they can work together to build smarter, user-focused apps.

