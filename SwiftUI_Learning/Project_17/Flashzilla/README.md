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
