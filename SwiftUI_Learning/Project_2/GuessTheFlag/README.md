# GuessTheFlag Summary


## Day 20 – Project 2, part one

---

## Key SwiftUI Principles

### 1. **Views Must Conform to `View` Protocol**

Every SwiftUI view returns a single type conforming to the `View` protocol. 

This can be:

- `Text`
- `Image`
- `Form`
- `Picker`
- `NavigationStack`
- Or a container like a `VStack`, `HStack`, or `ZStack`

---

## Layout Tools

### VStack (Vertical Stack)

Places views vertically.

```swift
VStack(spacing: 20) {
    Text("Hello")
    Text("World")
}
````

* Control spacing with `spacing:`
* Control alignment with `.leading`, `.trailing`, `.center`

### HStack (Horizontal Stack)

Places views side-by-side.

```swift
HStack {
    Text("Left")
    Text("Right")
}
```

* Useful for rows
* Also supports spacing and alignment

### ZStack (Depth Stack)

Overlays views on top of each other.

```swift
ZStack {
    Image("background")
    Text("Overlay")
}
```

* No spacing (views overlap)
* Supports alignment (`.top`, `.bottom`, `.center`)

---

## Spacers

Used to push views in a stack. For example:

```swift
VStack {
    Text("Top")
    Spacer()
    Text("Bottom")
}
```

* Adds flexible space between views
* Multiple `Spacer()` views split space evenly

---

## Example Challenge

Try creating a 3x3 grid layout:

```swift
VStack {
    HStack {
        Text("1"); Text("2"); Text("3")
    }
    HStack {
        Text("4"); Text("5"); Text("6")
    }
    HStack {
        Text("7"); Text("8"); Text("9")
    }
}
```

---

## Color Views in SwiftUI

- `Color.red`, `Color.blue`, etc. are **views**, not just color values.

- They expand to fill all available space unless constrained with `.frame()`.

```swift
Color.red
    .frame(width: 200, height: 200)
````

* To stretch and fill all the avaiable width space use `.frame()` with `maxWidth` of `infinity`

- "we want a color that is no more than 200 points high, but for its width must be at least 200 points wide but can stretch to fill all the available width that’s not used by other stuff"

```swift
Color.red
    .frame(minWidth: 200, maxWidth: .infinity, maxHeight: 200)
```

* Use `.background()` to add color behind views:

```swift
Text("Label")
    .background(Color.red)
```

But for full background coverage in a stack, use `Color.red` directly in a `ZStack`:

```swift
ZStack {
    Color.red
    Text("Content")
}
```

---

### Safe Areas and Full-Screen Backgrounds

By default, SwiftUI leaves space around system UI (notch, home indicator).

To extend your view edge-to-edge, use:

```swift
.ignoresSafeArea()
```

#### Example:

```swift
ZStack {
    Color.red
    Text("Your content")
}
.ignoresSafeArea()
```

Only use `.ignoresSafeArea()` for **decorative** content, not essential UI elements.

---

### Materials and Vibrancy

You can apply **frosted glass effects** with SwiftUI’s `.background()` modifier and built-in **materials**:

```swift
Text("Frosted")
    .padding()
    .background(.ultraThinMaterial)
```

This lets the background show through slightly, adapting to light/dark mode automatically.

#### Example with depth:

```swift
ZStack {
    VStack(spacing: 0) {
        Color.red
        Color.blue
    }

    Text("Your content")
        .foregroundStyle(.secondary)
        .padding(50)
        .background(.ultraThinMaterial)
}
.ignoresSafeArea()
```


### Summary

* SwiftUI treats colors as full views.

* `.background()` is useful for view-level styling.

* Use `ZStack + Color` for layered backgrounds.

* Handle layout properly with `.frame()` and `.ignoresSafeArea()`.

* Materials offer adaptive, elegant depth with built-in vibrancy.

---

## LinearGradient

Draws a straight-line transition between colors.

```swift
LinearGradient(
    colors: [.white, .black],
    startPoint: .top,
    endPoint: .bottom
)
````

### With Gradient Stops:

```swift
LinearGradient(
    stops: [
        .init(color: .white, location: 0.45),
        .init(color: .black, location: 0.55)
    ],
    startPoint: .top,
    endPoint: .bottom
)
```

Gradient stops give you precise control over color placement.

---

## RadialGradient

Expands outward from a center point in a circular pattern.

```swift
RadialGradient(
    colors: [.blue, .black],
    center: .center,
    startRadius: 20,
    endRadius: 200
)
```

Great for spotlight or halo effects.

---

## AngularGradient

Also known as conic gradient. Cycles through colors around a central point.

```swift
AngularGradient(
    colors: [.red, .yellow, .green, .blue, .purple, .red],
    center: .center
)
```

Ideal for color wheels, dials, or vibrant accent backgrounds.

---

## Automatic Gradient from Colors

SwiftUI lets you append `.gradient` to any `Color` to create a subtle linear gradient.

```swift
Text("Your content")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .foregroundStyle(.white)
    .background(.red.gradient) // Tinder like background
```

⚠️ This type is not a standalone view and is only used in styles (`background`, `foregroundStyle`, etc.).

---

### Summary

| Gradient Type     | Use As View | Supports Stops | Direction/Shape     |
| ----------------- | ----------- | -------------- | ------------------- |
| `LinearGradient`  | ✅           | ✅              | Top → Bottom, etc.  |
| `RadialGradient`  | ✅           | ✅              | Center → Radius     |
| `AngularGradient` | ✅           | ✅              | Circular Spin       |
| `.color.gradient` | ❌           | ❌              | Subtle Top → Bottom |

Gradients in SwiftUI are powerful yet simple — giving designs depth, focus, and color transitions with minimal effort.

---

## Basic Button Usage

The simplest form:
```swift
Button("Delete selection") {
    print("Now deleting…")
}
````

With a separate method:

```swift
Button("Delete selection", action: executeDelete)

func executeDelete() {
    print("Now deleting…")
}
```

### Button Roles

Roles help communicate intent and accessibility:

```swift
Button("Delete selection", role: .destructive, action: executeDelete)
```


### Button Styles

SwiftUI offers built-in styles:

```swift
VStack {
    Button("Default") { }
        .buttonStyle(.bordered)

    Button("Destructive", role: .destructive) { }
        .buttonStyle(.bordered)

    Button("Prominent") { }
        .buttonStyle(.borderedProminent)

    Button("Prominent Destructive", role: .destructive) { }
        .buttonStyle(.borderedProminent)
}
```

### Tint Customization

```swift
Button("Mint") { }
    .buttonStyle(.borderedProminent)
    .tint(.mint)
```

⚠️ Use prominent buttons sparingly to maintain visual hierarchy.


### Custom Buttons with Views

You can create fully custom buttons using a label closure:

```swift
Button {
    print("Tapped")
} label: {
    Text("Tap me!")
        .padding()
        .foregroundStyle(.white)
        .background(.red)
}
```

---

## Working with Images

SwiftUI’s `Image` type loads images in three main ways:

```swift
Image("pencil")                // From asset catalog
Image(decorative: "pencil")    // Skips VoiceOver
Image(systemName: "pencil")    // From SF Symbols
```

Tip: Use `Image(decorative:)` for visual-only icons to avoid confusing screen readers.


## Buttons with Text & Icons

### Method 1: Built-in support

```swift
Button("Edit", systemImage: "pencil") {
    print("Edit tapped")
}
```

### Method 2: Using `Label`

```swift
Button {
    print("Edit tapped")
} label: {
    Label("Edit", systemImage: "pencil")
        .padding()
        .foregroundStyle(.white)
        .background(.red)
}
```

- `Label` automatically adapts to layout constraints (text only, icon only, or both).

---

## Summary

| Feature      | Example/Method                    | Notes                                 |
| ------------ | --------------------------------- | ------------------------------------- |
| Basic Button | `Button("Title") {}`              | Runs an action on tap                 |
| Role         | `role: .destructive`              | Adjusts appearance/accessibility      |
| Styles       | `.bordered`, `.borderedProminent` | Customize with `.tint()`              |
| Custom Label | `Button { } label: { View }`      | Any view inside the button            |
| Images       | `Image("name")`, `.systemName`    | Use SF Symbols for icons              |
| Label Type   | `Label("Text", systemImage: "")`  | Smart, adaptive layout with icon/text |

--- 

## Basic Alert Workflow

1. Create a `@State` property to control visibility.
2. Use `.alert()` with a binding to that state.
3. SwiftUI manages showing/dismissing the alert automatically.

```swift
@State private var showingAlert = false

Button("Show Alert") {
    showingAlert = true
}
.alert("Important message", isPresented: $showingAlert) {
    Button("OK") { }
}
````

### Dismissal Behavior

* SwiftUI **automatically resets** the `isPresented` binding to `false` when the alert is dismissed.
* You can provide an action in the `Button` closure if you need to do more.

```swift
.alert("Important", isPresented: $showingAlert) {
    Button("OK") {
        // Optional action on dismiss
        print("Alert dismissed")
    }
}
```

### Multiple Buttons & Roles

Alerts can have **more than one button**, and **roles** can help clarify intent (especially for accessibility).

```swift
.alert("Delete Item?", isPresented: $showingAlert) {
    Button("Delete", role: .destructive) {
        // Handle deletion
    }
    Button("Cancel", role: .cancel) { }
}
```

| Role           | Description                                      |
| -------------- | ------------------------------------------------ |
| `.cancel`      | Indicates cancellation; often styled differently |
| `.destructive` | Indicates a destructive action like delete       |


### Adding Message Text

Use a second trailing closure to add a message body to the alert.

```swift
Button("Show Alert") {
    showingAlert = true
}
.alert("Important", isPresented: $showingAlert) {
    Button("OK", role: .cancel) { }
} message: {
    Text("Please read this carefully.")
}
```

### Alert Recap

| Feature          | Usage Example                               | Notes                                 |
| ---------------- | ------------------------------------------- | ------------------------------------- |
| State Binding    | `@State var showingAlert = false`           | Controls when alert appears           |
| Basic Alert      | `.alert("Title", isPresented: $binding)`    | Triggered by state                    |
| Button Actions   | `Button("OK") { ... }`                      | Optional action; dismisses alert      |
| Multiple Buttons | Add multiple `Button` views inside `.alert` | Useful for confirmation flows         |
| Roles            | `.cancel`, `.destructive`                   | Clarifies action purpose for the user |
| Message Text     | `message: { Text("...") }`                  | Adds detail to the alert              |

### Final Tip

- Alerts are **view modifiers** attached to any part of your UI—they don't have to be on the exact `Button`. 

- SwiftUI just cares about the **state**.

--- 

## Day 21 – Project 2, part two

###  **File: `ContentView.swift`**

This is the main view for the "Guess the Flag" game built with **SwiftUI**. 

It introduces fundamental concepts like `@State`, `Button`, `Image`, `Alert`, layout with `VStack`, and styling with `RadialGradient` and modifiers.

###  **State Management: Property Wrappers**

```swift
@State private var showingScore = false
@State private var scoreTitle = ""
@State private var countries = ["Estonia", ..., "US"].shuffled()
@State private var correctAnswer = Int.random(in: 0...2)
```

* `@State` is used to create **mutable state variables** that SwiftUI monitors for changes. When any of these variables are updated, SwiftUI re-renders the `View` to reflect the change.

  * `showingScore`: controls visibility of the result alert.
  * `scoreTitle`: shows the alert title ("Correct"/"Wrong").
  * `countries`: randomized array of country names (used for flag images).
  * `correctAnswer`: random index pointing to the correct country in the current question.

###  **User Interaction Logic**

```swift
func flagTapped(_ number: Int) {
    if number == correctAnswer {
        scoreTitle = "Correct"
    } else {
        scoreTitle = "Wrong"
    }
    showingScore = true
}
```

* **Purpose:** Called when a flag button is tapped.
* **Logic:**

  * Checks if the tapped flag is correct.
  * Updates `scoreTitle` accordingly.
  * Triggers the alert by setting `showingScore = true`.


###  **Next Question Generator**

```swift
func askQuestion() {
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
}
```

* **Purpose:** Resets the game state for the next round.
* Shuffles the flag order and selects a new correct answer index.


### `ZStack` for Background

```swift
ZStack {
    RadialGradient(...)
        .ignoresSafeArea()
    ...
}
```

* Uses a **`RadialGradient`** for a custom colorful background.

* `ignoresSafeArea()` ensures the background covers the whole screen.

---

### `VStack` for Content Layout

```swift
VStack {
    Text("Guess the Flag")
    Spacer()
    Text("Score: ???")
    Spacer()
    VStack(spacing: 15) {
        ...
        ForEach(0..<3) { number in
            Button {
                flagTapped(number)
            } label: {
                Image(countries[number])
                    .clipShape(.capsule)
                    .shadow(radius: 5)
            }
        }
    }
}
.padding()
```

* Organizes the game UI vertically.
* `Text("Tap the flag of")` + the correct country name.
* `ForEach(0..<3)` dynamically generates 3 flag buttons from the shuffled list.

### **Alert System: Declarative Presentation**

```swift
.alert(scoreTitle, isPresented: $showingScore) {
    Button("Continue", action: askQuestion)
} message: {
    Text("Your score is ???")
}
```

* SwiftUI binds an `Alert` to the `@State` property `showingScore`.
* When `showingScore` becomes `true`, the alert pops up.
* Uses **title** from `scoreTitle`, and provides a "Continue" button to call `askQuestion()`.

### SwiftUI Concepts Used:

| Concept                 | Usage Example                         | Description                          |
| ----------------------- | ------------------------------------- | ------------------------------------ |
| `@State`                | `@State var showingScore...`          | Tracks local mutable state.          |
| `ZStack`, `VStack`      | Used for layered and vertical layout. | Organizes views spatially.           |
| `ForEach`               | `ForEach(0..<3)`                      | Generates multiple flag buttons.     |
| `Button`                | Wraps each flag image                 | Triggers game logic.                 |
| `Image`                 | `Image(countries[number])`            | Displays flag based on country name. |
| `.clipShape`, `.shadow` | `Image` modifiers                     | Visual enhancements.                 |
| `.alert`                | Declarative popup alert               | Triggered by `@State` bool.          |
| `RadialGradient`        | Custom background style               | Adds aesthetic flair.                |
| `.ignoresSafeArea()`    | Makes gradient fill screen            | Bypasses safe area insets.           |

---

### Final Code

- Putting everything together, here's the complete implementation of the **Guess the Flag** game using `SwiftUI`:

```swift
struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    func flagTapped(_ number:Int){
        if number == correctAnswer{
            scoreTitle = "Correct"
        }else{
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red:0.16, green:0.1, blue:0.1), location: 0.1),
                .init(color: Color(red: 0.60, green: 0.15, blue: 0.20), location: 0.5),
            ], center: .top, startRadius: 100, endRadius: 800)
                .ignoresSafeArea()

            
            VStack {
                Text("Guess the Flag")
                       .font(.largeTitle.weight(.bold))
                       .foregroundStyle(.white)
                Spacer()
                Text("Score: ???")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3){ number in
                        Button{
                            flagTapped(number)
                        }label:{
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is ???")
        }
    }
}
```

---

## Day 22 – Project 2, part three

### Challenge

To solidify my understanding of SwiftUI concepts such as `@State`, view updates, user interaction, and alerts, I’m setting myself three key challenges to build on the existing **"Guess the Flag"** app:

1. **Track and Display Score**

   Add an `@State` property to keep track of the user’s score. Update the score each time a flag is tapped — increase it for correct answers, and optionally decrease or leave it unchanged for wrong answers.

   * Display the score both in the main view and inside the alert message after each round.

2. **Show Which Flag Was Wrong**

   When a user taps the wrong flag, enhance the alert message to include the name of the country they actually tapped.

   * For example: `"Wrong! That’s the flag of France."`
     This requires comparing the tapped flag index to the `countries` array.

3. **Limit to 8 Questions and Show Final Score**

   Turn the game into a short quiz by allowing only 8 questions per session.

   * After the 8th question, show a final alert that summarizes the user’s total score.
   * Include an option to restart the game, which resets the question count and score.
   
---

#### 1. Track and Display Score

To track and display the player’s score, we’ll use the `@State` property wrapper, which allows SwiftUI to automatically update the view when the score changes.

```swift
@State private var userScore = 0
```

##### Update the Score on Answer

In the `flagTapped(_:)` function:

* **Increment** the score if the answer is correct.
* **Decrement** the score if the answer is wrong — but prevent it from going below zero.

```swift
func flagTapped(_ number: Int) {
    if number == correctAnswer {
        scoreTitle = "Correct"
        userScore += 1
    } else {
        scoreTitle = "Wrong"
        userScore = max(userScore - 1, 0)
    }
    showingScore = true
}
```

##### Why This Matters

Without guarding the score, the value could drop below zero — which typically doesn't make sense in a simple points-based game.

Using Swift’s built-in `max()` function gives us a clean, one-line solution that ensures the score stays within a valid range.

--- 

#### 2. Show Which Flag Was Wrong

To improve user feedback and reinforce learning, I updated the alert message to include the name of the country whose flag the user actually tapped when they get it wrong.


##### Updated `flagTapped` Logic:

```swift
func flagTapped(_ number: Int) {
    if number == correctAnswer {
        scoreTitle = "Let's goooo! That is correct!"
        userScore += 1
    } else {
        // Used string interpolation to insert the tapped country's name into the message
        scoreTitle = "Wrong! That's the flag of \(countries[number])."
        userScore = max(userScore - 1, 0)
    }
    showingScore = true
}
```

##### Explanation

In the `else` block, I used **string interpolation** — a Swift feature that lets us insert variables directly into a string using `\(…)`.

* `countries[number]` gives us the name of the country that corresponds to the flag the user tapped.

* That value is inserted into the string: `"Wrong! That's the flag of \(countries[number])."`

So if the user taps the France flag instead of Italy, the alert will say:

>  Wrong! That's the flag of France.

##### 🎯 Why This Matters

Adding this dynamic message makes the game more interactive and informative. 

It helps the user associate each flag with its correct country, improving memorization and engagement over time.

---

### 3. Limit to 8 Questions and Show Final Score

To turn the game into a short quiz format, I added logic to track how many rounds have been played and end the game after 8 questions. 

The user then sees a **final score alert** with an option to restart the game.

#### What I Added

```swift
@State private var currentRound = 1
@State private var showingFinalScore = false
let MAX_ROUND = 8
```

#### Updated `flagTapped(_:)` Logic

```swift
func flagTapped(_ number: Int) {
    if number == correctAnswer {
        scoreTitle = "Correct!"
        userScore += 1
    } else {
        scoreTitle = "Wrong! That's the flag of \(countries[number])."
        userScore = max(userScore - 1, 0)
    }

    if currentRound == MAX_ROUND {
        showingFinalScore = true
    } else {
        showingScore = true
    }

    currentRound += 1
}
```

#### Reset Function

```swift
func resetGame() {
    userScore = 0
    currentRound = 1
    askQuestion()
}
```

#### Two Alert Modifiers

> ⚠️ **Note:** SwiftUI only supports **one `.alert` modifier** per view.

> If you try to use two, only the **last one** takes effect.

> To avoid this, you must use **conditional logic inside a single `.alert`** modifier, or manage alert content based on state.

Here’s an example using **two distinct booleans** (not recommended):

```swift
.alert(scoreTitle, isPresented: $showingScore) {
    Button("Continue", action: askQuestion)
} message: {
    Text("Your score is \(userScore)")
}

.alert("Game Over", isPresented: $showingFinalScore) {
    Button("Play Again", action: resetGame)
} message: {
    Text("Your final score was \(userScore) out of \(MAX_ROUND).")
}
```

##### Problem: SwiftUI Doesn’t Support Multiple `.alert` Modifiers

Even though this code compiles, SwiftUI only allows **one active `.alert`** per view.

✅ The **last** modifier (`.alert("Game Over", ...)`) will be used
❌ The first modifier (`.alert(scoreTitle, ...)`) will be **ignored** — even if its condition is `true`.

##### Why This Happens

Alerts are view modifiers in SwiftUI. When they’re applied:

* Only the **last `.alert`** in the view hierarchy is respected.
* All others are silently overridden and **not shown**, no matter the binding.

This causes **unexpected behavior**, especially when you try to show multiple alerts based on different conditions.

##### Real-World Scenario

Imagine this:

1. You're on the **8th and final question**.

2. You tap a flag.

3. `showingFinalScore` becomes `true`, so SwiftUI presents the **“Game Over”** alert.

4. You tap **“Play Again”**, and `resetGame()` is called.

5. Behind the scenes, **`showingScore` is still `true`** (from `flagTapped`), or becomes `true` again after `resetGame()`.

6. As soon as you dismiss the “Game Over” alert, SwiftUI detects that `showingScore` is still `true` and then shows the **first alert**, even though the round is over.

> This creates a strange experience where **a second alert appears immediately after the first**, confusing the user.

##### Solution: Use a Single `.alert` With Conditional Logic

Instead of multiple `.alert` modifiers, use **one unified alert** that shows different content based on the game state.

```swift
.alert(isPresented: Binding(
    get: { showingScore || showingFinalScore },
    set: { _ in
        showingScore = false
        showingFinalScore = false
    }
)) {
    if showingFinalScore {
        return Alert(
            title: Text("Game Over"),
            message: Text("Your final score was \(userScore) out of \(MAX_ROUND)."),
            dismissButton: .default(Text("Play Again"), action: resetGame)
        )
    } else {
        return Alert(
            title: Text(scoreTitle),
            message: Text("Your score is \(userScore)"),
            dismissButton: .default(Text("Continue"), action: askQuestion)
        )
    }
}
```

> This works because the `.alert` modifier always exists — we just **switch its contents** based on the current game state.

#### Why This Matters

Limiting the game to 8 questions introduces a sense of pacing, fairness, and challenge. 

But without proper alert control, it can result in **stacked or ghost alerts**, breaking the user experience.

Using a single `.alert` with conditional content:

* Keeps your UI clean

* Prevents logic bugs

* Makes the app feel polished and professional

---

### Custom 3×3 Grid Layout (Manual)

Instead of using a simple loop to create our flags, we deep-dive into building a **3-by-3 grid** of buttons using plain SwiftUI tools like `VStack`, `HStack`, and `ForEach`.

####  Goal

Render a grid of flags arranged in **3 rows and 3 columns** (9 flags total), where each flag is tappable via the `flagTapped(index:)` function.

####  Manual Grid Structure

We simulate the 3×3 layout using **nested loops**:

```swift
VStack(spacing: 10) {
    ForEach(0..<3) { row in
        HStack(spacing: 10) {
            ForEach(0..<3) { column in
                let index = row * 3 + column
                if index < countries.count {
                    Button {
                        flagTapped(index)
                    } label: {
                        Image(countries[index])
                            .resizable()
                            .frame(width: 100, height: 60)
                            .clipShape(.capsule)
                            .shadow(radius: 5)
                    }
                }
            }
        }
    }
}
```

#### How It Works

| Concept            | Description                                                         |
| ------------------ | ------------------------------------------------------------------- |
| `VStack`           | Stacks 3 horizontal rows vertically.                                |
| `HStack`           | Each row shows 3 flags side-by-side.                                |
| `ForEach` (nested) | Loops over rows and columns to calculate flag index.                |
| `row * 3 + column` | Converts 2D row/col to 1D array index.                              |
| `if index < count` | Prevents out-of-bounds crash when fewer than 9 flags are available. |


#### Index Mapping Example

| Row | Col | Index |
| --- | --- | ----- |
| 0   | 0   | 0     |
| 0   | 1   | 1     |
| 0   | 2   | 2     |
| 1   | 0   | 3     |
| 1   | 1   | 4     |
| ... | ... | ...   |

### Alternative: LazyVGrid (Recommended for iOS 14+)

SwiftUI offers a more scalable and elegant way to build grids using `LazyVGrid`.

#### LazyVGrid Version

```swift
let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
]

LazyVGrid(columns: columns, spacing: 20) {
    ForEach(0..<min(9, countries.count), id: \.self) { index in
        Button {
            flagTapped(index)
        } label: {
            Image(countries[index])
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 60)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
}
```

#### What is `columns` in `LazyVGrid`?

In SwiftUI, when you use a `LazyVGrid`, you need to tell it **how many columns** you want and how those columns should behave. That’s where the `columns` array comes in:

```swift
let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
]
```

##### What This Does

You're creating a layout with **3 equal-width columns**. Each `GridItem(.flexible())` means:

> “Let this column take up *any* space it needs — as long as it's evenly shared with the others.”

So with 3 of these, SwiftUI divides the available width equally across the grid, making a **3-column layout**.


##### Visual Representation

| Column 1      | Column 2      | Column 3      |
| ------------- | ------------- | ------------- |
| `.flexible()` | `.flexible()` | `.flexible()` |

Each column stretches or shrinks depending on screen size, but all 3 stay **equal width**.


##### What Other Options Exist?

You can customize columns with different types of `GridItem`:

| Type                  | Behavior                                              |
| --------------------- | ----------------------------------------------------- |
| `.flexible()`         | Expands to fill space, shares space with others       |
| `.fixed(100)`         | Always 100 points wide                                |
| `.adaptive(minimum:)` | Creates as many columns as will fit (adaptive layout) |

Example:

```swift
let columns = [
    GridItem(.fixed(100)),
    GridItem(.flexible()),
    GridItem(.fixed(100))
]
```

Here, the first and last columns are 100 points wide, and the middle one stretches.


##### When to Use `.flexible()`

Use `.flexible()` when:

* You want all columns to **have equal width**
* You want your layout to **adapt to screen size**
* You’re building a consistent grid like a **3x3 game layout**

###  Why Use `LazyVGrid`?

| Feature           | LazyVGrid                     | Manual HStack+VStack       |
| ----------------- | ----------------------------- | -------------------------- |
| Scalable          | ✅ Easily adapts to any size   | ❌ Needs manual row logic   |
| Cleaner syntax    | ✅ Less nested code            | ❌ More complex             |
| Performance       | ✅ Lazy-loading of rows        | ❌ All loaded up front      |
| Layout management | ✅ Flexible with `.flexible()` | ❌ Manually managed spacing |
| Readability       | ✅ Much clearer                | ❌ Easy to get confused     |

### Summary

* Use **manual layout** to understand how grid positioning works from scratch.

* Use **`LazyVGrid`** when to scale up, reduce code clutter, and support adaptive layout.

---


## Recap

- **Guess the Flag** helps reinforce layout, view hierarchy, and interaction in SwiftUI. 

- By using stacks, spacers, images, and buttons, we built an interactive app with immediate visual feedback — and a clean foundation to build more complex apps.


