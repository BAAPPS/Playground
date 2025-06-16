#  Animations Summary

---

## Day 32 – Project 6, part one

---

## Implicit Animations in SwiftUI

SwiftUI makes animations incredibly simple with *implicit animations*. Instead of manually defining every frame, you declare how your views should respond when they change, and SwiftUI handles the smooth transitions automatically.


## Example Overview

We start with a red circular button that scales up every time it’s tapped:

```swift
@State private var animationAmount = 1.0

Button("Tap Me") {
    animationAmount += 1
}
.padding(50)
.background(.red)
.foregroundStyle(.white)
.clipShape(.circle)
.scaleEffect(animationAmount)
.animation(.default, value: animationAmount)
````

Adding `.animation()` causes SwiftUI to automatically animate any property changes, such as the scale. 

We can also add a blur effect that increases with the scale:

```swift
.blur(radius: (animationAmount - 1) * 3)
```

```swift
struct ContentView: View {
    @State private var animationAmount = 1.0

    var body: some View {
        Button("Tap Me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .scaleEffect(animationAmount)
        .blur(radius: (animationAmount - 1) * 3)
        .animation(.default, value: animationAmount)
    }
}

```

## Recap

* Implicit animations tie directly to state changes — no need to manually specify animation frames.
* Multiple animatable properties on a view animate together smoothly.
* This declarative approach simplifies adding polished motion to your apps.

---


## Customizing Animations in SwiftUI

When you attach the `.animation()` modifier to a view, SwiftUI automatically animates changes to that view using a default spring animation — a smooth, natural motion that eases in, overshoots slightly, then settles into place.


### What You'll Learn

- How to control animation types (`.linear`, `.spring`, `.easeInOut`, etc.)
- Customizing animation duration, delay, and bounce behavior
- Using `.repeatCount()` and `.repeatForever()` for repeated animations
- Combining animations with view lifecycle events like `onAppear()`
- Creating overlay animations for advanced effects


### Animation Types and Customization

- **Default spring:** Starts slow, speeds up, overshoots, then settles  
- **Linear:** Constant speed animation  
- **Spring with bounce:** Control bounce intensity and duration  
- **EaseInOut:** Smooth acceleration and deceleration with customizable duration and delay

Example of a spring animation with bounce:

```swift
.animation(.spring(duration: 1, bounce: 0.9), value: animationAmount)
````

Example of an ease-in-out animation with delay:

```swift
.animation(
    .easeInOut(duration: 2)
        .delay(1),
    value: animationAmount
)
```

### Repeating Animations

You can repeat animations a fixed number of times or indefinitely:

* Repeat 3 times with autoreversing (bounces back and forth):

```swift
.animation(
    .easeInOut(duration: 1)
        .repeatCount(3, autoreverses: true),
    value: animationAmount
)
```

* Repeat forever without reversing:

```swift
.animation(
    .easeInOut(duration: 1)
        .repeatForever(autoreverses: false),
    value: animationAmount
)
```


### Continuous Animation Example: Pulsating Overlay

By combining `overlay()` with `repeatForever()` and `onAppear()`, you can create continuous animations like a pulsating circle around a button:

```swift
Button("Tap Me") {
    // No action needed
}
.padding(50)
.background(.red)
.foregroundStyle(.white)
.clipShape(.circle)
.overlay(
    Circle()
        .stroke(.red)
        .scaleEffect(animationAmount)
        .opacity(2 - animationAmount)
        .animation(
            .easeInOut(duration: 1)
                .repeatForever(autoreverses: false),
            value: animationAmount
        )
)
.onAppear {
    animationAmount = 2
}
```

---

## Animating Bindings in SwiftUI

SwiftUI's `animation()` modifier isn’t just for views — it can be applied directly to bindings. This allows you to animate changes in state values like `Double`, `Int`, and even `Bool`, even if they don’t seem inherently animatable.


### What You'll Learn

- How to animate values using bindings, not just views
- How SwiftUI animates changes based on before/after view states
- Differences between implicit view-based animation and binding-based animation
- How to apply custom animation styles to bindings


### Example: Binding Animation with a Stepper

SwiftUI lets you attach animations directly to bindings using `.animation()`. Here’s an example:

```swift
@State private var animationAmount = 1.0

var body: some View {
    VStack {
        Stepper("Scale amount", value: $animationAmount.animation(), in: 1...10)

        Spacer()

        Button("Tap Me") {
            animationAmount += 1
        }
        .padding(40)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .scaleEffect(animationAmount)
    }
}
````

* The `Stepper` smoothly animates size changes thanks to the animated binding.
* The `Button`, by contrast, updates the state instantly, so changes appear abrupt.

### Under the Hood: How Binding Animations Work

By attaching `.animation()` to the binding:

```swift
$animationAmount.animation()
```

SwiftUI watches the **before and after state** of your view, then animates the transition accordingly — even if you're updating something like a `Bool`.

To demonstrate this behavior, try adding a `print(animationAmount)` call at the start of your view:

```swift
var body: some View {
    print(animationAmount)
    return VStack {
        ...
    }
}
```

You’ll see discrete values printed (e.g., `2.0`, `3.0`), but the **UI animates smoothly** between those steps.


### Customizing Binding Animations

You can provide your own animation styles directly within the binding:

```swift
Stepper("Scale amount", value: $animationAmount.animation(
    .easeInOut(duration: 1)
        .repeatCount(3, autoreverses: true)
), in: 1...10)
```

With this approach, you don’t need to specify a `value:` to watch — the animation is bound directly to the property itself.

---

## Recap: Two Sides of SwiftUI Animation

| Approach                    | Description                                                                                                           |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| **Implicit View Animation** | Attach `.animation()` to a view, then animate via state changes. The view knows it should animate; the state doesn’t. |
| **Binding Animation**       | Attach `.animation()` to a state binding. The state knows it should animate; the view doesn’t.                        |

Both are valid and powerful, depending on how you want to structure your animation logic.

Binding animations unlock a new level of control in SwiftUI. 

They allow you to animate interactions more directly and declaratively — especially useful for form inputs, steppers, sliders, toggles, and any UI component driven by data bindings.

---

## Explicit Animations in SwiftUI with `withAnimation()`

In addition to view-based and binding-based animations, SwiftUI also supports **explicit animations**. 

This gives you the power to animate any kind of state change — even ones not tied to a view or binding — by explicitly telling SwiftUI when to animate.


### What Are Explicit Animations?

Unlike implicit animations (where a view or binding animates automatically), explicit animations are triggered programmatically using the `withAnimation()` function.

This tells SwiftUI: *“Animate any view changes that result from this state change.”*

### Example: 3D Button Rotation

Let’s see how `withAnimation()` works by making a button rotate in 3D every time it’s tapped.

#### Full Example:

```swift
struct ContentView: View {
    @State private var animationAmount = 0.0

    var body: some View {
        Button("Tap Me") {
            withAnimation {
                animationAmount += 360
            }
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .rotation3DEffect(
            .degrees(animationAmount),
            axis: (x: 0, y: 1, z: 0) // Y-axis rotation
        )
    }
}
````

##### Breakdown:

* `@State private var animationAmount = 0.0` – a simple `Double` to track rotation in degrees.
* `.rotation3DEffect()` – applies a 3D transform around a specified axis (X, Y, or Z).
* `withAnimation { ... }` – explicitly tells SwiftUI to animate any changes inside the block.


### Customizing the Animation

You can pass a custom animation to `withAnimation()` to change how the transition behaves:

```swift
withAnimation(.spring(duration: 1, bounce: 0.5)) {
    animationAmount += 360
}
```

* `.spring()` – simulates a physical spring with duration and bounciness.
* You can use any SwiftUI animation type here: `.easeInOut`, `.linear`, `.easeOut`, etc.


### Axis Options

The `rotation3DEffect()` modifier uses a 3D axis, specified as:

```swift
axis: (x: Double, y: Double, z: Double)
```

| Axis | Effect                              |
| ---- | ----------------------------------- |
| x: 1 | Spins forward/back (flip)           |
| y: 1 | Spins left/right (like a turntable) |
| z: 1 | Rotates flat like a clock           |

You can combine axes for diagonal or complex rotations:

```swift
axis: (x: 1, y: 1, z: 0) // Diagonal spin
```

---

## Recap: Three Animation Techniques in SwiftUI

| Technique                    | Trigger                              | Typical Use Case                          |
| ---------------------------- | ------------------------------------ | ----------------------------------------- |
| View-based `.animation()`    | Attach to a view + watch state       | Animating view properties on change       |
| Binding-based `.animation()` | Attach to a state binding            | Animate form controls or sliders          |
| `withAnimation()`            | Wrap a state change programmatically | Fine-grained control over arbitrary logic |


Explicit animations are powerful because they **decouple the animation trigger from the UI view hierarchy**, giving you full control over *when* and *how* things animate. 

Use them when you need precision, or when the animation should be driven by logic instead of user interaction alone.

---

## Day 33 – Project 6, part two

---

## Understanding Modifier Order and Multiple Animations in SwiftUI

SwiftUI lets us animate view changes with incredible flexibility, but to make the most of it, you need to understand two core ideas:

1. **Modifier order matters.**
2. **The `.animation()` modifier applies only to the view changes that come *before* it.**

Combining these two concepts unlocks powerful techniques for finely controlling how your UI behaves.

### Concept 1: Modifier Order Matters

In SwiftUI, each modifier *wraps* the view that came before it. That means the order you apply them changes the outcome.

#### Example:

```swift
Button("Tap Me") { }
.background(.blue)
.frame(width: 200, height: 200)
````

In this case, only the original button size is blue.

```swift
Button("Tap Me") { }
.frame(width: 200, height: 200)
.background(.blue)
```

Now, the entire 200×200 area is blue. This illustrates why modifier order matters in SwiftUI.

### 🧠 Concept 2: View Changes Animate with `.animation()`

You can attach `.animation()` to a view to implicitly animate any changes to its properties that occur *before* the modifier.

#### Example:

```swift
@State private var enabled = false

Button("Tap Me") {
    enabled.toggle()
}
.background(enabled ? .blue : .red)
.animation(.default, value: enabled)
```

This animates the background color smoothly between red and blue.

### What Happens with Shape Changes?

Now let’s say you want to change the shape of the button:

```swift
.clipShape(.rect(cornerRadius: enabled ? 60 : 0))
```

If this comes *after* the `.animation()` modifier, it won’t animate.

```swift
// ❌ This doesn't animate the shape
.clipShape(.rect(cornerRadius: enabled ? 60 : 0))
.animation(.default, value: enabled)
```

Instead, move the `.clipShape()` before `.animation()`:

```swift
// ✅ Now both color and shape animate
.clipShape(.rect(cornerRadius: enabled ? 60 : 0))
.animation(.default, value: enabled)
```

Only changes **before** `.animation()` get animated!

### 🧪 Multiple `.animation()` Modifiers

Yes, you can apply `.animation()` multiple times — each one applies only to the modifiers above it.

#### Example: Split Animations

```swift
Button("Tap Me") {
    enabled.toggle()
}
.frame(width: 200, height: 200)
.background(enabled ? .blue : .red)
.animation(.default, value: enabled)
.foregroundStyle(.white)
.clipShape(.rect(cornerRadius: enabled ? 60 : 0))
.animation(.spring(duration: 1, bounce: 0.6), value: enabled)
```

This produces:

* A **color fade** using the default animation
* A **shape morph** using a springy bounce

---

### Disabling Animations Selectively

Want to animate the shape but not the color? Use `.animation(nil, value:)` to cancel animation for specific changes:

```swift
Button("Tap Me") {
    enabled.toggle()
}
.frame(width: 200, height: 200)
.background(enabled ? .blue : .red)
.animation(nil, value: enabled) // disable color animation
.foregroundStyle(.white)
.clipShape(.rect(cornerRadius: enabled ? 60 : 0))
.animation(.spring(duration: 1, bounce: 0.6), value: enabled)
```

This gives you granular control over what animates and what doesn't.

### Recap

| Concept                       | Description                                                            |
| ----------------------------- | ---------------------------------------------------------------------- |
| Modifier Order                | Modifiers wrap the view; their order changes layout and appearance.    |
| `.animation()` Scope          | Animates only the changes that occur *before* it's applied.            |
| Multiple `.animation()` Calls | Each controls only its preceding view changes.                         |
| Disable Animation Selectively | Use `.animation(nil, value:)` to skip animations for specific changes. |


### Final Thoughts

Understanding the **scope of each animation** and how **modifier order shapes your UI** will help you create polished, interactive, and intentional animations in SwiftUI. Don’t be afraid to use multiple `.animation()` 
modifiers — they’re designed for it.

---

## SwiftUI: Animating Gestures and Drag Effects

SwiftUI makes it easy to attach gestures to any view and animate their effects, including interactive behaviors like dragging. This guide walks you through how to build a draggable card, how to animate its movement, and how to take those concepts further with animated letter sequences.

### Goal

- Allow views to be dragged using `DragGesture()`
- Animate views back to their original position when released
- Use implicit and explicit animations to control how views respond to interaction
- Chain animations across multiple views with delays for visual effects

### Basic Draggable Card

Start with a gradient rectangle that represents a card:

```swift
LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
    .frame(width: 300, height: 200)
    .clipShape(.rect(cornerRadius: 10))
````

#### Step 1: Track Drag Offset

```swift
@State private var dragAmount = CGSize.zero
```

#### Step 2: Apply Offset to the View

```swift
.offset(dragAmount)
```

#### Step 3: Attach a Drag Gesture

```swift
.gesture(
    DragGesture()
        .onChanged { dragAmount = $0.translation }
        .onEnded { _ in dragAmount = .zero }
)
```

When you drag the view, `dragAmount` updates its position. When you release, it snaps back to center.

### Adding Animation

#### Option 1: Implicit Animation (on drag + release)

```swift
.animation(.bouncy, value: dragAmount)
```

This animates *all* changes to `dragAmount` — during the drag and after release. You'll see slight lag and overshoot due to the spring-like nature of `.bouncy`.

#### Option 2: Explicit Animation (on release only)

Remove the implicit `.animation` and update your gesture like this:

```swift
.onEnded { _ in
    withAnimation(.bouncy) {
        dragAmount = .zero
    }
}
```

Now:

* Drag is instant (no delay)
* Snap back is animated

### Advanced Example: Animated Letters with Delays

Now let’s animate an entire string where each letter moves with delay, like a wave.

```swift
struct ContentView: View {
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(
                        .linear.delay(Double(num) / 20),
                        value: dragAmount
                    )
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded {
                    _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
    }
}
```

#### What’s Happening?

* `letters` is a character array: `Array("Hello SwiftUI")`
* Each letter:

  * Gets its own color and offset
  * Animates with a delay based on position
* Tapping triggers a toggle between red/blue with `enabled`
* The drag offset animates back with a ripple effect across the text


### Recap

| Concept                  | Description                                                             |
| ------------------------ | ----------------------------------------------------------------------- |
| `offset()`               | Moves a view relative to its original position without affecting layout |
| `DragGesture()`          | Responds to finger drag movements                                       |
| `onChanged`, `onEnded`   | Track gesture translation and release                                   |
| `animation()`            | Implicitly animate property changes                                     |
| `withAnimation()`        | Explicitly animate code block changes                                   |
| `.delay()` in animations | Stagger effects across multiple views for fluid motion                  |


### Bonus Tip

SwiftUI’s built-in animations like `.bouncy`, `.easeInOut`, and `.spring()` make it easy to create natural, satisfying effects — especially when combined with gestures and state.

### Final Thoughts

With just a few lines of SwiftUI, you can build complex interactions:

* Drag views around the screen
* Snap them back with style
* Animate sequences with per-view delays

Explore combining these ideas with other gestures (tap, long press) and animations to craft expressive, responsive UIs.

---

## SwiftUI: View Transitions and Conditional Rendering

One of SwiftUI’s most powerful features is the ability to **show and hide views with smooth animations**. You’ve likely seen how `if` statements conditionally render views — but using **transitions**, we can control exactly *how* those views animate in and out of the view hierarchy.


### Key Concepts

| Concept              | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `@State`             | Tracks view state to conditionally render views                             |
| `if` Condition       | Used to add/remove views dynamically                                         |
| `withAnimation {}`   | Wrap state changes to animate them implicitly                               |
| `.transition()`      | Controls how a view enters or exits                                         |
| `.asymmetric()`      | Lets you apply different transitions for insertion and removal              |


### Basic Setup

```swift
struct ContentView: View {
    @State private var isShowingRed = false

    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }

            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
            }
        }
    }
}
````

* Tapping the button toggles the rectangle.
* Without animation: it pops in/out instantly.
* With `withAnimation {}`, it fades smoothly.


### Using Transitions

SwiftUI provides a `.transition()` modifier to **customize** view entry and exit.

#### Basic Scale Transition

```swift
Rectangle()
    .fill(.red)
    .frame(width: 200, height: 200)
    .transition(.scale)
```

* The view **scales in/out** as it appears or disappears.
* Much smoother and more expressive than a basic fade.

### Asymmetric Transitions

Use `.asymmetric(insertion:removal:)` to **customize both directions** of the transition.

```swift
.transition(
    .asymmetric(
        insertion: .scale,
        removal: .opacity
    )
)
```

* View **scales in** but **fades out**.
* Great for storytelling and subtle emphasis.


### Behind the Scenes

* SwiftUI animates view hierarchy changes when wrapped in `withAnimation {}`.
* The `.transition()` modifier tells SwiftUI *how* to animate views being inserted or removed.
* Transitions **only work on views being conditionally inserted or removed** (like inside `if` blocks).

### Try These Transitions

| Transition          | Description                        |
| ------------------- | ---------------------------------- |
| `.opacity`          | Fades view in/out                  |
| `.scale`            | Grows/shrinks the view             |
| `.slide`            | Slides view in from a direction    |
| `.move(edge: .top)` | Slides in from a specific edge     |
| `.offset(x:y:)`     | Custom position offset transitions |

You can combine them too:

```swift
.transition(.scale.combined(with: .opacity))
```

### Recap

- Use `@State` and `if` to show/hide views
- Wrap changes in `withAnimation {}` to enable transitions
- Use `.transition()` to customize entry/exit animations
- Use `.asymmetric()` for more control
- Try combining `.scale`, `.opacity`, `.slide`, and more

### Example: Custom View Show/Hide

```swift
struct ContentView: View {
    @State private var isShowing = false

    var body: some View {
        VStack {
            Button("Toggle View") {
                withAnimation {
                    isShowing.toggle()
                }
            }

            if isShowing {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 150, height: 150)
                    .transition(
                        .asymmetric(insertion: .scale, removal: .opacity)
                    )
            }
        }
        .padding()
    }
}
```

### Final Thoughts

Transitions only apply when a **view is being inserted or removed** — they don’t animate view *changes* like color or size (that’s where `.animation()` comes in).

---

## SwiftUI Custom Transitions with `.modifier`

SwiftUI gives us powerful built-in transitions, but we can take things even further by creating our own **custom transitions** using the `.modifier` API.

This lets us define *exactly* how a view enters or exits the screen using fully customized view modifiers.


### Core Concepts

| Concept                      | Description                                                                 |
|------------------------------|-----------------------------------------------------------------------------|
| `.modifier(active:identity:)`| Custom transition using two view modifier states (start and end)            |
| `ViewModifier`               | A struct that defines how to change a view’s appearance                     |
| `rotationEffect()`           | Rotates a view around an anchor point                                       |
| `clipped()`                  | Prevents drawing outside the view’s bounds                                  |
| `UnitPoint`                  | Defines the anchor (e.g., `.topLeading`, `.center`)                         |


### Step-by-Step Breakdown

#### 1. Create a Custom ViewModifier

This modifier will apply a rotation and clip the view to its bounds.

```swift
struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}
````

> `.clipped()` ensures rotated parts outside the view’s original frame are hidden.

---

#### 2. Define a Custom Transition

Wrap your `ViewModifier` in a custom `AnyTransition` using an extension.

```swift
extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}
```

> `.modifier(active:identity:)` lets you specify how the view looks *before* (`active`) and *after* (`identity`) the transition.

#### 3. Apply the Custom Transition

Use the transition in any view by attaching `.transition(.pivot)` and triggering it via a state change.

```swift
struct ContentView: View {
    @State private var isShowingRed = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)

            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}
```

* Tapping toggles `isShowingRed`
* The red rectangle *pivots in* from the top-left corner when appearing
* And *pivots out* on disappearance

### Full Animation Flow

1. User taps the screen.
2. `isShowingRed.toggle()` triggers view insertion/removal.
3. SwiftUI runs the custom `pivot` transition:

   * **Insert**: rotates from -90° to 0° at `.topLeading`
   * **Remove**: reverses the process

### Bonus Ideas

* Try changing the anchor to `.bottomTrailing` for a different effect.
* Chain with other transitions using `.combined(with:)`.
* Add spring or delay effects using `withAnimation(.spring())`.


### Example Transition Cheatsheet

| Effect               | Code Sample                          |
| -------------------- | ------------------------------------ |
| Slide in from bottom | `.move(edge: .bottom)`               |
| Fade + scale         | `.scale.combined(with: .opacity)`    |
| Custom pivot         | `.transition(.pivot)`                |
| Flip 3D effect       | Use `rotation3DEffect` in a modifier |


### Recap

- Custom transitions let you go beyond built-in effects
- `.modifier` uses a custom `ViewModifier` for full control
- `.rotationEffect` + `.clipped` makes smooth, bounded animations
- Easily reusable via `.transition(.yourCustomTransition)`

### Final Thoughts

You can create multiple custom transitions by changing:

* The modifier logic (`scale`, `offset`, etc.)
* The anchor point
* The active/identity values

---

## Day 34 – Project 6, part three

---

## Guess the Flag – Animation Challenge

This project is an extension of the classic **"Guess the Flag"** SwiftUI app. The goal of this challenge was to enhance the user experience with custom animations triggered by user interaction. 

It demonstrates a deeper understanding of `@State`, view modifiers, and `withAnimation` in SwiftUI.


### Challenge Goals

1. **Spin the selected flag** on the Y-axis using 3D rotation.
2. **Fade out the other two flags** to 25% opacity.
3. **Add a third effect** (e.g., scale down) to the unselected flags for extra polish.
4. **Reset the animation** when moving to the next question.

### Concepts Used

- `@State` to track which flag was tapped based on the flag's index.
- `rotation3DEffect` for 360° Y-axis rotation.
- Conditional modifiers for `opacity` and `scaleEffect`.
- `withAnimation` blocks to enable smooth transitions.
- `Alert` with a `.default` dismiss button calling a `askQuestion()` function to reset state.


### Challenge Code Snippet

#### View Logic for Animations

```swift
@State private var selectedFlagIndex: Int? = nil

LazyVGrid(columns: columns, spacing: 10) {
    ForEach(0..<min(9, countries.count), id:\.self){index in
            Button{
                flagTapped(index)
                                
                withAnimation {
                    selectedFlagIndex = index
                }
                                
            }label:{
                FlagImage(name:countries[index])
                    .rotation3DEffect(
                        .degrees(selectedFlagIndex == index ? 360 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                    .opacity(selectedFlagIndex == nil || selectedFlagIndex == index ? 1 : 0.25)
                    .scaleEffect(selectedFlagIndex == nil || selectedFlagIndex == index ? 1 : 0.8)
                    .animation(.easeInOut(duration: 0.6), value: selectedFlagIndex)
                }
        }
    }
````

#### Reset Logic in `askQuestion()`

```swift
func askQuestion() {
    withAnimation {
        selectedFlagIndex = nil
    }

    // Shuffle countries, generate new question, etc.
}
```

This setup ensures that each flag responds appropriately to user interaction and resets cleanly on each round.

### Final Notes

These small animation enhancements greatly improve the interactivity and polish of the app. While only a few lines of code are required, they reinforce critical SwiftUI concepts like state-driven UI and view composition.
