# Bookies Summary

---

## Day 53 – Project 11, part one

---

## Understanding `@Binding` in SwiftUI

SwiftUI gives us multiple ways to manage and share state across views. You’ve seen:

* `@State`: for managing simple, local value types in a view.
* `@Bindable`: for working with properties inside observable classes (used with `@Observable`).

Now meet ** `@Binding` **, a powerful property wrapper that enables **two-way data sharing** for simple value types like `Bool`, `Int`, `String`, and arrays between views.

### What is `@Binding`?

* `@Binding` creates a connection between two views so that **changes made in one place reflect in the other**.
* It’s commonly used in reusable UI components, like a toggle switch or a custom button, which need to modify state **owned by a parent view**.

#### Example:

```swift
@State private var rememberMe = false

var body: some View {
    Toggle("Remember Me", isOn: $rememberMe)
}
```

Here, `Toggle` uses a `@Binding` to mutate the value stored in the parent view's `@State`.

### ⚠️ Common Pitfall

If you pass a value directly instead of a binding, you get a **one-way data flow** — the child view won’t be able to update the parent’s state, resulting in inconsistent UI behavior.

### ✅ Fixing with `@Binding`

**Before (Broken):**

```swift
struct PushButton: View {
    let title: String
    @State var isOn: Bool // this causes a disconnect
}
```

**After (Fixed):**

```swift
struct PushButton: View {
    let title: String
    @Binding var isOn: Bool
}
```

**Usage:**

```swift
PushButton(title: "Remember Me", isOn: $rememberMe)
```

The dollar sign (`$`) passes a binding, not just the value.

### Two-Way Sync in Action

With `@Binding`, your custom components like `PushButton` can **stay in sync** with the parent view, ensuring a single source of truth.

This makes `@Binding` essential for building **interactive, reusable UI components** that need to reflect or mutate shared state.

---

## Multi-line Text Input in SwiftUI: `TextEditor` vs `TextField`

When collecting user input, SwiftUI offers two primary tools:

* `TextField`: Ideal for short, single-line inputs.
* `TextEditor`: Designed for longer, multi-line input like notes or comments.


### `TextEditor`: For Long-Form Text

`TextEditor` is a SwiftUI view that allows users to type **multi-line text** with a familiar, scrolling text box experience. It's simple to use and binds directly to a `String` via `@State` or `@AppStorage`.

#### Example:

```swift
struct ContentView: View {
    @AppStorage("notes") private var notes = ""

    var body: some View {
        NavigationStack {
            TextEditor(text: $notes)
                .navigationTitle("Notes")
                .padding()
        }
    }
}
```

> ⚠️ Note: `@AppStorage` is **not secure** – don't store private or sensitive data in it.

#### ✅ Benefits:

* Supports multiline input by default.
* Easy setup with minimal configuration.

#### ⚠️ Considerations:

* No built-in styling or placeholder support.
* Needs to be inside a `NavigationStack`, `Form`, or other layout to avoid layout issues (e.g., overlapping keyboard).

---

### `TextField` with `.vertical` Axis

SwiftUI's `TextField` has evolved: it now supports **dynamic expansion** along a vertical axis.

#### Example:

```swift
struct ContentView: View {
    @AppStorage("notes") private var notes = ""

    var body: some View {
        NavigationStack {
            TextField("Enter your text", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .navigationTitle("Notes")
                .padding()
        }
    }
}
```

#### Benefits:

* Starts compact and expands with content (similar to iMessage).
* Offers styling options like `.roundedBorder`.

### Which One Should You Use?

| Use Case        | Recommended View             |
| --------------- | ---------------------------- |
| Short input     | `TextField`                  |
| Expanding input | `TextField` with `.vertical` |
| Long-form notes | `TextEditor`                 |

Try both **inside and outside a `Form` **, as SwiftUI may render them differently depending on the container.

---

## What Is SwiftData?

* A persistence framework that replaces Core Data for many apps.
* Works with custom models using the `@Model` macro.
* Supports advanced features like **iCloud sync**, **sorting/filtering**, **lazy loading**, and **undo/redo**.
* Integrates beautifully with SwiftUI via property wrappers and environment integration.


## Step-by-Step Setup

### 1. Define a SwiftData Model

```swift
import SwiftData

@Model
class Student {
    var id: UUID
    var name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
```

> ✅ `@Model` makes your class storable, observable, and queryable with minimal boilerplate.


### 2. Configure SwiftData in Your App Entry Point

In `BookwormApp.swift`:

```swift
import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Student.self)
    }
}
```

> 🔒 A `modelContainer` is where your app’s data is stored and accessed from.

### 3. Querying Data in SwiftUI

In `ContentView.swift`:

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var students: [Student]

    var body: some View {
        NavigationStack {
            List(students) { student in
                Text(student.name)
            }
            .navigationTitle("Classroom")
        }
    }
}
```

> `@Query` dynamically reflects the current data — updates in real time as data changes.


### 4. Adding Data with `modelContext`

To insert new data:

```swift
@Environment(\.modelContext) var modelContext

.toolbar {
    Button("Add") {
        let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
        let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]

        let student = Student(
            id: UUID(),
            name: "\(firstNames.randomElement()!) \(lastNames.randomElement()!)"
        )

        modelContext.insert(student)
    }
}
```

>  `modelContext` is the live interface to your app’s data. Insertions are automatically saved and persisted across app launches.


### Recap

| Concept                        | Purpose                                                |
| ------------------------------ | ------------------------------------------------------ |
| `@Model`                       | Defines a data object for persistence                  |
| `.modelContainer()`            | Configures storage at the app level                    |
| `@Query`                       | Automatically keeps views in sync with data            |
| `@Environment(\.modelContext)` | Interface to insert, delete, and manage data in memory |

---


