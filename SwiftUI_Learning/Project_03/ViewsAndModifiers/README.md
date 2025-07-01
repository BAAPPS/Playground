# ViewsAndModifiers Summary

## Day 23 – Project 3, part one

---

### Why SwiftUI Uses Structs for Views

SwiftUI takes a **struct-based approach** to building user interfaces, in contrast to UIKit and AppKit, which use **classes** like `UIView`.

### Why Structs?

#### Performance

- Structs are **lightweight** and **fast to create**, with no inheritance overhead. 

- A struct that holds one integer uses memory only for that integer — no hidden superclass baggage.

#### Predictable State

- Structs are **immutable by default**, which helps SwiftUI detect state changes efficiently. 

- This functional design encourages clear separation of **UI and state**, leading to more maintainable code.

#### Simplicity

- SwiftUI views like `Color.red` or `LinearGradient` are minimal and focused — they contain only the data necessary to render UI.

- In contrast, UIKit’s `UIView` includes **\~200 properties/methods**, all inherited by default, whether needed or not.


### Final Tip

Avoid using classes for SwiftUI views — doing so can break your code or lead to runtime crashes. **Stick to structs.** 

--- 

### Understanding Backgrounds and View Sizing

- When using SwiftUI, you might try adding a `.background(.red)` to a `VStack` expecting it to fill the entire screen – but it doesn’t. 

- Instead, it only colors the space *around the content*, not the whole view.

#### Why Doesn’t the Background Fill the Screen?

- SwiftUI views size themselves based on their **content**, not the screen by default. 

- There is **no "behind" your view** — that white space isn’t part of your layout unless you tell it to be.

- Avoid UIKit-style hacks (like modifying `UIHostingController`) — these are fragile and **not cross-platform**.

#### The SwiftUI Way 

To fill the screen, tell SwiftUI your view *can* expand:

```swift
.frame(maxWidth: .infinity, maxHeight: .infinity)
```

This allows the `VStack` to grow as large as the container allows, letting your background fill the screen naturally.

### Final Tip

- `.maxWidth` and `.maxHeight` offer flexibility — unlike fixed `width`/`height`, they play nicely with surrounding views.

--- 

### How SwiftUI Applies Modifiers

In SwiftUI, **modifiers don’t change views in place** — they create entirely new views each time. 

- This behavior has big implications for layout and styling.


#### Why This Happens

SwiftUI views are **structs**, so they hold only the data you give them — no inherited behavior, no mutable state. 

- So when you use a modifier like `.background()`, SwiftUI wraps the view in a new type with that effect applied.

#### Modifier Stacking in Practice

SwiftUI builds up its data using `ModifiedContent`

Every modifier wraps the previous one using types like:

```swift
ModifiedContent<ModifiedContent<…>>
```

That’s why **modifier order matters**. 

For example:

```swift
Button("Hello") { }
    .background(.red)
    .frame(width: 200, height: 200)
```

Results in a red background tightly around the text. But:

```swift
Button("Hello") { }
    .frame(width: 200, height: 200)
    .background(.red)
```

Draws a red background over the full 200×200 area.

#### A Useful Mental Model

Imagine SwiftUI renders your view **after each modifier** — not literally true, but it helps reason about layout.

#### Layered Effects with Padding

You can layer effects by repeating modifiers:

```swift
Text("Hello, world!")
    .padding()
    .background(.red)
    .padding()
    .background(.blue)
```

Each layer wraps the previous one visually — giving you nested borders or colorful effects.

### Final Tip

Use this knowledge to **control layout precisely** and avoid confusing modifier behavior!

---

### Understanding `some View` and `Opaque Return Types`

SwiftUI relies heavily on **opaque return types** using `some View` — this is Swift’s way of saying “I’m returning a view, but I’m not telling you exactly what kind.”

#### Why `some View` Matters

- **Performance**: SwiftUI needs to efficiently track view changes to update the UI.

- **Simplicity**: You don’t need to write long, complex types like `ModifiedContent<...>` manually.

This lets us write:

```swift
var body: some View {
    Text("Hello, world!")
}
```

Instead of:

```swift
var body: Text { ... }
```

Or the impossible:

```swift
// ❌ Not allowed
var body: View { ... }
```

Because `View` is a protocol with an associated type — like an "incomplete type" that must be filled in.

#### How SwiftUI Fills the Gaps

* When you return multiple views, SwiftUI wraps them in a **TupleView** behind the scenes.

* This happens thanks to the **@ViewBuilder** attribute on the `body` property.

* For example, this:

```swift
VStack {
    Text("One")
    Text("Two")
}
```

…is compiled as a `VStack<TupleView<(Text, Text)>>`.


### Final Tips

* Use `some View` to return a single view from a `body`.
* Modifier stacking builds up nested `ModifiedContent` types.
* SwiftUI fills in complex view hierarchies automatically using `@ViewBuilder`.

> **Think of `some View` as your way of saying:**
> *“It’s a view, and Swift can figure out the rest.”* 

---

### Conditional Modifiers with Ternary Operators

SwiftUI makes it easy to **conditionally apply modifiers** using the **ternary operator** (`? :`), which helps keep your views efficient and concise.

#### What You’ll Learn

* How to change view styles based on state.
* Why ternary operators are more efficient than `if`/`else` for view modifiers.
* How SwiftUI re-renders views using `@State`.

#### Example: Conditional Foreground Style

```swift
struct ContentView: View {
    @State private var useRedText = false

    var body: some View {
        Button("Hello World") {
            useRedText.toggle()
        }
        .foregroundStyle(useRedText ? .red : .blue)
    }
}
```

When `useRedText` changes, SwiftUI only updates the color — it **does not** recreate the view.

#### Why This Matters

Using `if`/`else` like this:

```swift
if useRedText {
    Button("Hello") { useRedText.toggle() }
        .foregroundStyle(.red)
} else {
    Button("Hello") { useRedText.toggle() }
        .foregroundStyle(.blue)
}
```

…looks fine but creates two distinct `Button` views, which is **less efficient**. SwiftUI has to **destroy and rebuild** the view tree.


### Final Tips

- Prefer the ternary operator for simple, style-based view changes.
- Avoid `if`/`else` unless you're returning structurally different views.

> Mnemonic: **WTF** – *What to check, True, False* - **Scott Michaud’s**

---


### Environment Modifiers

In SwiftUI, **environment modifiers** let you apply a modifier to a container (like `VStack`) and have it **automatically apply** to all its child views — unless a child view **explicitly overrides** it.

#### What You’ll Learn

* How to apply a modifier to multiple views via a container.
* The difference between **environment modifiers** and **regular modifiers**.
* How child views can override environment modifiers.

#### Example: Shared Modifier via VStack

```swift
VStack {
    Text("Gryffindor")
    Text("Hufflepuff")
    Text("Ravenclaw")
    Text("Slytherin")
}
.font(.title) // applies to all text views
```

This uses the `.font()` modifier as an **environment modifier**, so all `Text` views inside the `VStack` inherit `.title` — unless overridden.

#### Example: Overriding the Environment Modifier

```swift
VStack {
    Text("Gryffindor")
        .font(.largeTitle) // overrides VStack’s font
    Text("Hufflepuff")
    Text("Ravenclaw")
    Text("Slytherin")
}
.font(.title)
```

Here, "Gryffindor" uses `.largeTitle` while the others use `.title`.

#### Regular Modifiers Don't Work the Same Way

```swift
VStack {
    Text("Gryffindor")
        .blur(radius: 0) // tries to disable blur
    Text("Hufflepuff")
    Text("Ravenclaw")
    Text("Slytherin")
}
.blur(radius: 5)
```

⚠️ The `.blur(radius:)` modifier is **not** an environment modifier. 

Instead of replacing, child `.blur()` values are **combined** with the parent’s.


### Final Tips

* Use environment modifiers like `.font()` or `.foregroundColor()` to **apply styles globally** to a container’s children.
* Don’t expect child views to “undo” regular modifiers like `.opacity()` or `.blur()` from a parent.
* Environment modifiers help **reduce duplication** and keep your code clean, especially when applying styles to groups of views.

- Unfortunately, SwiftUI doesn’t clearly label which modifiers are environment-based. 

- You’ll need to rely on documentation and experimentation.

---

### View Properties

SwiftUI views can quickly grow in complexity. 

One technique to simplify your layout is to **extract views into properties** — either as **stored** or **computed** views — making your code more readable and reusable.

#### What You’ll Learn

* How to store views as properties.
* When to use computed properties for views.
* How to return multiple views using stacks, `Group`, or `@ViewBuilder`.

#### Example: Stored View Properties

```swift
struct ContentView: View {
    let motto1 = Text("Draco dormiens")
    let motto2 = Text("nunquam titillandus")

    var body: some View {
        VStack {
            motto1
                .foregroundStyle(.red)
            motto2
                .foregroundStyle(.blue)
        }
    }
}
```

Storing views as properties keeps `body` clean and avoids repetition.

#### Example: Computed View Properties

```swift
var motto1: some View {
    Text("Draco dormiens")
}
```

Useful when you want to build views dynamically or compose complex layouts.

#### Returning Multiple Views

Unlike `body`, Swift **does not** automatically apply `@ViewBuilder` to your custom view properties. If you want to return **multiple views**, you have three options:

##### 1. Use a Stack

```swift
var spells: some View {
    VStack {
        Text("Lumos")
        Text("Obliviate")
    }
}
```

##### 2. Use a Group

```swift
var spells: some View {
    Group {
        Text("Lumos")
        Text("Obliviate")
    }
}
```

> `Group` is layout-neutral — layout is handled by the parent view.

##### 3. Use @ViewBuilder (Preferred)

```swift
@ViewBuilder var spells: some View {
    Text("Lumos")
    Text("Obliviate")
}
```

> Matches the behavior of the `body` property, allowing flexibility and clarity.

---

### Final Tips

* Use properties to **encapsulate and reuse** subviews.
* Don’t overload properties with too much logic — it may be a sign your view needs to be broken into smaller components.
* Use `@ViewBuilder` when returning **multiple views**, unless you explicitly want a stack or group.
* Extracting views into properties is a powerful technique to keep your SwiftUI code **modular**, **readable**, and **maintainable**.

---


### Extracting Custom Views

SwiftUI makes it easy and efficient to break large views into smaller, reusable pieces.

This improves readability, reduces repetition, and doesn't negatively impact performance — SwiftUI handles the assembly seamlessly.

#### What You’ll Learn

* How to extract repeated view code into reusable custom views.
* How to mix fixed and customizable styling.
* Why breaking views into components is both clean and efficient.

#### Example: Repetitive Code

```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("First")
                .font(.largeTitle)
                .padding()
                .foregroundStyle(.white)
                .background(.blue)
                .clipShape(.capsule)

            Text("Second")
                .font(.largeTitle)
                .padding()
                .foregroundStyle(.white)
                .background(.blue)
                .clipShape(.capsule)
        }
    }
}
```

👎 This works, but repeats the same styling code twice.

#### Step 1: Create a Custom View

```swift
struct CapsuleText: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(.capsule)
    }
}
```

Encapsulates a stylized `Text` into a reusable `CapsuleText` component.

#### Step 2: Reuse the View

```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            CapsuleText(text: "First")
            CapsuleText(text: "Second")
        }
    }
}
```

👍 Cleaner and easier to maintain.

#### Step 3: Allow for Customization

To make `CapsuleText` flexible, you can remove hardcoded modifiers and apply them at the call site:

```swift
struct CapsuleText: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .background(.blue)
            .clipShape(.capsule)
    }
}
```

```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            CapsuleText(text: "First")
            .foregroundStyle(.white)
            CapsuleText(text: "Second")
            .foregroundStyle(.yellow)

        }
    }
}
```

- This lets the caller decide on color, while keeping the structure and shape consistent.

### Final Tips

* Use extracted views to **reduce duplication** and improve code clarity.
* Feel free to **mix hardcoded and configurable modifiers**.
* Trust SwiftUI's engine — breaking views apart **has minimal to no performance cost**.
* Keep each custom view focused and clean — don't overpack.
* Breaking your view into components is not just about cleanliness — it’s how SwiftUI was designed to scale.

---

### Custom Modifiers – Creating Your Own SwiftUI Modifiers

SwiftUI provides many built-in modifiers like `font()`, `background()`, and `clipShape()`. 

But you can also create **custom modifiers** to encapsulate specific styling or behavior, keeping your code clean and reusable.

#### What You’ll Learn

* How to create a custom view modifier by conforming to `ViewModifier`.
* How to apply custom modifiers using `.modifier()`.
* How to make custom modifiers easier to use with `View` extensions.
* When to choose a custom modifier over a simple View extension method.

#### Step 1: Create a Custom Modifier

Define a struct that conforms to `ViewModifier` and implement its required method:

```swift
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
    }
}
```

#### Step 2: Apply the Modifier Using `.modifier()`

```swift
Text("Hello World")
    .modifier(Title())
```

This applies your custom styling to any view.

#### Step 3: Add Convenience Extensions for Cleaner Syntax

Extensions on `View` make your modifiers easier to use:

```swift
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}
```

Use it like this:

```swift
Text("Hello World")
    .titleStyle()
```

#### Step 4: More Complex Modifiers That Modify View Structure

Custom modifiers can also create new view hierarchies, not just apply existing modifiers.

Usually a smart idea to create `extensions` on `View` that make them easier to use. 

Example: a watermark modifier that overlays text on the bottom right:

```swift
struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}
```

Usage:

```swift
Color.blue
    .frame(width: 300, height: 200)
    .watermarked(with: "Hacking with Swift")
```

### Final Tip

#### When to Use Custom View Modifiers vs View Extensions

* **Custom View Modifiers** can have **stored properties** (like the `text` in `Watermark`), allowing them to hold state/configuration.
* **View extensions** can’t store properties but are useful for simple reusable methods without additional data.

---

### Custom Containers – Building Your Own SwiftUI Container Views

SwiftUI lets you create **custom container views** that arrange child views in specific layouts. 

Although this involves more advanced Swift concepts like generics and closures, it’s a powerful way to build reusable UI components beyond the built-in stacks.


#### What You’ll Learn

* How to create a generic custom container view.
* How to accept dynamic child content with closures.
* How to nest multiple `ForEach` loops to build grid layouts.
* Using the `@ViewBuilder` attribute for flexible content.

#### Step 1: Define a Generic Custom Container

Create a struct that conforms to `View` and uses generics to accept any kind of content that itself conforms to `View`.

```swift
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content  // Closure generating content for each cell

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)  // Render content for each cell
                    }
                }
            }
        }
    }
}
```

* `rows` and `columns` control grid size.
* The `content` closure returns the view for each cell based on row and column.


#### Step 2: Use Your Custom Container

Use your `GridStack` to create a grid of views by providing the number of rows and columns, and a closure to generate each cell’s content.

```swift
struct ContentView: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            Text("R\(row) C\(col)")
        }
    }
}
```

#### Step 3: Nest Complex Content Inside Cells

Each cell can contain any view, including stacks and images:

```swift
GridStack(rows: 4, columns: 4) { row, col in
    HStack {
        Image(systemName: "\(row * 4 + col).circle")
        Text("R\(row) C\(col)")
    }
}
```

#### Step 4: Make Content Closure More Flexible With @ViewBuilder

Add the `@ViewBuilder` attribute to the `content` closure to allow multiple views without needing an explicit stack:

```swift
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    @ViewBuilder let content: (Int, Int) -> Content  // Supports multiple views per cell

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}
```

Now you can write:

```swift
GridStack(rows: 4, columns: 4) { row, col in
    Image(systemName: "\(row * 4 + col).circle")
    Text("R\(row) C\(col)")
}
```

without wrapping the views in an explicit container.

### Final Tips

* When using `ForEach` with dynamic ranges (`rows` or `columns` can change), always provide an `id: \.self` to help SwiftUI uniquely identify views.
* Custom containers leverage Swift’s generics and closures—good Swift knowledge helps.
* Use `@ViewBuilder` to make your custom container closures as flexible as SwiftUI’s own `body`.

---

## Day 24 – Project 3, part two

---

### Part 1: Challenge

1. **Conditional Modifier (Project 1)**

   Update the total amount `Text` view to turn **red** when a **0% tip** is selected using a conditional `.foregroundColor()` modifier.

2. **Custom Flag View (Project 2)**

   Create a reusable `FlagImage()` view to display country flags, applying the exact styling modifiers from earlier.

3. **Custom ViewModifier**

   Build a reusable `TitleStyle` modifier with a **large, blue font**, and create an extension like `.titleStyle()` for easier reuse across views.

#### Challenge 1 — Highlighting a 0% Tip

In this challenge, I enhanced the **WeSplit** app by visually alerting the user when they choose to leave **no tip** (0%) — a potentially important UI cue in real-world scenarios.

##### What I Did

* **Created a conditional background** for the “Total Check Amount” row.
* Used a ** `ZStack` ** to layer a background `Color` behind the total amount `Text`.
* Applied ** `.listRowInsets(EdgeInsets())` ** to remove the default padding added by `Form`/`Section`, allowing the background color to stretch across the entire row.
* Highlighted the row in **red** when `tipPercentage == 0`, otherwise in **green**.
* Styled the total amount text with **white font color** and a **headline** style for readability.

##### Key SwiftUI Techniques

* `ZStack` for layering views (background and text).
* `.frame(maxWidth: .infinity)` to fill horizontal space.
* `.listRowInsets(EdgeInsets())` to remove `Section` padding.
* Ternary conditionals for dynamic styling:
  `(tipPercentage == 0 ? Color.red : Color.green)`

##### Code Snippet

```swift
Section("Total Check Amount") {
    ZStack {
        (tipPercentage == 0 ? Color.red : Color.green)
            .frame(maxWidth: .infinity, minHeight: 44)

        Text(totalCheckAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            .foregroundColor(.white)
            .font(.headline)
    }
    .listRowInsets(EdgeInsets())
}
```

### Challenge 2 — Creating a Reusable `FlagImage` View

In this challenge, I improved the **GuessTheFlag** app by refactoring how flag images are displayed:


#### What I Did

* Created a reusable `FlagImage` SwiftUI component that encapsulates the common styling applied to all flag images.
* Replaced all direct `Image` views with this new `FlagImage` component for consistency and cleaner code.
* The `FlagImage` view applies modifiers like resizing, fixed frame, clipping to a rectangle shape, and shadow.

#### Key Changes Made

##### New `FlagImage` view

```swift
struct FlagImage: View {
    let name: String
    
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 60)
            .clipShape(Rectangle()) // or Rectangle.rect
            .shadow(radius: 5)
    }
}
```

##### Using `FlagImage` in your flags grid

Before:

```swift
Image(countries[index])
    .resizable()
    .scaledToFit()
    .frame(width: 100, height: 60)
    .clipShape(Rectangle())
    .shadow(radius: 5)
```

After:

```swift
FlagImage(name: countries[index])
```

### Challenge 3: Custom Title Style with ViewModifier and Extension

In this challenge, I created a reusable custom style for prominent titles by:

* Defining a `Title` **ViewModifier** that applies:

  * Large font size
  * Blue foreground color
  * Padding around the text
  * A rounded rectangle blue background
* Extending the `View` protocol with a `.titleStyle()` method for easy and clean application of the modifier.

#### What I Did

* Created and used **ViewModifiers** in SwiftUI
* Added custom styling to `View` through extensions for cleaner code
* Applied reusable styles throughout your views

#### Code Changes

**Title ViewModifier:**

```swift
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
```

**View Extension:**

```swift
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}
```

#### Usage Example

Apply the custom title style easily anywhere:

```swift
Text("Guess the Flag")
    .titleStyle()
```

---

