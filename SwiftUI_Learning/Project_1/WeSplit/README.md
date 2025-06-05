#  WeSplit Summary

## Day 16 – Project 1, part one

## User Input with Forms

SwiftUI makes it easy to collect user input using the built-in `Form` view, which is a powerful and flexible container for creating lists of settings, options, or any other form-like UI.


### Why Forms Matter

Most apps need **user input** — whether it’s:

- Setting preferences

- Picking a location

- Ordering from a menu

SwiftUI gives us a **dedicated view called `Form`** to handle all of that cleanly and efficiently.

### How Forms Work

Forms are made of rows, and each row can contain:

- Static views (`Text`, `Image`, etc.)

- Interactive elements (`TextField`, `Toggle`, `Button`, etc.)

```swift
Form {
    Text("Hello, world!")
}
````

> 👀 In the Canvas or on a device, the appearance changes: the background becomes gray, text aligns top-left, mimicking native iOS form UIs like the **Settings app**.

You can stack multiple rows like this:

```swift
Form {
    Text("Row 1")
    Text("Row 2")
    Text("Row 3")
}
```

…and SwiftUI will automatically render them in a list format.

### Organizing with Sections

To group related elements visually, use `Section`:

```swift
Form {
    Section {
        Text("Billing")
    }

    Section {
        Text("Payment Method")
        Text("Add Tip")
    }
}
```

> `Section` helps break the form into **logical groups**, enhancing clarity for the user — similar to iOS Settings.


## Navigation Bar

### SwiftUI & Safe Areas — Improving Layout with NavigationStack

When designing interfaces for iOS, it's important to respect **safe areas** — the parts of the screen not obscured by system UI like the clock, home indicator, or the Dynamic Island.


### What is the Safe Area?

SwiftUI automatically keeps your content **inside the safe area**, which means:

- No overlapping with the **status bar**, **Dynamic Island**, or **home indicator**

- Rounded corners won’t cut off UI

For example:

```swift
Form {
    Section {
        Text("Hello, world!")
    }
}
````

On devices like **iPhone 15**, this form will start *below* the Dynamic Island and stop *above* the home indicator.


### The Scrolling Issue

While `Form` respects the safe area initially, it **can scroll** — which may push content:

* Under the **system clock** ⏰

* Behind the **Dynamic Island**

* Into unreadable areas

Try scrolling in the iOS Simulator and see this behavior.


### Fixing It with NavigationStack

One common fix is to embed your form inside a `NavigationStack`. 

This:

* Adds a **navigation bar** to the top

* Automatically reserves space for safe scrolling

* Lets you add **titles** and **future buttons/navigation**

#### Example:

```swift
NavigationStack {
    Form {
        Section {
            Text("Hello, world!")
        }
    }
}
```

This improves visual layout and prepares you for deeper navigation later.


### Adding a Navigation Title

You can give your navigation bar a title using `.navigationTitle()`:

```swift
NavigationStack {
    Form {
        Section {
            Text("Hello, world!")
        }
    }
    .navigationTitle("SwiftUI")
}
```

> This shows a **large title** by default — like the main "Settings" page in iOS.


### Switching to a Smaller Title

To match the style of sub-settings pages, use:

```swift
.navigationBarTitleDisplayMode(.inline)
```

This switches to a **smaller, inline** title.

### Recap

* Use `Form` for grouped UI input

* SwiftUI automatically keeps content inside the safe area

* Forms can scroll into unsafe regions

* Wrap your form in `NavigationStack` to fix layout and prep for navigation

* Use `.navigationTitle()` to name the screen

* Add `.navigationBarTitleDisplayMode(.inline)` for small titles

---


## SwiftUI State — "Views Are a Function of Their State"

In SwiftUI, there's a core principle:
> “Views are a function of their state.”

- This means the **UI is driven by state** — the values that describe how your app is behaving right now. 

- When the state changes, the UI **automatically updates** to reflect those changes.


### What is "State"?

State represents:

- Lives remaining in a game

- Current score

- User preferences

- Whether a button should be disabled

- Text input from the user

Anything that **can change while the app runs** is considered part of the state.


### Counter Example

You might try to build a simple tap counter like this:

```swift
struct ContentView: View {
    var tapCount = 0

    var body: some View {
        Button("Tap Count: \(tapCount)") {
            tapCount += 1
        }
    }
}
````

#### Why This Doesn’t Work:

* `ContentView` is a `struct`, which is **immutable**.

* Swift doesn’t allow changing properties of a struct like this.

* You can’t mark `body` as `mutating` either — that’s invalid SwiftUI.

### The Solution: `@State`

SwiftUI provides `@State` — a **property wrapper** that lets SwiftUI store and manage state *outside* the struct.

```swift
struct ContentView: View {
    @State private var tapCount = 0

    var body: some View {
        Button("Tap Count: \(tapCount)") {
            tapCount += 1
        }
    }
}
```

#### Why This Works:

* `@State` stores `tapCount` separately from the struct.

* It **survives struct re-creations** that SwiftUI performs when updating views.

* Changes to `@State` trigger the view to re-render automatically.

### Access Control Tip

Since state should be local to the view, Apple recommends marking `@State` properties as `private`:

```swift
@State private var tapCount = 0
```

### Why Not Use Classes?

You might wonder:

> “Why not just use a class? They’re mutable.”

SwiftUI is optimized for **value types (structs)** because:

* Views are frequently recreated for performance

* Structs are lightweight and fast to discard/rebuild

* Keeping state separate ensures **clear, isolated, testable** logic

### Recap

* **State drives views**: UI depends on the program’s current state.

*  You can’t mutate struct properties inside views.

* Use `@State` to create simple, local mutable properties.

* Changes to `@State` trigger view re-rendering automatically.

* Avoid classes unless you have more complex state (you’ll learn alternatives like `@ObservedObject` later).

---

## Text Input & Two-Way Binding in SwiftUI

SwiftUI’s `@State` property wrapper allows views to change their own data over time. When combined with user input controls like `TextField`, things get a bit more advanced — and that’s where **two-way binding** comes in.

### Understanding the Problem

Let’s say we want to let users enter their name. 

You might write this:

```swift
Form {
    TextField("Enter your name")
    Text("Hello, world!")
}
````

### This won’t compile

Why? Because SwiftUI needs to know:

> Where should the text the user types **be stored**?

In SwiftUI, views are a **function of their state**, so for a `TextField` to work, it must reflect a piece of state from your code.

#### Attempt #1 — Add a Property

```swift
var name = ""

TextField("Enter your name", text: name)
```

Still doesn’t work. Why?

Because `name` is **immutable** in a struct by default — SwiftUI can’t write changes back to it.


#### Attempt #2 — Make It a `@State`

```swift
@State private var name = ""

TextField("Enter your name", text: name)
```

Still no luck.

This is because we’re trying to pass a **value** (`name`), but SwiftUI needs a **binding** to both read and write the value.


#### The Real Fix: Two-Way Binding with `$`

```swift
@State private var name = ""

TextField("Enter your name", text: $name)
```

### This works!

* `$name` creates a **two-way binding**.

* SwiftUI can **read** the value and **write** changes back.

* The view stays synced with the state at all times.


### Display the Value

You can read the value like normal, without the `$`:

```swift
Text("Your name is \(name)")
```

This is just reading `name`, so no two-way binding is needed.


### Recap: Two-Way Binding in SwiftUI

| Usage                    | Purpose                                |
| ------------------------ | -------------------------------------- |
| `@State var name`        | Holds a mutable value within the view  |
| `$name`                  | Creates a binding for two-way updates  |
| `TextField(text: $name)` | Lets the user update the state         |
| `Text("\(name)")`        | Displays the current value (read-only) |


### Recap

* Use `@State` to store mutable local view data.

* Use `$` to bind that state to controls like `TextField`.

* Think of `$` as "read/write access" to the variable.

* Remember: views reflect **state**, and bindings **modify state**.

--- 

## Using `ForEach` and `Picker` in SwiftUI

When building SwiftUI views, it's common to create **repeating elements** like text labels, buttons, or images from an array of data. 

For that, SwiftUI gives us the powerful `ForEach` view.


### What is `ForEach`?

`ForEach` is a SwiftUI view that:
- Loops over **arrays**, **ranges**, or **collections**
- Runs a **closure** for each item
- Creates multiple views efficiently and declaratively

#### Basic Example: Loop from 0 to 99

```swift
Form {
    ForEach(0..<100) { number in
        Text("Row \(number)")
    }
}
````

You can even use shorthand syntax for the loop variable due to `closures`:

```swift
ForEach(0..<100) {
    Text("Row \($0)")
}
```

---

### Real-World Example: `Picker` with `ForEach`

We’ll build a form that allows users to pick a student’s name from a list.

#### Full Working Example:

```swift
struct ContentView: View {
    let students = ["Denny", "Hermione", "Elaine"]
    @State private var selectedStudent = "Elaine"

    var body: some View {
        NavigationStack {
            Form {
                Picker("Select your student", selection: $selectedStudent) {
                    ForEach(students, id: \.self) {
                        Text($0)
                    }
                }
            }
        }
    }
}
```


### Explanation

| Line of Code                               | Purpose                               |
| ------------------------------------------ | ------------------------------------- |
| `let students = [...]`                     | Constant array of student names       |
| `@State private var selectedStudent`       | Mutable state to store selected name  |
| `Picker(..., selection: $selectedStudent)` | Dropdown menu that binds to state     |
| `ForEach(students, id: \.self)`            | Creates one `Text` view for each name |
| `Text($0)`                                 | Displays the student’s name           |

### What does `id: \.self` mean?

* SwiftUI must identify each item **uniquely** for tracking and animations.

* When working with an array of `String`, the string itself is the ID.

* If your array contained structs, you'd typically use a property like `.id` or `.name`.

```swift
ForEach(customStructs, id: \.id) { item in
    ...
}
```

### Recap

| Concept      | Explanation                                   |
| ------------ | --------------------------------------------- |
| `ForEach`    | A loop that generates views from a collection |
| `.self`      | Treats the value itself as a unique ID        |
| `@State`     | Stores the selected option                    |
| `Picker`     | View for choosing from multiple values        |
| `$` (dollar) | Makes a two-way binding to update state       |

--- 

## Day 17 – Project 1, part two

### Check Splitter: SwiftUI Basics with `@State` and Form Input

In this project, we're building a **check-splitting app** that lets users:
- Enter the check amount
- Choose how many people are splitting the check
- Select a tip percentage

To achieve this, we leverage SwiftUI’s `@State` for dynamic form input, currency formatting, and keyboard customization.

### 🧠 Step 1: Track User Input with `@State`

We start with three properties that store the user’s input:

```swift
@State private var checkAmount = 0.0
@State private var numberOfPeople = 2
@State private var tipPercentage = 20
````

We also define a constant array of possible tip percentages:

```swift
let tipPercentages = [10, 15, 20, 25, 0]
```

These properties let us track user state and update the UI automatically when they change.

### Step 2: Currency Text Input

We want users to enter a number that represents the total check amount. 

A plain text field won’t work well for numeric input, so we use a specialized initializer that works with numbers and formats the value:

```swift
TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
    .keyboardType(.decimalPad)
```

#### Details:

* `$checkAmount` creates a **two-way binding**, so user input is reflected in the state.

* `format: .currency(...)` ensures we display and accept values in the **correct currency format**.

* `Locale.current.currency?.identifier ?? "USD"` dynamically detects the user’s **preferred currency**, falling back to USD.

---

### Step 3: Reflect State Changes

We can confirm that SwiftUI updates the UI whenever the state changes by showing the current amount in a second section:

```swift
Form {
    Section {
        TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            .keyboardType(.decimalPad)
    }

    Section {
        Text(checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
    }
}
```

When you run the app:

* Typing into the text field **instantly updates** the second `Text` view.

* This is powered by `@State`, which triggers **UI recomposition** when values change.


### Step 4: Customize the Keyboard

Entering monetary amounts requires a decimal-friendly keyboard. You can add this with `.keyboardType(.decimalPad)`.

```swift
.keyboardType(.decimalPad)
```

### Why use `.decimalPad`?

* It gives users access to **numbers and the decimal point**.
* It's cleaner than a full keyboard for number-only input.

> ⚠️ Note: Users with hardware keyboards or copy-paste can still enter invalid data, but SwiftUI automatically filters it upon submission.

### Sample Starting Code

```swift
struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20

    let tipPercentages = [10, 15, 20, 25, 0]

    var body: some View {
        Form {
            Section {
                TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }

            Section {
                Text(checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            }
        }
    }
}
```

### Recap

| Feature                     | Implementation                                |
| --------------------------- | --------------------------------------------- |
| Track input values          | `@State`                                      |
| Update views dynamically    | SwiftUI auto-recomposes with `@State` changes |
| Two-way data binding        | `$propertyName`                               |
| Format text input as money  | `.currency(...)`                              |
| Support multiple currencies | `Locale.current.currency?.identifier`         |
| Use numeric keyboard        | `.keyboardType(.decimalPad)`                  |


---

### Picker Integration: Choosing Number of People in SwiftUI

In this step, we extend the check-splitting app by letting users **choose how many people will share the bill** using a SwiftUI `Picker`.

SwiftUI’s pickers are flexible: they automatically adapt their appearance based on the platform and context (e.g., a dropdown on macOS, a wheel or navigation list on iOS).


#### Step 1: Create a Number Picker

We already declared a `@State` property for tracking the number of people:

```swift
@State private var numberOfPeople = 2
````

We can now add a `Picker` to the form using a `ForEach` loop:

```swift
Section {
    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        .keyboardType(.decimalPad)

    Picker("Number of people", selection: $numberOfPeople) {
        ForEach(2..<100) {
            Text("\($0) people")
        }
    }
}
```

##### Two-way Binding

Just like `TextField`, `Picker` uses `$numberOfPeople` to sync the selected value.

---

##### Why It Says “4 People” Instead of “2 People”

Let’s look at this:

```swift
@State private var numberOfPeople = 2
```

And this:

```swift
ForEach(2..<100)
```

The picker’s list **starts from 2**, and since SwiftUI matches `numberOfPeople` directly, `2` maps to the **index** that shows “2 people.” 

So if `numberOfPeople = 4`, SwiftUI highlights “4 people” correctly.

There’s no bug – the number you use in `@State` must match the value in `ForEach`.


#### Step 2: Use `.pickerStyle(.navigationLink)`

SwiftUI supports multiple picker styles. A common one is `.navigationLink`, which slides in a new screen for choosing options:

```swift
Picker("Number of people", selection: $numberOfPeople) {
    ForEach(2..<100) {
        Text("\($0) people")
    }
}
.pickerStyle(.navigationLink)
```

However, this needs a `NavigationStack`. So wrap the `Form` like this:

```swift
var body: some View {
    NavigationStack {
        Form {
            Section {
                TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)

                Picker("Number of people", selection: $numberOfPeople) {
                    ForEach(2..<100) {
                        Text("\($0) people")
                    }
                }
                .pickerStyle(.navigationLink)
            }
        }
        .navigationTitle("WeSplit")
    }
}
```

##### What This Does:

* Adds a navigation bar with a title.

* Tapping the picker pushes a new screen.

* SwiftUI handles showing all items, marking the selected one, and popping the screen after selection.


### Picker Style Comparison

| Picker Style      | Behavior                                                                |
| ----------------- | ----------------------------------------------------------------------- |
| `.automatic`      | Default: dropdown on iPad, list on iPhone                               |
| `.menu`           | Opens a menu when tapped (good for short lists)                         |
| `.navigationLink` | Pushes a new view for selection (good for longer lists)                 |
| `.wheel`          | Shows a spinning wheel (useful for dates or compact numeric selections) |

You can switch styles based on your UI preferences. For this project, we’ll stick with the default `.automatic` or use `.menu` for simplicity.


### Updated Code (with NavigationStack)

```swift
struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        NavigationStack {
            Form{
                Section{
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of people", selection: $numberOfPeople){
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

```

### Recap

| Feature                    | Implementation                    |
| -------------------------- | --------------------------------- |
| Display a list of options  | `Picker` + `ForEach`              |
| Track selected value       | `@State` + `$binding`             |
| Customize look             | `.pickerStyle(...)`               |
| Enable navigation behavior | Wrap in `NavigationStack`         |
| Show dynamic UI title      | `.navigationTitle(...)` on `Form` |

---

### Tip Selection: Segmented Picker in SwiftUI

We’re improving the check-splitting app by letting users **select a tip percentage** using a segmented control. 

This provides a compact, intuitive UI when you have only a few options.


### Goal

Add a third section to the form where users can choose a **tip percentage**, using a segmented-style `Picker`.

---

#### Step 1: Add a Tip Picker

Our existing form includes two sections:

1. Amount and number of people
2. Final output (currently placeholder)

Now, let’s insert a third `Section` in between:

```swift
Section {
    Picker("Tip percentage", selection: $tipPercentage) {
        ForEach(tipPercentages, id: \.self) {
            Text($0, format: .percent)
        }
    }
}
````

This loops through an array like:

```swift
let tipPercentages = [10, 15, 20, 25, 0]
```

And creates a `Picker` bound to:

```swift
@State private var tipPercentage = 20
```

Each number is shown as a percent label, thanks to:

```swift
Text($0, format: .percent)
```

---

#### Step 2: Use a Segmented Control

To make the picker **more visually appealing**, convert it to a segmented control with:

```swift
.pickerStyle(.segmented)
```

So the updated section becomes:

```swift
Section {
    Picker("Tip percentage", selection: $tipPercentage) {
        ForEach(tipPercentages, id: \.self) {
            Text($0, format: .percent)
        }
    }
    .pickerStyle(.segmented)
}
```

##### Why Segmented?

* Ideal for small, discrete sets of choices.

* Takes up less vertical space.

* Easier to visually compare all options.

#### Step 3: Add Context with a Section Header

At this point, the segmented control works – but to a new user, it might be unclear what the percentages represent.

We can fix that by adding a label above it. Instead of using a loose `Text`, SwiftUI lets us provide a **section header**:

```swift
Section("How much tip do you want to leave?") {
    Picker("Tip percentage", selection: $tipPercentage) {
        ForEach(tipPercentages, id: \.self) {
            Text($0, format: .percent)
        }
    }
    .pickerStyle(.segmented)
}
```

This attaches the question directly to the section and makes the UI more readable and polished.

### Updated Code

```swift
struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        NavigationStack {
            Form{
                Section{
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of people", selection: $numberOfPeople){
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("How much tip do you want to leave"){
                    Picker("Tip Percentage", selection: $tipPercentage){
                        ForEach(tipPercentages, id: \.self){
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Text(checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
```

---

## Recap

| Feature                        | Implementation                       |
| ------------------------------ | ------------------------------------ |
| Display multiple options       | `Picker` + `ForEach`                 |
| Show them as a segmented list  | `.pickerStyle(.segmented)`           |
| Provide context for the picker | `Section("How much tip...") { ... }` |
| Show formatted percentage      | `Text($0, format: .percent)`         |

---

### Total Per Person Calculation

### Goal

- Create a computed property that calculates the **amount per person**.

- Display the result using SwiftUI's currency formatting.

- Ensure the UI **updates automatically** when inputs change.


#### Step 1: Add the Computed Property

Create a new computed property just before your `body`.

This will do the math and return the final value:

```swift
var totalPerPerson: Double {
    // we'll calculate the result here
    return 0
}
````

We'll update this placeholder with the real logic next.

#### Step 2: Prepare Input Values

SwiftUI stores the number of people as an index — if `numberOfPeople = 3`, that corresponds to **5 people** (starting at 2).

Convert it to an actual count:

```swift
let peopleCount = Double(numberOfPeople + 2)
```

Also convert the selected tip:

```swift
let tipSelection = Double(tipPercentage)
```

#### Step 3: Do the Math

Here's the calculation flow:

1. Calculate the **tip value**.

2. Add it to the original amount to get the **grand total**.

3. Divide that by the number of people to get the **per-person amount**.

```swift
let tipValue = checkAmount / 100 * tipSelection
let grandTotal = checkAmount + tipValue
let amountPerPerson = grandTotal / peopleCount

return amountPerPerson
```

Now your `totalPerPerson` property looks like this:

```swift
var totalPerPerson: Double {
    let peopleCount = Double(numberOfPeople + 2)
    let tipSelection = Double(tipPercentage)

    let tipValue = checkAmount / 100 * tipSelection
    let grandTotal = checkAmount + tipValue
    let amountPerPerson = grandTotal / peopleCount

    return amountPerPerson
}
```


#### Step 4: Update the Final Section

We no longer want to show the raw check amount. Replace your bottom `Section` with this:

```swift
Section {
    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
}
```

This uses Swift’s built-in formatting to localize the currency.


### Why This Works

Because all our form inputs (`checkAmount`, `tipPercentage`, `numberOfPeople`) are marked with `@State`, SwiftUI automatically re-evaluates `totalPerPerson` whenever any of them change — and the UI updates instantly.

This showcases **declarative UI design**: we don’t tell SwiftUI *when* to update, we just describe *what* the UI should look like based on the state.



### Final Result

Users can now:

* Enter the bill amount.

* Choose the number of people.

* Select a tip percentage.

And immediately see the amount each person should pay.


## Updated Code

```swift
struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson:Double{
        
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationStack {
            Form{
                Section{
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of people", selection: $numberOfPeople){
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("How much tip do you want to leave"){
                    Picker("Tip Percentage", selection: $tipPercentage){
                        ForEach(tipPercentages, id: \.self){
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

```

### Recap

| Feature                   | Implementation                       |
| ------------------------- | ------------------------------------ |
| Derived value             | `var totalPerPerson: Double { ... }` |
| Handles tip + people math | Manual calculation logic             |
| Displays formatted result | `.currency(code: ...)`               |
| Updates automatically     | Thanks to `@State` reactivity        |

---

### Dismissing the Keyboard

One last detail to polish our app!  
When the keyboard appears for the **check amount**, there’s **no way to dismiss it** — especially on decimal/number keypads that don’t have a return key.

Let’s fix that so users have a smooth experience.


###  What We’ll Do

1. Track focus on the amount input using `@FocusState`.

2. Show a **"Done"** button when the keyboard is active.

3. Tapping “Done” will dismiss the keyboard by removing focus.


#### Step 1: Add `@FocusState`

Just like `@State`, SwiftUI gives us `@FocusState` to track input focus.

Add this to your `ContentView`:

```swift
@FocusState private var amountIsFocused: Bool
````


#### Step 2: Attach Focus to the TextField

Next, attach this state to your check amount field using `.focused()`:

```swift
TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
    .keyboardType(.decimalPad)
    .focused($amountIsFocused)
```

Now SwiftUI knows whether the field is active.


#### Step 3: Add a Toolbar Button

We’ll show a **"Done"** button when the keyboard is visible. Add this below `.navigationTitle(...)`:

```swift
.toolbar {
    if amountIsFocused {
        Button("Done") {
            amountIsFocused = false
        }
    }
}
```

### Breakdown:

| Code                     | Purpose                                                         |
| ------------------------ | --------------------------------------------------------------- |
| `.toolbar { ... }`       | Adds a toolbar to the view.                                     |
| `if amountIsFocused`     | Only shows the button when the text field is active.            |
| `Button("Done") { ... }` | Tapping the button removes focus, which dismisses the keyboard. |



### Final Code Updated

```swift
struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson:Double{
        
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationStack {
            Form{
                Section{
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople){
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("How much tip do you want to leave"){
                    Picker("Tip Percentage", selection: $tipPercentage){
                        ForEach(tipPercentages, id: \.self){
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                if amountIsFocused{
                    Button("Done"){
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}
```


### What I Learned

| Concept                    | Description                        |
| -------------------------- | ---------------------------------- |
| `@State`                   | Stores reactive UI state           |
| `@FocusState`              | Tracks and controls keyboard focus |
| `TextField`, `Picker`      | Forms and input in SwiftUI         |
| `.pickerStyle(.segmented)` | Customizing control appearance     |
| Computed properties        | Clean logic for dynamic values     |
| `.toolbar`                 | Adding actions to the UI           |

---

## Day 18 – Project 1, part three

### Challenge

To solidify your understanding of SwiftUI, this project includes a set of **self-directed coding challenges**. 

Each challenge extends the base functionality of the app using concepts you've learned so far.

#### Challenge Tasks

1. **Add a header** to the section that displays how much each person should pay.

2. **Show the total check amount** (including tip, but not split per person).

3. **Upgrade the tip selection UI**:

   * Replace the segmented control with a **navigation-style picker**.
   
   * Expand the range from **0% to 100%** (use `0..<101` instead of a fixed array).

#### Challenge Solution Highlights

All three tasks have been implemented in the final version of the app:

##### 1. Section Header

A new section with the header `"Amount per person"` was added:

```swift
Section("Amount per person") {
    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
}
```

##### 2. Total Check Amount Section

A computed property `totalCheckAmount` was introduced, and a new section displays this total:

```swift
var totalCheckAmount: Double {
    let tipSelection = Double(tipPercentage)
    let tipValue = checkAmount / 100 * tipSelection
    return checkAmount + tipValue
}

Section("Total Check Amount") {
    Text(totalCheckAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
}
```

##### 3. Improved Tip Picker

The segmented control was replaced with a `.navigationLink` style picker that allows users to select any tip between 0% and 100%:

```swift
Section("How much tip do you want to leave") {
    Picker("Tip Percentage", selection: $tipPercentage) {
        ForEach(0..<101) {
            Text($0, format: .percent)
        }
    }
    .pickerStyle(.navigationLink)
}
```


##### Why These Changes Matter

These challenges help reinforce core SwiftUI skills:

* Using **computed properties** to separate logic from UI.
* Creating **dynamic UI** with `ForEach` and flexible ranges.
* Improving **user experience** through thoughtful UI design.

#### Final Project 1 Solution
```swift
//
//  ContentView.swift
//  WeSplit
//
//  Created by D F on 6/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson:Double{
        
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    
    var totalCheckAmount:Double{
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    
    var body: some View {
        NavigationStack {
            Form{
                Section{
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople){
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.menu)
                }
                
//                Section("How much tip do you want to leave"){
//                    Picker("Tip Percentage", selection: $tipPercentage){
//                        ForEach(tipPercentages, id: \.self){
//                            Text($0, format: .percent)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                }
                
                Section("How much tip do you want to leave"){
                    Picker("Tip Percentage", selection: $tipPercentage){
                        ForEach(0..<101){
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section("Amount per person") {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
                Section("Total Check Amount") {
                    Text(totalCheckAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }

            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                if amountIsFocused{
                    Button("Done"){
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
```
