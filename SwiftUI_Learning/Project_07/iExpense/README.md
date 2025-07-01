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

## iExpense: Expense Tracker with SwiftUI

This project introduces a more scalable way of managing and persisting a list of expenses using a class powered by `@Observable` and tracked in the UI using `@State`.

Rather than using a simple array inside a view, we'll separate data concerns into a dedicated model, which allows us to store, modify, and eventually persist expenses cleanly.


### Data Model

#### `ExpenseItem`

Represents a single expense.

```swift
struct ExpenseItem {
    let name: String
    let type: String
    let amount: Double
}
````

### `Expenses`

An observable class that holds an array of `ExpenseItem` entries.

```swift
@Observable
class Expenses {
    var items = [ExpenseItem]()
}
```

> Marking `Expenses` as `@Observable` allows SwiftUI to update the UI whenever `items` changes.


### SwiftUI View: Listing Expenses

We store an instance of `Expenses` in our view using `@State`:

```swift
@State private var expenses = Expenses()
```

> `@State` ensures the reference to the class stays alive.
> `@Observable` ensures SwiftUI re-renders when `items` is changed.

### Displaying the List

```swift
NavigationStack {
    List {
        ForEach(expenses.items, id: \.name) { item in
            Text(item.name)
        }
        .onDelete(perform: removeItems)
    }
    .navigationTitle("iExpense")
    .toolbar {
        Button("Add Expense", systemImage: "plus") {
            let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
            expenses.items.append(expense)
        }
    }
}
```

### Deleting Items

To support swipe-to-delete functionality, we implement this function:

```swift
func removeItems(at offsets: IndexSet) {
    expenses.items.remove(atOffsets: offsets)
}
```

Attach it using `.onDelete(perform:)` after `ForEach` loop:

```swift
.onDelete(perform: removeItems)
```

### ⚠️ About `id: \.name`

Using `.name` as the unique identifier may cause problems if multiple items have the same name:

```swift
ForEach(expenses.items, id: \.name)
```

> ⚠️ This can lead to broken animations or bugs.
> ✅ In a real-world app, prefer using a unique identifier like `UUID`.

### Recap

| Feature                    | Usage Example                              |
| -------------------------- | ------------------------------------------ |
| Define item model          | `struct ExpenseItem { ... }`               |
| Track items with a class   | `@Observable class Expenses`               |
| Hold data in view          | `@State private var expenses = Expenses()` |
| Display list with deletion | `List → ForEach → .onDelete()`             |
| Add items dynamically      | `.toolbar` with button and append          |

---

## Ensuring Uniqueness in Dynamic Lists

When building dynamic views in SwiftUI using `List` and `ForEach`, it's crucial that SwiftUI can uniquely identify each row. This helps it animate changes, update UI efficiently, and avoid strange bugs.

### The Problem

Previously, we wrote:

```swift
ForEach(expenses.items, id: \.name) { item in
    Text(item.name)
}
````

However, we were adding test data like this:

```swift
let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
```

Since the `name` value was the same (`"Test"`), the list items weren’t actually unique. This confused SwiftUI, leading to unreliable UI behavior when deleting or updating rows.

### The Solution: Use `UUID()`

We updated our `ExpenseItem` to include a universally unique identifier (UUID):

```swift
struct ExpenseItem {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}
```

This guarantees that each item has a truly unique identifier.

Then, we updated `ForEach` to:

```swift
ForEach(expenses.items, id: \.id) { item in
    Text(item.name)
}
```

This ensures SwiftUI always knows exactly which item changed.


###  Even Better: Conform to `Identifiable`

We further improved the code by conforming to the `Identifiable` protocol:

```swift
struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}
```

> The `Identifiable` protocol only requires one thing: an `id` property that’s unique.

With that in place, SwiftUI automatically knows how to identify each item.

We can now simplify our `ForEach` even more:

```swift
ForEach(expenses.items) { item in
    Text(item.name)
}
```

This is cleaner, less error-prone, and more SwiftUI-native.

###  Why This Matters

* Ensures correct animations and UI behavior when items change.
* Prevents logical bugs caused by duplicate identifiers.
* Keeps your code clean and future-proof with `Identifiable`.

### Recap

| Issue                            | Fix                                        |
| -------------------------------- | ------------------------------------------ |
| Duplicate `id` keys in `ForEach` | Use `UUID()` in your model                 |
| Manual `id` in `ForEach`         | Conform model to `Identifiable`            |
| Verbose `ForEach` code           | Let SwiftUI infer `id` with `Identifiable` |

Now your list is dynamic, reliable, and SwiftUI-optimized! ✅

---

## Adding New Expense Items with Shared Data

To allow users to add new expenses, we’ll create a separate view (`AddView`) that shares the same data model (`Expenses`) with our main view (`ContentView`). This step introduces SwiftUI sheets, shared state management using `@Observable`, and view composition.

### Why `@Observable` Matters

Classes marked with `@Observable` (or `@StateObject`/`@ObservedObject`) allow data to be shared between views. When properties of the class change, **only views that use those properties will update** — making SwiftUI efficient and reactive.

### Step-by-Step: Creating `AddView.swift`

We start by creating a new SwiftUI view to collect user input for a new expense:

```swift
struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0

    let types = ["Business", "Personal"]

    var expenses: Expenses

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }

                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
        }
    }
}
````

> You'll need to localize the currency code in a future challenge.

### Presenting `AddView` in `ContentView`

We use a `sheet()` to display `AddView` modally from `ContentView`.

#### 1. Track Sheet State

Add a Boolean to control sheet visibility:

```swift
@State private var showingAddExpense = false
```

#### 2. Present the Sheet with Shared Data

Attach a `.sheet()` modifier to your view and pass in the shared `expenses`:

```swift
.sheet(isPresented: $showingAddExpense) {
    AddView(expenses: expenses)
}
```

#### 3. Toggle the Sheet with a Button

Update the “+” button to toggle the sheet state:

```swift
Button("Add Expense", systemImage: "plus") {
    showingAddExpense = true
}
```

### Fixing the Preview

Since `AddView` now requires an `Expenses` instance, update the preview code to provide a dummy value:

```swift
#Preview {
    AddView(expenses: Expenses())
}
```

### Result

You now have a shared data model (`Expenses`) passed between `ContentView` and `AddView`. When the user taps the “+” button:

1. A sheet appears (`AddView`)
2. The user fills out the form
3. When data is saved (to be implemented next), `Expenses` updates
4. SwiftUI automatically refreshes `ContentView`

### Recap

| Feature                         | Role                                          |
| ------------------------------- | --------------------------------------------- |
| `@Observable` or `@StateObject` | Enables shared and reactive data across views |
| `.sheet()`                      | Presents modals in SwiftUI                    |
| Data passed via initializer     | Keeps both views in sync with the same object |
| `@State` inside `AddView`       | Stores user input locally until it’s saved    |

This is the foundation for adding, editing, and saving expenses in a modern, responsive SwiftUI app.

--- 

## Saving and Loading Expense Data

Now that the UI is functional — we can add and delete expenses, and launch a sheet — it’s time to actually **store the user’s data** and make sure it persists across app launches.

### What We’ll Solve

- Capture the user’s input in `AddView`
- Save expense items to `UserDefaults` using `Codable`
- Load saved items when the app launches
- Sync both views with shared `Expenses` data


### Step 1: Save New Expense Items

In `AddView`, add a **Save** button inside a `.toolbar` modifier:

```swift
.toolbar {
    Button("Save") {
        let item = ExpenseItem(name: name, type: type, amount: amount)
        expenses.items.append(item)
    }
}
````

> This works because `expenses` is a reference to the shared `Expenses` class from `ContentView`.


### Step 2: Make `ExpenseItem` Codable

To save and load our data, Swift needs to convert it to and from JSON. We do this by conforming `ExpenseItem` to `Codable`:

```swift
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
```

> ⚠️ We use `var` for `id` to silence a Swift decoding warning. It still works as intended.

### Step 3: Save Changes Automatically

Use a `didSet` observer on the `items` array inside the `Expenses` class. This will save every change to `UserDefaults` as soon as it happens:

```swift
var items = [ExpenseItem]() {
    didSet {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "Items")
        }
    }
}
```

> `JSONEncoder().encode(items)` transforms our Swift array into a JSON `Data` object ready for storage.

### Step 4: Load Saved Items on App Launch

Create a custom `init()` inside `Expenses` to load saved data from `UserDefaults` using `JSONDecoder`:

```swift
init() {
    if let savedItems = UserDefaults.standard.data(forKey: "Items") {
        if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
            items = decodedItems
            return
        }
    }

    items = []
}
```

> `.self` tells Swift we’re referencing the type itself — in this case, the array type `[ExpenseItem]`.


### Final Result

1. User enters expense in `AddView`
2. Expense is added to shared `Expenses.items`
3. `didSet` saves new state to `UserDefaults`
4. Next launch, `init()` loads data from disk
5. App shows correct data automatically

### Recap

| Feature                | Role                                    |
| ---------------------- | --------------------------------------- |
| `Codable`              | Enables easy archiving and unarchiving  |
| `UserDefaults`         | Stores user data persistently           |
| `didSet` on `items`    | Auto-saves whenever changes occur       |
| `init()` in `Expenses` | Loads data when app starts              |
| `AddView.toolbar Save` | Creates and appends a new `ExpenseItem` |

With this structure, your app now **persists expenses across launches** and keeps all views in sync using a shared observable model. This is a huge step toward a complete SwiftUI app.

---

## Final Polish: Dismiss Sheet & Display Expense Details

Before wrapping up the iExpense project, we took care of two final issues that affect the user experience:


### Problems We Solved

1. **AddView doesn’t dismiss after saving**
2. **Expense list shows only the name — no type or amount**

Let’s walk through the fixes.


### 1. Automatically Dismiss `AddView`

When users save an expense, they should be returned to the main view. SwiftUI handles this using an environment value called `dismiss`.

**Step 1:** Add this property to `AddView`:

```swift
@Environment(\.dismiss) var dismiss
````

> This lets SwiftUI handle dismissing the view by setting the related `.sheet` binding back to `false`.

**Step 2:** Call `dismiss()` after saving the new item:

```swift
Button("Save") {
    let item = ExpenseItem(name: name, type: type, amount: amount)
    expenses.items.append(item)
    dismiss()
}
```

> Now when a user saves, `AddView` disappears automatically.

### 2. Show Expense Type and Amount

We want the main list to show more detail than just the name. A typical iOS layout includes:

* Title (bold)
* Subtitle (secondary info)
* Right-aligned metadata (like price)

Replace the old list code with a full stack-based layout:

```swift
ForEach(expenses.items) { item in
    HStack {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.headline)
            Text(item.type)
        }

        Spacer()

        Text(item.amount, format: .currency(code: "USD"))
    }
}
```

> We used a `VStack` inside an `HStack`, with a `Spacer()` to push the amount to the right — a very common layout in iOS apps.

### Recap

| Feature                   | Benefit                                                |
| ------------------------- | ------------------------------------------------------ |
| `@Environment(\.dismiss)` | Cleanly exits `AddView` after saving                   |
| Improved `ForEach` layout | Displays type and amount in a structured, readable way |
| `.currency(code: "USD")`  | Formats values using system currency conventions       |


---

## Challenges & Solutions

### Challenge 1: Use the User’s Preferred Currency

**Problem**: The app originally formatted amounts in hard-coded US dollars (`USD`), regardless of the user’s locale.

**Solution**:
Used `Locale.current.currency?.identifier` to retrieve the user's preferred currency and used a fallback to USD when not available.

```swift
Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
````

---

### Challenge 2: Conditional Styling Based on Expense Amount

**Problem**: Style list items differently depending on how expensive they are:

* Under $10 → one style
* Under $100 → another
* Over $100 → a third

**Solution**:
Extended `ExpenseItem` to return a color based on amount and applied it to `.listRowBackground`.

```swift
extension ExpenseItem {
    var amountColor: Color {
        switch amount {
        case ..<10:
            return .green
        case ..<100:
            return .orange
        default:
            return .blue
        }
    }
}
```

Applied it like so:

```swift
.listRowBackground(item.amountColor)
```

---

### Challenge 3: Split List Into Personal and Business Sections

**Problem**: All expenses were displayed in a single list without category separation, making it harder to navigate.

**Solution**:
Grouped expenses into two `Section` views by filtering items:

```swift
List {
    Section("Personal") {
        ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
            ExpenseRow(item: item)
        }
    }

    Section("Business") {
        ForEach(expenses.items.filter { $0.type == "Business" }) { item in
            ExpenseRow(item: item)
        }
    }
}
```

Used a reusable view `ExpenseRow` for clean and readable code:

```swift
struct ExpenseRow: View {
    let item: ExpenseItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            Spacer()
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .listRowBackground(item.amountColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .foregroundColor(.white)
    }
}
```

### Concepts Practiced

* `Locale` and currency formatting
* Ternary and `switch`-based conditional styling
* SwiftUI list sectioning
* Reusable view components
* `.listRowBackground` and styling customization

---

### Recap

These challenges pushed practical understanding of SwiftUI layout, logic, and UI separation. 

By completing them, I gained hands-on experience with:

* Environment-aware formatting
* Dynamic styling
* Data categorization
* SwiftUI best practices for clean UI

