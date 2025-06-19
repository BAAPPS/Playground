#  iExpense Summary

---

## Day 36 – Project 7, part one

---

## Understanding @State, Structs vs. Classes, and @Observable in SwiftUI

SwiftUI’s `@State` property wrapper is ideal for managing simple, view-local data. 

However, when you need to **share data between views**, things change — and understanding how Swift handles **structs vs. classes** is critical.


### The Core Concept

- `@State` works great with **structs** because structs are **value types**. Every change creates a new instance, which SwiftUI notices and uses to re-render the view.
- When you switch to using a **class** (a reference type), SwiftUI doesn’t automatically detect internal changes — meaning the UI won't update.
  

### The Problem Example

When using a struct:

```swift
struct User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}
````

This works with `@State`:

```swift
@State private var user = User()
```

But if you change `User` to a class:

```swift
class User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}
```

The UI **stops updating** — because `@State` can no longer detect changes inside the class.

#### The Fix: Use `@Observable`

To allow SwiftUI to track changes inside a class, simply mark it with `@Observable`:

```swift
@Observable
class User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}
```

Now, SwiftUI will respond to property changes inside the class and re-render the UI accordingly.


### Why This Matters

* **Structs** trigger UI updates automatically with `@State`, but don’t allow shared mutable state between views.
* **Classes** allow shared data but don’t trigger updates by default.
* **@Observable bridges that gap**, enabling reactive updates for class-based data models.


### Recap

* Use `@State` with structs for simple, local data.
* Use `@Observable` with classes when data needs to be **shared and observed** across views.

---

## Deep Dive: `@State`, Classes, and `@Observable` in SwiftUI

SwiftUI gives us powerful tools to manage state in our apps. But when moving from structs to classes, there's an important detail to understand: **`@State` does not observe internal changes to classes** unless they are marked with `@Observable`.

### The Core Insight

- `@State` works great with **structs**: when a property changes, SwiftUI detects it and re-renders the view.
- If you use `@State` with a **class**, you **must mark that class with `@Observable`** to get the same reactive behavior.

#### Example

```swift
@Observable
class User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}
````

Marking the class with `@Observable` allows SwiftUI to **track each individual property** inside the class. Any view that relies on one of those properties will automatically update when the value changes.


### How It Works Behind the Scenes

To see what’s really happening:

1. Add this import at the top of your file:

   ```swift
   import Observation
   ```

2. Right-click on `@Observable` in Xcode and choose **"Expand Macro"**.

This reveals all the extra code Swift is generating. Key takeaways:

* Properties are wrapped with `@ObservationTracked`, which watches them for reads and writes.
* `@ObservationTracked` is a **macro inside a macro** – it tracks exactly when data is accessed or changed.
* The class conforms to the `Observable` protocol, enabling SwiftUI to recognize it as "watchable."

This system allows **fine-grained UI updates**, meaning SwiftUI only refreshes the parts of the interface that depend on changed data.

### Comparison

| Feature                         | `@State` + Struct | `@State` + Class | `@Observable` + Class |
| ------------------------------- | ----------------- | ---------------- | --------------------- |
| Triggers View Update on Change? | ✅ Yes             | ❌ No             | ✅ Yes                 |
| Supports Shared Mutable State?  | ❌ No              | ✅ Yes            | ✅ Yes                 |
| Requires `mutating` Methods?    | ✅ Yes             | ❌ No             | ❌ No                  |


### Recap

* Use `@State` with **structs** for local, simple data.
* If you switch to using **classes**, you must also use `@Observable` for SwiftUI to track property changes.
* `@Observable` uses macros like `@ObservationTracked` to monitor your data at a granular level and ensure efficient UI updates.

---

## Presenting and Dismissing Sheets in SwiftUI

SwiftUI provides several ways to navigate between views, and one of the most straightforward is the **sheet** — a view presented modally over another. On iOS, this shows as a card sliding up from the bottom, with the current view subtly fading back.


#### How Sheets Work

Unlike imperative frameworks, SwiftUI does **not** use explicit `.present()` or `.dismiss()` methods. 

Instead, sheets are **state-driven**: we declare the conditions under which a sheet should appear, and SwiftUI handles the presentation.


### Basic Example

#### Step 1: Create the view to present

```swift
struct SecondView: View {
    var body: some View {
        Text("Second View")
    }
}
````

> This view doesn’t need to know it’s being shown as a sheet.

#### Step 2: Use `@State` to control presentation

```swift
struct ContentView: View {
    @State private var showingSheet = false

    var body: some View {
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            SecondView()
        }
    }
}
```

### Passing Data to the Sheet

You can pass values to the sheet view just like any SwiftUI view initializer:

```swift
struct SecondView: View {
    let name: String

    var body: some View {
        Text("Hello, \(name)!")
    }
}
```

```swift
.sheet(isPresented: $showingSheet) {
    SecondView(name: "@DF")
}
```

> Swift enforces passing required parameters, reducing runtime errors.


### Dismissing Sheets Programmatically

While users can swipe down to dismiss a sheet, you may want to dismiss it using a button. SwiftUI handles this via the environment.

#### Step 1: Use `@Environment(\.dismiss)`

```swift
struct SecondView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Dismiss") {
            dismiss()
        }
    }
}
```

> SwiftUI figures out how the view was presented and dismisses it correctly.


### Recap

* Use `.sheet(isPresented:)` with `@State` to control modal view presentation.
* Pass data through view initializers just like any other SwiftUI view.
* Use `@Environment(\.dismiss)` to dismiss sheets programmatically.
* SwiftUI handles presentation and dismissal transitions automatically and intelligently.

---


## Deleting Items in SwiftUI with `onDelete()`

SwiftUI makes it easy to manage collections of data in a list. With the `onDelete()` modifier, we can allow users to remove rows from a `List` using standard iOS gestures or an edit mode.


### What `onDelete()` Does

The `onDelete()` modifier is used to **enable swipe-to-delete behavior** on list rows. It is available only when using `ForEach`, not when using a `List` directly.

> This gives us the ability to define how data should be removed when a user interacts with a list row.

#### Basic Example: Adding and Displaying Numbers

```swift
struct ContentView: View {
    @State private var numbers = [Int]()
    @State private var currentNumber = 1

    var body: some View {
        VStack {
            List {
                ForEach(numbers, id: \.self) {
                    Text("Row \($0)")
                }
                .onDelete(perform: removeRows)
            }

            Button("Add Number") {
                numbers.append(currentNumber)
                currentNumber += 1
            }
        }
    }

    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}
````

> Note: While `List(numbers, id: \.self)` is valid, **.onDelete() only works with ForEach**, so use it for deletable lists.

### Understanding `IndexSet`

`onDelete()` passes an `IndexSet`, which represents the indices in the array to remove. Swift arrays include a method `remove(atOffsets:)` that works directly with this.

```swift
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
```


### Bonus: Adding Edit Mode

Want to allow users to delete multiple items with an Edit/Done toggle?

### Step 1: Wrap everything in a `NavigationStack`

```swift
NavigationStack {
    VStack {
        // list and button
    }
    .toolbar {
        EditButton()
    }
}
```

> `EditButton()` is built-in and automatically toggles editing mode in lists.


## Recap

* Use `.onDelete()` with `ForEach` to support swipe-to-delete.
* Implement a function that takes `IndexSet` to remove items from your array.
* Wrap the list in a `NavigationStack` and add `EditButton()` for full delete UI.
* SwiftUI does most of the heavy lifting for you.

---

## Storing Data in SwiftUI with `UserDefaults` and `@AppStorage`

Users expect apps to remember their preferences and previous actions. SwiftUI offers lightweight tools to persist user data using **`UserDefaults`** and **`@AppStorage`**, both ideal for small-scale data like settings or 
counters.


### What Is `UserDefaults`?

`UserDefaults` is a simple key-value store used to persist small amounts of data (≤ 512KB). It's great for:

- Tracking app launches
- Saving user preferences
- Storing lightweight session info

> Avoid storing large datasets here — all data is loaded at app launch, which could slow down startup time.

#### Example: Storing a Tap Counter

```swift
struct ContentView: View {
    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")

    var body: some View {
        Button("Tap count: \(tapCount)") {
            tapCount += 1
            UserDefaults.standard.set(tapCount, forKey: "Tap")
        }
    }
}
````

#### What’s Happening:

* Reads initial value with `UserDefaults.standard.integer(forKey:)`.
* Saves value using `UserDefaults.standard.set(_:forKey:)`.
* Key `"Tap"` is case-sensitive and must match on read/write.

#### Things to Know

* If no value exists for a key, a default is returned (e.g. `0` for integers).
* Data is **not written immediately** — iOS batches changes for performance.
* A rapid app relaunch may skip the most recent write.


### Simplifying with `@AppStorage`

SwiftUI provides the `@AppStorage` property wrapper to integrate with `UserDefaults` more seamlessly.

```swift
struct ContentView: View {
    @AppStorage("tapCount") private var tapCount = 0

    var body: some View {
        Button("Tap count: \(tapCount)") {
            tapCount += 1
        }
    }
}
```

### Benefits of `@AppStorage`:

* Automatically reads from and writes to `UserDefaults`.
* Triggers UI updates like `@State`.
* Requires less boilerplate.

### Considerations:

* Only supports basic data types (`Int`, `Bool`, `String`, etc.).
* Not suited for complex objects (e.g., custom `structs`).
* NOTE: You must still declare why you're using persistent storage when submitting to the App Store — Apple wants to prevent misuse for tracking.


### Best Practices

* Keep `UserDefaults` storage under `512KB`.
* Use `@AppStorage` when possible for simplicity.
* Name your keys carefully (case-sensitive).
* Avoid using `UserDefaults` for sensitive or structured data.

### Recap

| Feature                 | `UserDefaults`             | `@AppStorage`              |
| ----------------------- | -------------------------- | -------------------------- |
| Setup                   | Manual read/write          | Declarative                |
| Triggers UI Update      | No                         | Yes                        |
| Good For                | Basic settings, small data | Same                       |
| Stores Complex Objects? | Only with encoding         | ❌ (not supported)          |
| Ideal Use Case          | Fine-grained control       | Quick bindings to UI state |


By leveraging `UserDefaults` and `@AppStorage`, SwiftUI lets you preserve small user preferences and state with minimal code, creating a better user experience with very little effort.

---

## Storing Complex Data in SwiftUI with `UserDefaults` and `Codable`

While `@AppStorage` is perfect for storing simple types like `Int`, `Bool`, or `String`, it **doesn’t support custom Swift types**. 

To persist complex data (like your own `structs`), we need to manually encode and decode data using `UserDefaults`.


### Why Use `Codable`?

The `Codable` protocol enables Swift types to be easily **encoded to and decoded from formats like JSON**. This makes it easy to convert your objects into a format suitable for storage.


### Example: Custom User Type

```swift
struct User: Codable {
    let firstName: String
    let lastName: String
}
````

> `Codable` allows the `User` struct to be serialized and deserialized without extra work.

### Saving to `UserDefaults`

```swift
@State private var user = User(firstName: "Taylor", lastName: "Swift")

Button("Save User") {
    let encoder = JSONEncoder()

    if let data = try? encoder.encode(user) {
        UserDefaults.standard.set(data, forKey: "UserData")
    }
}
```

#### What’s Happening:

* We create a `JSONEncoder` instance.
* Attempt to encode the `user` into `Data`.
* If successful, we store it in `UserDefaults` under a key (`"UserData"`).

> ⚠️ This bypasses `@AppStorage`, which **does not support custom data types**.

### Loading from `UserDefaults`

```swift
if let data = UserDefaults.standard.data(forKey: "UserData") {
    let decoder = JSONDecoder()
    
    if let loadedUser = try? decoder.decode(User.self, from: data) {
        user = loadedUser
    }
}
```

* Retrieve `Data` using the same key.
* Decode it using `JSONDecoder`.
* Assign the resulting `User` object back into your property.

### Best Practices

* Stick to `@AppStorage` for small, simple values.
* Use `Codable` + `JSONEncoder/Decoder` for custom structs.
* Be mindful of how much you're storing – keep it lightweight (\~≤ 512KB).
* Use unique, descriptive keys for `UserDefaults`.

### Recap

| Feature                | `@AppStorage`                    | Manual Codable + `UserDefaults` |
| ---------------------- | -------------------------------- | ------------------------------- |
| Supports Custom Types? | ❌                                | ✅                               |
| Syntax Simplicity      | ✅ (1-line)                       | ❌ (manual encoding/decoding)    |
| Ideal Use Case         | Simple settings (e.g., Booleans) | Complex data persistence        |
| Format Used            | Native types                     | JSON via `Codable`              |


---

## Day 37 – Project 7, part two

---
