# Flashzilla Summary 

---

## Day 86: Project 17, Part One

---

## SwiftUI Gestures

SwiftUI provides a variety of gestures that simplify handling user interactions with views. While `onTapGesture()` is basic and has been covered previously, SwiftUI offers more advanced options and combinations:

### Tap Gestures
- Can specify a `count` for double, triple taps, etc.  
```swift
Text("Hello, World!")
    .onTapGesture(count: 2) { print("Double tapped!") }
````

### Long Press Gestures

* Use `onLongPressGesture()` for long press actions.
* Can customize `minimumDuration` and track gesture state with an `onPressingChanged` closure.

```swift
Text("Hello, World!")
    .onLongPressGesture(minimumDuration: 1) { print("Long pressed!") }
    onPressingChanged: { inProgress in print("In progress: \(inProgress)!") }
```

### Advanced Gestures

* Use `gesture()` modifier with structs like `DragGesture`, `MagnifyGesture`, `RotateGesture`, and `TapGesture`.
* Handle gestures in-flight with `onChanged()` or completion with `onEnded()`.
* Examples:

  * **MagnifyGesture:** Scale a view with pinch.
  * **RotateGesture:** Rotate a view with rotation.

### Gesture Priority & Combination

* Child gestures have priority over parent gestures by default.
* Use `highPriorityGesture()` to give a parent gesture precedence.
* Use `simultaneousGesture()` to trigger multiple gestures at once.

### Gesture Sequencing

* Chain gestures so one triggers only after another succeeds (e.g., drag only after a long press).

```swift
let combined = LongPressGesture().sequenced(before: DragGesture())
Circle()
    .gesture(combined)
```

> Gestures enable fluid and interactive UIs, but always provide visual feedback so users understand how to interact with them.

---

## SwiftUI – Advanced Hit Testing

SwiftUI uses an advanced hit testing system that considers both the **frame** of a view and often its **visible contents**:

- **Text views:** The entire frame is tappable, including spaces.
- **Shape views (e.g., Circle):** Only the visible part is tappable; transparent areas are ignored.

### Example: Overlapping Views
```swift
ZStack {
    Rectangle()
        .fill(.blue)
        .frame(width: 300, height: 300)
        .onTapGesture { print("Rectangle tapped!") }

    Circle()
        .fill(.red)
        .frame(width: 300, height: 300)
        .onTapGesture { print("Circle tapped!") }
}
````

* Tapping the circle prints “Circle tapped!”
* Tapping the rectangle behind prints “Rectangle tapped!”

### Controlling Hit Testing

1. **`allowsHitTesting(_:)`**

* Prevents a view from catching taps.

```swift
Circle()
    .fill(.red)
    .frame(width: 300, height: 300)
    .onTapGesture { print("Circle tapped!") }
    .allowsHitTesting(false)
```

* Taps go through the circle to views behind it.

2. **`contentShape(_:)`**

* Overrides the tappable area of a view.
* Useful for shapes or stacks with spacers.

```swift
VStack {
    Text("Hello")
    Spacer().frame(height: 100)
    Text("World")
}
.contentShape(.rect)
.onTapGesture { print("VStack tapped!") }
```

* Makes the entire stack area, including spacers, tappable.

> Using `allowsHitTesting` and `contentShape` lets you precisely control which areas of your UI respond to user interactions.

---

## Day 86: Project 17, Part Two

---

## SwiftUI – Timers and Timer Publishers

iOS provides a built-in `Timer` class in the **Foundation** framework for running code on a schedule. Combine extends this with **timer publishers** that announce changes over time, which can be used in SwiftUI with `onReceive()`.

### Creating a Timer Publisher

```swift
let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
````

* Fires every 1 second (`every: 1`)
* Runs on the **main thread** (`on: .main`)
* Uses the **common run loop** (`in: .common`)
* Starts immediately (`autoconnect()`)
* Keeps the timer alive by assigning it to a constant

### Receiving Timer Events in SwiftUI

Use `onReceive()` to react to timer updates:

```swift
Text("Hello, World!")
    .onReceive(timer) { time in
        print("The time is now \(time)")
    }
```

* The closure runs each time the timer fires.

### Stopping a Timer

Autoconnected timer publishers must be canceled via their upstream publisher:

```swift
timer.upstream.connect().cancel()
```

Example: stop the timer after 5 ticks:

```swift
struct ContentView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0

    var body: some View {
        Text("Hello, World!")
            .onReceive(timer) { time in
                if counter == 5 {
                    timer.upstream.connect().cancel()
                } else {
                    print("The time is now \(time)")
                }
                counter += 1
            }
    }
}
```

### Timer Tolerance

* `tolerance` allows the system to optimize energy usage by coalescing timers.
* Example: half-second tolerance

```swift
let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
```

* Strict timing can be achieved by leaving out the tolerance.
* Note: Even without tolerance, timers are **best-effort**, not guaranteed to be perfectly precise.

> Timers are useful for repeated actions, animations, or any periodic updates in SwiftUI, but always consider energy efficiency and system scheduling.


---

## SwiftUI – Detecting App Lifecycle with Scene Phase

SwiftUI can detect when your app moves between foreground and background, allowing you to **pause and resume work** depending on whether the user can see your app.

### Steps to Monitor Scene Phase

1. **Add a property to watch the environment value**:

```swift
@Environment(\.scenePhase) var scenePhase
````

2. **Use `onChange()`** to watch for changes:

```swift
.onChange(of: scenePhase) { oldPhase, newPhase in
    // Respond to phase change
}
```

3. **Respond to the new scene phase**:

```swift
struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        Text("Hello, world!")
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    print("Active")
                } else if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .background {
                    print("Background")
                }
            }
    }
}
```

### Scene Phases

* **Active**

  * The scene is running and visible to the user.
  * On iOS, the user can interact with it.
  * On macOS, the window might be behind others but is still considered active.

* **Inactive**

  * The scene is running but the user cannot currently interact with it.
  * Example: partially revealing the Control Center on iOS.

* **Background**

  * The scene is not visible to the user.
  * On iOS, the system may terminate it at some point in the future.

> Monitoring `scenePhase` is essential for managing app state correctly, saving resources, and ensuring seamless user experiences.

---

## SwiftUI – Accessibility Environment Properties

SwiftUI provides **environment properties** that describe a user’s accessibility settings. These automatically update the UI when the user changes their settings.


### Key Accessibility Properties

#### 1. Differentiate Without Color
- Helps users with color blindness by avoiding color-only cues.
- Use the environment property:

```swift
@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
````

* Example: use shapes/icons instead of colors:

```swift
HStack {
    if differentiateWithoutColor {
        Image(systemName: "checkmark.circle")
    }
    Text("Success")
}
.padding()
.background(differentiateWithoutColor ? .black : .green)
.foregroundStyle(.white)
.clipShape(.capsule)
```

#### 2. Reduce Motion

* Limits animations that cause movement.
* Environment property:

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion
```

* Conditionally apply animation:

```swift
Button("Hello, World!") {
    if reduceMotion {
        scale *= 1.5
    } else {
        withAnimation {
            scale *= 1.5
        }
    }
}
.scaleEffect(scale)
```

* **Optional helper function** to simplify animations:

```swift
func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}
```

#### 3. Reduce Transparency

* Minimizes blur and translucency for clarity.
* Environment property:

```swift
@Environment(\.accessibilityReduceTransparency) var reduceTransparency
```

* Example:

```swift
Text("Hello, World!")
    .padding()
    .background(reduceTransparency ? .black : .black.opacity(0.5))
    .foregroundStyle(.white)
    .clipShape(.capsule)
```

> Using these environment properties ensures your app **respects user accessibility preferences**, making it more inclusive and easier to use.

---

## Day 88 – Project 17, part three

---

## SwiftUI – Flashcards App (Card & CardView)

In this project, users see a **flashcard** with a question (prompt). When they tap it, the **answer** is revealed.  

Example:  
- Prompt: *“What is the capital city of Scotland?”*  
- Answer: *“Edinburgh”*  

### Step 1 – Data Model

We begin by defining what a card looks like. Each card has:  
- A **prompt** (the question).  
- An **answer** (the solution).  

We also include a static `example` card for previews.

```swift
struct Card {
    var prompt: String
    var answer: String

    static let example = Card(
        prompt: "Who played the 13th Doctor in Doctor Who?",
        answer: "Jodie Whittaker"
    )
}
````

### Step 2 – Card Layout

Each card is wider than it is tall (like real flashcards).

* A **white rounded rectangle** forms the card background.
* A **VStack** holds the text labels.
* Padding ensures text doesn’t touch the edges.

```swift
struct CardView: View {
    let card: Card
    @State private var isShowingAnswer = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(radius: 10) // adds depth

            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundStyle(.black)

                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250) // fits all iPhones in landscape
        .onTapGesture {
            isShowingAnswer.toggle() // reveal/hide answer
        }
    }
}
```

### Step 3 – Preview

Use the static `example` card to preview:

```swift
#Preview {
    CardView(card: .example)
}
```

### Step 4 – Enforcing Landscape Orientation

Since flashcards are **wider than tall**, the app will run **only in landscape**.

In **Xcode**:

* Go to project **Info tab → Supported interface orientations (iPhone)**.
* Remove **Portrait** so only the **landscape options** remain.

### Step 5 – Display in ContentView

Finally, display a sample card:

```swift
struct ContentView: View {
    var body: some View {
        CardView(card: .example)
    }
}
```

---

## SwiftUI – Flashcard Stack & Background

After creating a single flashcard, the next step is to build a **stack of cards** to represent all the items a user is learning.  

### Step 1 – Card Array

- The card stack will **change dynamically**, so mark it with `@State`.
- For testing, we can create **10 repeated example cards**:

```swift
@State private var cards = Array<Card>(repeating: .example, count: 10)
````

### Step 2 – Layered Layout

* Use **ZStack** for overlapping cards to create a 3D effect.
* Wrap the ZStack in a VStack for future UI elements (like a timer).
* Wrap everything in an outer ZStack to place cards and timer over a background.

### Step 3 – Card Stacking Modifier

* Create a **`stacked()` view modifier** to offset cards slightly based on their position:

```swift
extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}
```

* This offsets each card by 10 points per position, creating a layered effect.

### Step 4 – Display Card Stack

* Use `ForEach` inside the inner ZStack to layout cards:

```swift
var body: some View {
    ZStack {
        VStack {
            ZStack {
                ForEach(0..<cards.count, id: \.self) { index in
                    CardView(card: cards[index])
                        .stacked(at: index, in: cards.count)
                }
            }
        }
    }
}
```

* Running this shows overlapping cards with shadows creating **depth perception**.

### Step 5 – Add Background Image

* To improve visual appeal, add a **full-screen background**:

```swift
Image(.background)
    .resizable()
    .ignoresSafeArea()
```

* Make sure you add `background@2x.jpg` and `background@3x.jpg` to your asset catalog.
* The background works seamlessly behind the card stack, enhancing the overall UI.

---

## SwiftUI – Drag Gestures & Swipe-to-Remove Cards

SwiftUI allows attaching **custom gestures** to any view, letting us manipulate views based on gesture data.  
In this project, we’ll make flashcards **draggable**, **rotate**, **fade**, and be **removed** when swiped far enough.  

### Step 1 – Track Drag Offset

Add a `@State` property to `CardView` to track drag movement:

```swift
@State private var offset = CGSize.zero
````

### Step 2 – Apply Modifiers for Drag Effects

Below the `frame()` modifier in `CardView`, add three modifiers:

1. **Rotation:** rotates based on horizontal drag (divide by 5 for subtlety)

```swift
.rotationEffect(.degrees(offset.width / 5))
```

2. **Offset:** move the card as it is dragged (multiply by 5 for sensitivity)

```swift
.offset(x: offset.width * 5)
```

3. **Opacity:** fade out the card as it moves farther

```swift
.opacity(2 - Double(abs(offset.width / 50)))
```

> ⚠️ Modifier order matters: rotation → offset → opacity for correct visual behavior.

### Step 3 – Attach DragGesture

Add a `gesture()` modifier to update `offset` while dragging:

```swift
.gesture(
    DragGesture()
        .onChanged { gesture in
            offset = gesture.translation
        }
        .onEnded { _ in
            if abs(offset.width) > 100 {
                // remove the card
            } else {
                offset = .zero
            }
        }
)
```

* `onChanged`: updates card position in real-time.
* `onEnded`: checks if the drag exceeds **100 points**, triggering removal.

### Step 4 – Card Removal via Closure

Instead of letting `CardView` directly manipulate `ContentView`’s data, define a **removal closure**:

```swift
var removal: (() -> Void)? = nil
```

* Replace `// remove the card` with:

```swift
removal?()
```

* This calls the closure **only if it’s set**, keeping views decoupled.

### Step 5 – Connect Closure in ContentView

1. Add a method to remove a card from the stack:

```swift
func removeCard(at index: Int) {
    cards.remove(at: index)
}
```

2. Update `ForEach` to pass the closure to `CardView`:

```swift
ForEach(0..<cards.count, id: \.self) { index in
    CardView(card: cards[index]) {
       withAnimation {
           removeCard(at: index)
       }
    }
    .stacked(at: index, in: cards.count)
}
```

* `withAnimation()` ensures remaining cards **slide up smoothly** after removal.

---

## Day 89 – Project 17, part four

---

### Step 1 – Swipe Detection in `CardView`

We track horizontal dragging with a `DragGesture` and measure `offset.width`. Positive = right swipe (correct), negative = left swipe (wrong).

We update the card’s appearance as the gesture moves:

```swift
RoundedRectangle(cornerRadius: 25)
    .fill(
        accessibilityDifferentiateWithoutColor
            ? .white
            : .white
                .opacity(1 - Double(abs(offset.width / 50)))
    )
    .background(
        accessibilityDifferentiateWithoutColor
            ? nil
            : RoundedRectangle(cornerRadius: 25)
                .fill(offset.width > 0 ? .green : .red)
    )
    .shadow(radius: 10)
```

* **Default mode:** card fades from white to green (right) or red (left).
* **Differentiate Without Color mode:** card stays white; no background color.

### Step 2 – Accessibility Handling

Add an environment property to respect system settings:

```swift
@Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
```

This ensures color isn’t the only indicator — we respect accessibility preferences.

### Step 3 – Extra UI for Accessibility in `ContentView`

When `Differentiate Without Color` is enabled, show explicit feedback icons instead of colors:

```swift
if accessibilityDifferentiateWithoutColor {
    VStack {
        Spacer()
        HStack {
            Image(systemName: "xmark.circle")
                .padding()
                .background(.black.opacity(0.7))
                .clipShape(.circle)
            Spacer()
            Image(systemName: "checkmark.circle")
                .padding()
                .background(.black.opacity(0.7))
                .clipShape(.circle)
        }
        .foregroundStyle(.white)
        .font(.largeTitle)
        .padding()
    }
}
```

* Icons are positioned at the bottom, clearly indicating “wrong” (left) and “correct” (right) swipes.
* Only shown when accessibility mode is on.

### Step 4 – Swipe Closure for Guess Handling

Just like the removal closure, define a **guess closure** in `CardView`:

```swift
var onSwipe: ((_ correct: Bool) -> Void)? = nil
```

Call it when the gesture ends:

```swift
if offset.width > 100 {
    onSwipe?(true)   // right swipe = correct
} else if offset.width < -100 {
    onSwipe?(false)  // left swipe = wrong
}
```

Then in `ContentView`, pass in the closure to handle updating the game state:

```swift
CardView(card: cards[index]) { correct in
    withAnimation {
        removeCard(at: index)
        if correct {
            score += 1
        } else {
            strikes += 1
        }
    }
}
```

Key idea: `CardView` only signals **“swiped right/left”**, but `ContentView` decides what happens (removal, score, etc.), keeping views decoupled and accessible.

---

### Step 1 – Timer Properties in `ContentView`

We need a timer that fires every second and a state variable to track remaining time:

```swift
@State private var timeRemaining = 100
let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
```

* `timeRemaining` starts at 100 seconds.
* `timer` fires every second on the main thread.

### Step 2 – Countdown Logic

Whenever the timer fires, subtract 1 from `timeRemaining`:

```swift
.onReceive(timer) { _ in
    if timeRemaining > 0 {
        timeRemaining -= 1
    }
}
```

* The check ensures the timer never goes below zero.
* This is the “core closure” of the timer: it’s triggered every second by Combine.

### Step 3 – Display the Timer

Show the countdown in the UI:

```swift
Text("Time: \(timeRemaining)")
    .font(.largeTitle)
    .foregroundStyle(.white)
    .padding(.horizontal, 20)
    .padding(.vertical, 5)
    .background(.black.opacity(0.75))
    .clipShape(.capsule)
```

* Placed inside the `VStack` above the cards.
* Clearly visible with a dark translucent background.

### Step 4 – Handle App Background / Foreground

The naive timer counts down even when the app is in the background, causing it to jump. To fix this, track scene phase:

```swift
@Environment(\.scenePhase) var scenePhase
@State private var isActive = true
```

* `scenePhase` tracks whether the app is active or inactive.
* `isActive` combines scene phase with game state (e.g., all cards used).

### Step 5 – Pause / Resume Timer

Detect scene changes and update `isActive`:

```swift
.onChange(of: scenePhase) { _ in
    if scenePhase == .active {
        isActive = true
    } else {
        isActive = false
    }
}
```

Modify the timer’s closure to respect `isActive`:

```swift
.onReceive(timer) { _ in
    guard isActive else { return }

    if timeRemaining > 0 {
        timeRemaining -= 1
    }
}
```

* If `isActive` is `false`, the timer does nothing — it effectively pauses.
* When the app comes back to the foreground, the timer resumes correctly.

---

### Step 1 – Disable Interactivity When Time Runs Out

Use SwiftUI’s `.allowsHitTesting()` modifier on the innermost `ZStack` that holds your card stack:

```swift
.allowsHitTesting(timeRemaining > 0)
```

* Cards respond to gestures **only if** `timeRemaining` is greater than 0.
* When time runs out, all swiping and tapping on the cards is automatically disabled.

### Step 2 – Reset Method for Cards and Timer

Create a method to reset the game:

```swift
func resetCards() {
    cards = Array<Card>(repeating: .example, count: 10)
    timeRemaining = 100
    isActive = true
}
```

* Resets `cards` to the full deck.
* Resets the timer to 100 seconds.
* Sets `isActive` to true so the timer starts again.

### Step 3 – Show Reset Button Only When Cards Are Gone

Add a button **after the card stack** to allow restarting the game:

```swift
if cards.isEmpty {
    Button("Start Again", action: resetCards)
        .padding()
        .background(.white)
        .foregroundStyle(.black)
        .clipShape(.capsule)
}
```

* Only visible when `cards.isEmpty == true`.
* Tapping the button calls `resetCards()`.

### Step 4 – Stop Timer When Cards Are Gone

Update your `removeCard(at:)` method to stop the timer if the last card is removed:

```swift
func removeCard(at index: Int) {
    cards.remove(at: index)
    
    if cards.isEmpty {
        isActive = false
    }
}
```

* Ensures the timer stops immediately when all cards are gone.

### Step 5 – Maintain Timer Stop Across Background/Foreground

Update the scene phase handler to respect empty cards:

```swift
.onChange(of: scenePhase) {
    if scenePhase == .active {
        if !cards.isEmpty {
            isActive = true
        }
    } else {
        isActive = false
    }
}
```

* If the app goes to the background, `isActive` becomes false.
* When returning to the foreground, `isActive` only resumes if there are still cards left.
* Prevents the timer from running again after the deck is empty.

---

## Day 90 – Project 17, part five

---

### Step 1 – Only Top Card Is Draggable

Use `allowsHitTesting()` on each card so that only the top card responds to gestures:

```swift
.allowsHitTesting(index == cards.count - 1)
```

* Prevents dragging cards that are underneath others.
* Keeps interactions predictable for the user.

### Step 2 – Hide Non-Top Cards From Accessibility

Use `accessibilityHidden()` so VoiceOver ignores cards that aren’t on top:

```swift
.accessibilityHidden(index < cards.count - 1)
```

* Only the visible, top card is part of the accessibility tree.
* Avoids VoiceOver reading out irrelevant cards.


### Step 3 – Mark Background Image as Decorative

Prevent VoiceOver from announcing the background image:

```swift
Image(decorative: "background")
```

* The background no longer creates extra accessibility elements.


### Step 4 – Make Cards Recognizable as Buttons

Add traits to indicate tappable cards:

```swift
.accessibilityAddTraits(.isButton)
```

* VoiceOver announces cards as “Button,” helping users understand interaction.


### Step 5 – Show Prompt or Answer for VoiceOver

Detect if VoiceOver is running:

```swift
@Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
```

Then adjust the `VStack` for prompt/answer:

```swift
VStack {
    if accessibilityVoiceOverEnabled {
        Text(isShowingAnswer ? card.answer : card.prompt)
            .font(.largeTitle)
            .foregroundStyle(.black)
    } else {
        Text(card.prompt)
            .font(.largeTitle)
            .foregroundStyle(.black)

        if isShowingAnswer {
            Text(card.answer)
                .font(.title)
                .foregroundStyle(.secondary)
        }
    }
}
```

* Automatically toggles between prompt and answer so VoiceOver reads it immediately.
* Non-VoiceOver users still see both as before.


### Step 6 – Replace Image Controls with Buttons

For marking cards correct or wrong, use buttons with accessibility labels:

```swift
HStack {
    Button {
        withAnimation {
            removeCard(at: cards.count - 1)
        }
    } label: {
        Image(systemName: "xmark.circle")
            .padding()
            .background(.black.opacity(0.7))
            .clipShape(.circle)
    }
    .accessibilityLabel("Wrong")
    .accessibilityHint("Mark your answer as being incorrect.")

    Spacer()

    Button {
        withAnimation {
            removeCard(at: cards.count - 1)
        }
    } label: {
        Image(systemName: "checkmark.circle")
            .padding()
            .background(.black.opacity(0.7))
            .clipShape(.circle)
    }
    .accessibilityLabel("Correct")
    .accessibilityHint("Mark your answer as being correct.")
}
```

* Removes top card from the deck.
* Provides clear guidance for VoiceOver users.
* Adds a guard in `removeCard(at:)` to prevent removing non-existent cards:

```swift
guard index >= 0 else { return }
```

### Step 7 – Conditional Visibility of Buttons

Show the buttons only when accessibility features are enabled:

```swift
if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
    // show buttons
}
```

* Ensures the UI remains clean for most users, but accessible to everyone who needs extra cues.

### Step 8 – Smooth Spring Animation on Card Release

Prevent abrupt jumps when cards snap back to the center:

```swift
.animation(.bouncy, value: offset)
```

* Adds a springy motion when releasing a partially dragged card.
* Provides clear visual feedback about card state.

---

### Step 1 – Track When the Edit Screen Is Visible

Add a state property to control sheet presentation:

```swift
@State private var showingEditScreen = false
```

* `true` → the edit sheet is shown
* `false` → the edit sheet is hidden

### Step 2 – Add Button to Show Edit Screen

Place a button in a `VStack`/`HStack` to flip the Boolean:

```swift
Button {
    showingEditScreen = true
} label: {
    Image(systemName: "plus.circle")
        .padding()
        .background(.black.opacity(0.7))
        .clipShape(.circle)
}
```

* Tapping the button triggers the sheet to appear.
* You can put it alongside accessibility buttons as needed.

### Step 3 – Make `Card` Codable

To persist user-added cards, make the `Card` struct conform to `Codable`:

```swift
struct Card: Codable {
    let prompt: String
    let answer: String
}
```

* Enables encoding/decoding to/from `UserDefaults`.

### Step 4 – Build the `EditCards` View

Create a new SwiftUI view `EditCards`:

* Has its own `@State private var cards` array.
* Wrapped in a `NavigationStack` for a “Done” button.
* Shows a `List` of existing cards.
* Adds a section at the top to enter a new prompt and answer.
* Supports swipe-to-delete for cards.
* Loads and saves data from `UserDefaults`.

**Core structure:**

```swift
struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                }

                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar { Button("Done", action: done) }
            .onAppear(perform: loadData)
        }
    }

    func done() { dismiss() }
    func loadData() { /* decode from UserDefaults */ }
    func saveData() { /* encode to UserDefaults */ }
    func addCard() { /* insert new card and save */ }
    func removeCards(at offsets: IndexSet) { /* remove and save */ }
}
```

### Step 5 – Show Sheet From `ContentView`

Attach a `.sheet()` modifier to show `EditCards`:

```swift
.sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
    EditCards()
}
```

* Calls `resetCards()` when the sheet is dismissed.
* Alternative shorthand using the initializer directly:

```swift
.sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
```

* Works because `EditCards` has a default initializer with no parameters.

### Step 6 – Reset Cards and Load Saved Data

Modify `resetCards()` to fetch saved cards and reset the timer:

```swift
func resetCards() {
    timeRemaining = 100
    isActive = true
    loadData()        
}
```

* `loadData()` decodes `[Card]` from `UserDefaults` and updates `cards`.
* Ensures the app shows the latest user-saved cards.

### Step 7 – Initialize Cards Array in `ContentView`

Instead of fixed sample cards, start with an empty array:

```swift
@State private var cards = [Card]()
```

* The deck is dynamically populated from saved user data.

### Key Ideas:

1. **Closure/Sheet Flow:**

   * Button toggles Boolean → SwiftUI triggers sheet → sheet shows `EditCards`.
   * `onDismiss` closure calls `resetCards()` to refresh the main view.

2. **Persistence:**

   * Cards are `Codable` → encode/decode with `JSONEncoder`/`JSONDecoder`.
   * `UserDefaults` stores data between app launches.

3. **Dynamic Deck:**

   * Users can add new cards, delete cards, and see changes immediately.
   * Main view reflects edits when the sheet is dismissed.

4. **Decoupled Design:**

   * `ContentView` handles deck/timer logic.
   * `EditCards` only manages card editing and persistence.

---

## Day 91 – Project 17, part six

---

## Challenge

### Challenge 1

When adding a card, the text fields keep their current text. Fix that so that the textfields clear themselves after a card is added.

```swift
func addCard() {
    let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
    let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
    guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }

    let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
    cards.insert(card, at: 0)
    saveData()
    newPrompt = ""
    newAnswer = "" 
}
````

### Challenge 2

If you drag a card to the right but not far enough to remove it, then release, you see it turn red as it slides back to the center.


- This happens because we reset the `offset` back to `.zero` immediately, but the card’s animation hasn’t completed yet. While it’s animating back to the center, SwiftUI still evaluates the background color logic — which 
uses the sign of `offset.width` (positive = green, negative = red). If your drag was to the right, `offset.width` becomes slightly negative during the animation back, causing the red flash.

- The fix is to separate the **visual background logic** into a custom helper instead of nesting shapes inside `.fill()`. That way, the card’s background is always evaluated consistently while animating.

- Here’s the fix:

```swift
extension View {
    func cardBackground(for offset: CGSize, differentiateWithoutColor: Bool) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : (offset == .zero
                       ? .white
                       : (offset.width > 0 ? .green : .red))
                )
        )
    }
}
```

Then apply it inside `CardView`:

```swift
RoundedRectangle(cornerRadius: 25)
    .fill(
        accessibilityDifferentiateWithoutColor
        ? .white
        : .white.opacity(1 - Double(abs(offset.width / 50)))
    )
    .cardBackground(for: offset, differentiateWithoutColor: accessibilityDifferentiateWithoutColor)
    .shadow(radius: 10)
```

Now dragging right keeps the card green, dragging left keeps it red, and returning to center cleanly fades it back to white without flickering.


### Challenge 3

For a harder challenge: when the user gets an answer wrong, add that card back into the array so the user can try it again. Doing this successfully means rethinking the `ForEach` loop, because relying on simple integers isn’t enough – your cards need to be uniquely identifiable.

**Step 1 – Update the Card model**

```swift
struct Card: Codable, Identifiable, Equatable {
    var id = UUID()
    var prompt: String
    var answer: String

    static let example = Card(
        prompt: "Who played the 13th Doctor in Doctor Who?", 
        answer: "Jodie Whittaker"
    )
}
```

* `Identifiable` → allows SwiftUI `ForEach` to track each card individually.
* `Equatable` → lets us find a card’s index to remove or re-add it.


**Step 2 – Update the removal logic in `ContentView`**

```swift
func removeCard(_ card: Card, wrongAnswer: Bool = false) {
    guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
    let removedCard = cards.remove(at: index)

    if wrongAnswer {
        // Re-add a fresh card (new instance) to reset its offset
        var newCard = removedCard
        newCard.id = UUID() // ensure SwiftUI treats it as a new view
        cards.insert(newCard, at: 0) // add at the beginning
    }

    if cards.isEmpty {
        isActive = false
    }
}
```

* Swiping left marks a card as wrong.
* A new `UUID()` ensures SwiftUI sees it as a new card.
* `insert(at: 0)` adds it back at the **top of the deck**, letting the user retry immediately.

**Step 3 – ForEach update**

```swift
ZStack {
    ForEach(cards) { card in
        let cardIndex = index(of: card)
        let isTopCard = card == cards.last

        CardView(card: card) { wrongAnswer in
            withAnimation {
                removeCard(card, wrongAnswer: wrongAnswer)
            }
        }
        .stacked(at: cardIndex, in: cards.count)
        .allowsHitTesting(isTopCard)
        .accessibilityHidden(!isTopCard)
    }
}
```

* Using `Identifiable` ensures each card is uniquely tracked.
* Only the top card allows gestures and is visible to VoiceOver.

Got it! Here’s the **Challenge 3 section rewritten in the same style with just the changes and code**:


**Step 3 – CardView closure signature** 

Updated to pass whether the swipe was wrong:

```swift
struct CardView: View {
    let card: Card
    var removal: ((Bool) -> Void)? = nil // true = wrong, false = correct
```

3. **Gesture handling** now detects left swipe as wrong:

```swift
.gesture(
    DragGesture()
        .onChanged { gesture in
            offset = gesture.translation
        }
        .onEnded { _ in
            if abs(offset.width) > 100 {
                let isWrong = offset.width < 0
                removal?(isWrong)
            } else {
                offset = .zero
            }
        }
)
```

This ensures:

* Swiping **right** removes the card permanently.
* Swiping **left** removes the card but adds it back at the **front** for retry.
* Each re-added card is treated as a new view so animations and offsets reset correctly.

---

### Challenge 4:  Data Persistence Challenge: UserDefaults, JSON, and SwiftData

Make it use an alternative approach to saving data, e.g. documents JSON rather than UserDefaults, or SwiftData – this is generally a good idea, so you should get practice with this.


#### JSON File Challenge – Using Documents Directory for Data Persistence

**Goal:** Replace `UserDefaults` with JSON-based storage in the app’s Documents directory. This ensures more robust and scalable storage and gives you practice with file-based persistence.

**1. FileManager Extension (for JSON)**

```swift
extension FileManager {
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func save<T: Encodable>(_ object: T, to filename: String) {
        let url = documentsDirectory.appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
            print("Saved to \(url)")
        } catch {
            print("Failed to save JSON:", error)
        }
    }
    
    static func load<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        let url = documentsDirectory.appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            print("Failed to load JSON:", error)
            return nil
        }
    }
}
```

**2. CardStorage Model**

```swift
struct CardStorage {
    static let filename = "cards.json"

    static let sampleCards: [Card] = [
        // your sample cards here...
    ]

    static func load() -> [Card] {
        if let saved = FileManager.load(filename, as: [Card].self) {
            return saved
        } else {
            save(sampleCards)
            return sampleCards
        }
    }

    static func save(_ cards: [Card]) {
        FileManager.save(cards, to: filename)
    }

    static func loadData() -> [Card] { load() }
    static func saveData(_ cards: [Card]) { save(cards) }
}
```

**3. ContentView – Reset Cards**

```swift
func resetCards() {
    timeRemaining = 100
    isActive = true
    
    // Load cards from storage
    let loaded = CardStorage.loadData()
    
    // Fall back to sampleCards if nothing was loaded
    cards = loaded.isEmpty ? CardStorage.sampleCards : loaded
}
```

**4. EditCardsView – Load Cards on Appear**

```swift
.onAppear {
    let loaded = CardStorage.loadData()
    // Fall back to sampleCards if nothing was loaded
    cards = loaded.isEmpty ? CardStorage.sampleCards : loaded
}
```

**Key Points:**

* This ensures the app never shows an empty state on first launch.
* The JSON file acts as the single source of truth for both `ContentView` and `EditCardsView`.
* Using the Documents directory keeps data persistent between app launches, unlike `UserDefaults` which is less flexible for larger or structured datasets.

---

#### SwiftData Challenge

In this challenge, we moved Flashzilla from using JSON files or `UserDefaults` to **SwiftData**, enabling fully persistent storage with real-time UI updates.


**1. CardEntity Model**

```swift
import SwiftData
import SwiftUI

@Model
final class CardEntity {
    @Attribute(.unique) var id: UUID
    var prompt: String
    var answer: String

    init(prompt: String, answer: String, id: UUID = UUID()) {
        self.id = id
        self.prompt = prompt
        self.answer = answer
    }
}
````

**2. Loading Sample Data**

```swift
import Foundation
import SwiftData

func loadSampleDataIfNeeded(context: ModelContext) {
    do {
        // Check if there are any cards already stored
        let request = FetchDescriptor<CardEntity>()
        let existingCards = try context.fetch(request)
        
        guard existingCards.isEmpty else { return } // Already populated
        
        // Insert sample cards
        for item in CardStorage.sampleCards {
            let card = CardEntity(prompt: item.prompt, answer: item.answer)
            context.insert(card)
        }
        
        try context.save() // Persist to disk
        print("Sample cards saved to SwiftData")
    } catch {
        print("Failed to fetch or save sample cards:", error)
    }
}
```

**3. App Setup**

```swift
import SwiftUI
import SwiftData

@main
struct FlashzillaApp: App {
    @Environment(\.modelContext) private var context

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [CardEntity.self])
                .onAppear {
                   loadSampleDataIfNeeded(context: context)
                }
        }
    }
}
```

**4. Using SwiftData in `ContentView`**

```swift
@Environment(\.modelContext) private var context
@Query(sort: \CardEntity.prompt) private var cardEntities: [CardEntity]

```

**Load cards into UI**

```swift
if cardEntities.isEmpty {
    cards = CardStorage.sampleCards
} else {
    cards = cardEntities.map { Card(id: $0.id, prompt: $0.prompt, answer: $0.answer) }
}
```

**Removing a card**

```swift
if let entity = cardEntities.first(where: { $0.id == card.id }) {
    context.delete(entity)
    do {
        try context.save()
    } catch {
        print("Failed to save context after removing card:", error)
    }
}
        
```

**5. Using SwiftData in `EditCardsView`**

```swift
@Environment(\.modelContext) private var context
@Query(sort: \CardEntity.prompt) private var cardEntities: [CardEntity]

```

```swift
func addCard() {
    let cardEntity = CardEntity(prompt: trimmedPrompt, answer: trimmedAnswer)
    context.insert(cardEntity)
    do {
        try context.save()
        newPrompt = ""
        newAnswer = ""
    } catch {
        print("Failed to save card:", error)
    }
}
```

```swift
func removeCards(at offsets: IndexSet) {
    for index in offsets {
        let entity = cardEntities[index]
        context.delete(entity)
    }
    do {
        try context.save()
    } catch {
        print("Failed to delete card:", error)
    }
}
```

- In this challenge, we explored **three approaches to storing and managing data** in SwiftUI: `UserDefaults`, `JSON + FileManager`, and `SwiftData`.

### 1️⃣ UserDefaults

* Simple key-value storage built into iOS.
* Best for small datasets or user preferences.
* Quick read/write operations, but not ideal for large or relational data.

### 2️⃣ JSON + FileManager

* Store data as JSON files in the app’s documents directory.
* Provides full control and easy inspection or backup.
* Suitable for medium-sized datasets and allows structured storage outside of the app bundle.


### 3️⃣ SwiftData

* Modern, Swift-native persistence solution, designed for SwiftUI.
* Handles large datasets, relationships, and queries efficiently.
* Uses declarative data modeling with `@Model`, `@Query`, and `ModelContext` for adding, updating, and deleting entities.
* Ideal for fully persistent, scalable, and relational data management.


✅ **Key takeaways**:

* **UserDefaults** → fast and easy, best for small datasets.
* **JSON + FileManager** → flexible, inspectable, good for medium datasets.
* **SwiftData** → scalable, relational, fully persistent, and integrated with SwiftUI.


### Challenge 5 - Centralized Card Storage

Try to find a way to centralize the loading and saving code for the cards. You might need to experiment a little to find something you like!


- To avoid repeating loading and saving logic across the app, all card persistence is centralized in one place. This includes:

* ** `CardStorage`**: Provides a single source of truth for all cards, including sample data, and functions to load and save them. This can be used for both JSON file storage and SwiftData.
* ** `FileManager+Documents`**: Handles reading and writing JSON files in the app’s documents directory. This keeps file-handling code separate from your UI logic.
* ** `loadSampleDataIfNeeded`**: Ensures SwiftData has initial sample cards when the app first launches.

Benefits:

* **Reusable code**: Views just call `CardStorage.loadData()` or `CardStorage.saveData(cards)` without knowing the details of the persistence mechanism.
* **Flexibility**: Switching between JSON file storage and SwiftData is easy, because the central storage logic handles both.
* **Clean UI code**: Your views (`ContentView`, `EditCardsView`) only handle displaying and updating cards; all persistence is abstracted.

This centralization makes the app easier to maintain and extend in the future.

