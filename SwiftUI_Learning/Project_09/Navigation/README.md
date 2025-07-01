# Navigation Summary

---

## Day 43 – Project 9, part one

---

## Understanding NavigationLink Initialization in SwiftUI

### Overview

When learning SwiftUI, it's common to use `NavigationLink` directly like this:

```swift
NavigationStack {
    NavigationLink("Tap Me") {
        Text("Detail View")
    }
}
```

This works well for simple cases. However, there's a hidden performance issue when using `NavigationLink` with more complex views or large datasets.

### The Problem

Consider this example where we log the creation of a detail view:

```swift
struct DetailView: View {
    var number: Int

    var body: some View {
        Text("Detail View \(number)")
    }

    init(number: Int) {
        self.number = number
        print("Creating detail view \(number)")
    }
}

NavigationStack {
    NavigationLink("Tap Me") {
        DetailView(number: 556)
    }
}
```

Even if you **don’t** tap the navigation link, SwiftUI still prints `"Creating detail view 556"`. That’s because the detail view is being **instantiated immediately**, not lazily.

#### Scaling Issue

Now imagine this pattern inside a list of 1,000 items:

```swift
NavigationStack {
    List(0..<1000) { i in
        NavigationLink("Tap Me") {
            DetailView(number: i)
        }
    }
}
```

SwiftUI starts creating many `DetailView` instances **just while scrolling**, which leads to **unnecessary performance overhead**.

### The Better Way

For dynamic data and scalable UI, SwiftUI provides a more efficient pattern using **navigation destination modifiers** and **data-driven presentation**.

> 💡 Instead of creating views inside the `NavigationLink`, you attach a value to the link and handle presentation elsewhere. This ensures views are created **only when needed**, improving performance.

---

## SwiftUI Advanced Navigation with `navigationDestination`

### Overview

In simple SwiftUI apps, navigation often looks like this:

```swift
NavigationStack {
    NavigationLink("Tap Me") {
        Text("Detail View")
    }
}
```

While this works for basic use cases, **it's not efficient or scalable** for larger datasets or dynamic content. Fortunately, SwiftUI provides a better approach using **value-based navigation** with `navigationDestination()`.


### Why Use Value-Based Navigation?

By **separating the destination from the `NavigationLink`**, SwiftUI can:

* Defer loading of views until they are actually needed.
* Improve performance, especially in lists with many elements.
* Support cleaner, more reusable navigation code.


### Step-by-Step: How It Works

#### Step 1: Use a Value with `NavigationLink`

Attach a value to your navigation link:

```swift
NavigationLink("Select \(i)", value: i)
```

> The value must conform to the `Hashable` protocol — luckily, most built-in types like `Int`, `String`, and `UUID` already do.

#### Step 2: Define the Destination with `navigationDestination()`

Use the `.navigationDestination()` modifier to define what view should be shown for that type:

```swift
.navigationDestination(for: Int.self) { selection in
    Text("You selected \(selection)")
}
```

This allows SwiftUI to create the destination **only when the link is tapped**.


### Example: Efficient List Navigation

```swift
NavigationStack {
    List(0..<100) { i in
        NavigationLink("Select \(i)", value: i)
    }
    .navigationDestination(for: Int.self) { selection in
        Text("You selected \(selection)")
    }
}
```

SwiftUI now only builds the destination view **on demand**, avoiding unnecessary view creation.


### Working with Custom Types

To use custom data types, ensure they conform to `Hashable`:

```swift
struct Student: Hashable {
    var id = UUID()
    var name: String
    var age: Int
}
```

You can now use `Student` just like a built-in type in `NavigationLink` and `navigationDestination()`.


### 💡 Bonus Tips

* You can add **multiple** `.navigationDestination()` modifiers — one for each type you want to handle.
* Swift’s `Hashable` protocol is used heavily in sets, dictionaries, and now navigation.
* For custom structs, if all properties are `Hashable`, your type can easily conform with just `: Hashable`.


### Recap

Value-based navigation in SwiftUI:

* Optimizes performance.
* Scales better for dynamic content.
* Makes navigation logic cleaner and more flexible.

Use `NavigationLink(value:)` and `.navigationDestination(for:)` for modern, efficient SwiftUI navigation.

---

## Day 44 – Project 9, part two

---


## SwiftUI Programmatic Navigation with `NavigationStack`

### Overview

SwiftUI supports **programmatic navigation**, allowing your app to move between views using code — not just user interactions. This is helpful when you want to navigate automatically after processing data, completing 
animations, or reacting to state changes.


### Why Use Programmatic Navigation?

Programmatic navigation is ideal when:

* Navigation should occur automatically (e.g., after an API call or form submission).
* You need precise control over the navigation stack.
* You want to simulate multi-step navigation based on app logic.

### Core Concept

Programmatic navigation is achieved by:

1. Creating a `@State` variable to manage the navigation **path**.
2. Binding that variable to a `NavigationStack`.
3. Modifying the path programmatically to push or pop views.

### Example Setup

```swift
struct ContentView: View {
    @State private var path = [Int]() // Step 1

    var body: some View {
        NavigationStack(path: $path) { // Step 2
            VStack {
                // Step 3: UI triggering programmatic navigation
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
            }
        }
    }
}
```

### Triggering Navigation with Code

Here are three ways to control navigation programmatically:

```swift
Button("Show 32") {
    path = [32] // Replaces current path with 32
}

Button("Show 64") {
    path.append(64) // Appends 64 to current stack
}

Button("Show 32 then 64") {
    path = [32, 64] // Pushes both 32 and 64 in sequence
}
```

* Setting the path replaces the entire stack (except root).
* Appending adds to the current navigation stack.
* Multiple values create multi-step navigation.

### How It Works

* SwiftUI watches the `path` array and automatically **navigates** as it changes.
* When the user taps the **Back** button, SwiftUI updates the `path` array to match.
* You can **mix programmatic and user navigation freely**, and SwiftUI will keep everything in sync.


## Recap

Programmatic navigation in SwiftUI offers:

* Full control over navigation logic
* Automatic syncing between user and code-driven navigation
* Support for complex flows and multi-step transitions

To implement it:

* Bind a `@State` path array to a `NavigationStack`
* Push/pop items programmatically
* Use `.navigationDestination()` to define what to show

---


## Navigating to Multiple Data Types in SwiftUI

### Overview

SwiftUI makes it easy to navigate to different data types using `.navigationDestination()` — whether it’s a number, a string, or a custom type.

You can handle multiple data types:

* Without tracking the navigation path manually
* Or **programmatically** by using `NavigationPath`

### Navigating Without Path Tracking

When you don’t need to programmatically navigate or track the full path, simply attach multiple `.navigationDestination()` modifiers — one per data type:

```swift
NavigationStack {
    List {
        ForEach(0..<5) { i in
            NavigationLink("Select Number: \(i)", value: i)
        }

        ForEach(0..<5) { i in
            NavigationLink("Select String: \(i)", value: String(i))
        }
    }
    .navigationDestination(for: Int.self) { selection in
        Text("You selected the number \(selection)")
    }
    .navigationDestination(for: String.self) { selection in
        Text("You selected the string \(selection)")
    }
}
```

✅ SwiftUI will automatically route to the correct destination based on the value’s type.


### When You Need Programmatic Navigation

If you want to **programmatically push different types**, a regular array won’t work (it can only hold one type).
Instead, use SwiftUI’s type-erased navigation tool: `NavigationPath`.

#### Step 1: Declare the Path

```swift
@State private var path = NavigationPath()
```

#### Step 2: Bind It to Your `NavigationStack`

```swift
NavigationStack(path: $path) {
    // Your content here
}
```

#### Step 3: Push Values Programmatically

```swift
.toolbar {
    Button("Push 556") {
        path.append(556)
    }

    Button("Push Hello") {
        path.append("Hello")
    }
}
```

Now SwiftUI can push **any kind of `Hashable` type** using the same path.


### Handling Destinations

You still need to tell SwiftUI how to present each type:

```swift
.navigationDestination(for: Int.self) { selection in
    Text("You selected the number \(selection)")
}
.navigationDestination(for: String.self) { selection in
    Text("You selected the string \(selection)")
}
```


### What Is `NavigationPath`?

`NavigationPath` is a **type-erased container** that holds any number of `Hashable` values. It works similarly to an array but supports different types in a single navigation stack.

> Think of it as a flexible path manager that hides the exact data types while keeping navigation logic clean and powerful.

### Recap

SwiftUI supports navigation across multiple data types using:

* `.navigationDestination(for:)` for simple, type-based routing
* `NavigationPath` for advanced programmatic navigation

With these tools, your app can:

* Push numbers, strings, custom types, or any `Hashable` data
* Mix user-driven and programmatic navigation
* Maintain clean and scalable navigation logic

---


## Returning to the Root in SwiftUI NavigationStack

### Overview

In SwiftUI, it’s common to let users navigate through several levels of a `NavigationStack` — for example, during a multi-step checkout flow. But once the process is complete, you may want to return all the way back to the 
**root view** programmatically.

This guide demonstrates how to:

* Push new views dynamically using random data
* Reset navigation to the root
* Pass navigation control using `@Binding`

### Dynamic View Navigation

Here’s a `DetailView` that pushes to a new random number each time:

```swift
struct DetailView: View {
    var number: Int

    var body: some View {
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
    }
}
```

And the root `ContentView`:

```swift
struct ContentView: View {
    @State private var path = [Int]()

    var body: some View {
        NavigationStack(path: $path) {
            DetailView(number: 0)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i)
                }
        }
    }
}
```

This setup allows you to **push views infinitely**, each showing a new number.


### Returning to the Root

If you're deep in the stack and want to go back:

#### If you're using an array (`[Int]`):

```swift
path.removeAll()
```

#### If you're using `NavigationPath`:

```swift
path = NavigationPath()
```

### The Challenge: Triggering Reset from Deep Inside

You can't directly access the `@State` property (`path`) from deep inside the stack.
To fix that, pass it into child views using `@Binding`.

#### Update `DetailView` to Accept a Binding:

```swift
struct DetailView: View {
    var number: Int
    @Binding var path: [Int]

    var body: some View {
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
            .toolbar {
                Button("Home") {
                    path.removeAll()
                }
            }
    }
}
```

#### Pass `$path` from `ContentView`:

```swift
DetailView(number: 0, path: $path)
    .navigationDestination(for: Int.self) { i in
        DetailView(number: i, path: $path)
    }
```

> 💡 Use `$path` to pass the **binding**, enabling `DetailView` to update the shared navigation path.


### Alternative: Using `NavigationPath`

If you're using `NavigationPath` instead of `[Int]`, the same logic applies — just reset with:

```swift
path = NavigationPath()
```

### Why Use `@Binding`?

The `@Binding` property wrapper:

* Allows a child view to **read and write** a parent’s `@State`
* Keeps values **in sync** across multiple views
* Is the same mechanism used in `TextField`, `Stepper`, and other SwiftUI components


### Recap

To return to the root in SwiftUI:

* Use `path.removeAll()` or `path = NavigationPath()` depending on your navigation type.
* Use `@Binding` to **pass the navigation control down** into deeply nested views.
* Combine with toolbars or logic triggers to programmatically reset navigation.

This approach provides clean, flexible navigation flows — perfect for multi-step processes, wizards, or onboarding screens.

---

## Persisting Navigation Stack State in SwiftUI

### Overview

SwiftUI allows you to **save and restore your navigation path**, so users return exactly where they left off — even after quitting and relaunching the app.

You can do this with:

* A homogenous array (e.g. `[Int]`, `[String]`)
* Or a flexible, type-erased `NavigationPath`

Both can be persisted using `Codable` with a helper class that automatically handles saving and loading.

### Saving a Simple `[Int]` Navigation Path

Create a class that observes the path and saves it on change:

```swift
@Observable
class PathStore {
    var path: [Int] {
        didSet { save() }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath),
           let decoded = try? JSONDecoder().decode([Int].self, from: data) {
            path = decoded
            return
        }

        path = []
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(path)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}
```

### Saving a `NavigationPath`

To persist a `NavigationPath`, make four small changes:

1. Change the property type:

   ```swift
   var path: NavigationPath { didSet { save() } }
   ```

2. Decode using `NavigationPath.CodableRepresentation`:

   ```swift
   if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
       path = NavigationPath(decoded)
       return
   }
   ```

3. Fallback to an empty path:

   ```swift
   path = NavigationPath()
   ```

4. Encode using the `.codable` computed property:

   ```swift
   guard let representation = path.codable else { return }
   let data = try JSONEncoder().encode(representation)
   ```

#### Full `PathStore` with `NavigationPath`:

```swift
@Observable
class PathStore {
    var path: NavigationPath {
        didSet { save() }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath),
           let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
            path = NavigationPath(decoded)
            return
        }

        path = NavigationPath()
    }

    func save() {
        guard let representation = path.codable else { return }

        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}
```

### Example Usage in SwiftUI

Here's how to bind your `NavigationStack` to the path from `PathStore`:

```swift
struct DetailView: View {
    var number: Int

    var body: some View {
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
    }
}

struct ContentView: View {
    @State private var pathStore = PathStore()

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailView(number: 0)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i)
                }
        }
    }
}
```

Now when the app is relaunched, the navigation stack restores to exactly where the user left off.


## Recap

Persisting the navigation path in SwiftUI:

| Technique           | Best For                 | Codable Support  | Notes                              |
| ------------------- | ------------------------ | ---------------- | ---------------------------------- |
| `[Int]`, `[String]` | Homogeneous, simple data | ✅                | Fast and straightforward           |
| `NavigationPath`    | Mixed types, flexible    | ✅ via `.codable` | Requires fallback and type-erasure |

Both approaches give users a seamless experience — great for restoring complex navigation flows or multi-step progress.

---

## Day 45 – Project 9, part three

---


## Styling the Navigation Bar in SwiftUI

### Overview

While iOS has strong opinions about how navigation bars should look, SwiftUI gives you a few options to **customize the appearance** of your navigation bars — including size, background color, color scheme, and visibility.


### Set Navigation Title Style

You can toggle between **large** and **inline** title styles using `.navigationBarTitleDisplayMode()`:

```swift
NavigationStack {
    List(0..<100) { i in
        Text("Row \(i)")
    }
    .navigationTitle("Title goes here")
    .navigationBarTitleDisplayMode(.inline) // Small title style
}
```

* `.inline` gives a small title.
* `.large` (default) gives a prominent title that collapses when scrolling.

### Change Navigation Bar Background

By default, the navigation bar background becomes visible only **after scrolling**. You can customize its color using `.toolbarBackground()`:

```swift
.toolbarBackground(.blue)
```

Now when the list scrolls under the navigation bar, it appears with a **blue background**.

> 📌 Note: The background only appears when scrolled — not initially.


### Control Color Scheme

The default title text may become unreadable, especially in light mode with dark backgrounds. Force a color scheme using `.toolbarColorScheme()`:

```swift
.toolbarColorScheme(.dark)
```

This makes text appear in **white** by forcing a dark color scheme on the toolbar.

### Target Navigation Bar Specifically

To apply these only to the navigation bar:

```swift
.toolbarBackground(.blue, for: .navigationBar)
.toolbarColorScheme(.dark, for: .navigationBar)
```

### Hide the Navigation Bar

You can also hide the navigation bar using the `.toolbar()` modifier:

```swift
.toolbar(.hidden, for: .navigationBar)
```

* Hides the bar completely.
* Navigation still works, but you must handle layout carefully — especially for scrollable content (watch for system overlays like the clock).

### Recap

SwiftUI gives you limited but effective tools for styling navigation bars:

| Feature                 | Modifier                                 | Notes                                |
| ----------------------- | ---------------------------------------- | ------------------------------------ |
| Title size              | `.navigationBarTitleDisplayMode()`       | Use `.inline` or `.large`            |
| Background color        | `.toolbarBackground(Color)`              | Visible only after scroll            |
| Color scheme            | `.toolbarColorScheme(.dark/.light)`      | Affects text contrast                |
| Target specific toolbar | Add `for: .navigationBar`                | Apply only to navigation bar         |
| Hide navigation bar     | `.toolbar(.hidden, for: .navigationBar)` | Removes bar; watch for layout issues |

---

## Customizing Toolbars in SwiftUI

### Overview

In SwiftUI, toolbars are a powerful way to add buttons and actions to your views — especially when using `NavigationStack`. SwiftUI places these buttons automatically based on platform conventions, but you can customize 
them using `ToolbarItem` and `ToolbarItemGroup`.

### Default Toolbar Placement

If you add buttons directly in a `.toolbar`, SwiftUI will automatically place them in the **top-right corner** (for left-to-right languages like English):

```swift
.toolbar {
    Button("Tap Me") {
        // action
    }
}
```

### Custom Placement with `ToolbarItem`

You can override the automatic placement using `ToolbarItem`, specifying exactly where a button should appear. For example:

```swift
.toolbar {
    ToolbarItem(placement: .topBarLeading) {
        Button("Tap Me") {
            // action
        }
    }
}
```

This places the button on the **top-left** side of the navigation bar.

### Use Semantic Placements

Prefer semantic placements over positional ones. These communicate *meaning* to the system and adapt across platforms (iOS, macOS, watchOS, etc.):

| Placement             | Use When…                                         |
| --------------------- | ------------------------------------------------- |
| `.confirmationAction` | User agrees to something (e.g. "Save", "Agree")   |
| `.destructiveAction`  | User deletes or removes data                      |
| `.cancellationAction` | User cancels or discards changes                  |
| `.navigation`         | User navigates back or forward (e.g. web-like UI) |

**Example:**

```swift
.toolbar {
    ToolbarItem(placement: .confirmationAction) {
        Button("Save") {
            // save action
        }
    }
}
```

Benefits:

* iOS may style buttons (e.g. bold for confirmation).
* Works consistently across Apple platforms.


### Disable Back Navigation

To prevent the user from backing out without making a decision, use:

```swift
.navigationBarBackButtonHidden()
```

Combine this with semantic actions to enforce a decision flow (e.g. Save vs. Cancel).


### Add Multiple Buttons

#### Option 1: Repeat `ToolbarItem`

```swift
.toolbar {
    ToolbarItem(placement: .topBarLeading) {
        Button("One") { }
    }
    ToolbarItem(placement: .topBarLeading) {
        Button("Two") { }
    }
}
```

#### Option 2: Use `ToolbarItemGroup`

```swift
.toolbar {
    ToolbarItemGroup(placement: .topBarLeading) {
        Button("One") { }
        Button("Two") { }
    }
}
```

Both produce the same visual result, but `ToolbarItemGroup` is cleaner for grouping multiple related actions.

### Recap

SwiftUI's `toolbar` system provides flexible, semantic, and platform-aware tools for adding interface buttons:

| Feature           | Method                             | Notes                                       |
| ----------------- | ---------------------------------- | ------------------------------------------- |
| Default placement | `.toolbar { Button }`              | Top-right on iOS                            |
| Custom position   | `ToolbarItem(placement:)`          | e.g. `.topBarLeading` for left-side buttons |
| Semantic intent   | `.confirmationAction` etc.         | Enhances styling and cross-platform support |
| Hide back button  | `.navigationBarBackButtonHidden()` | Prevents premature view dismissal           |
| Multiple buttons  | `ToolbarItemGroup` or repeat       | Use groups for cleaner layout               |

---

## Dynamic and Editable Navigation Titles in SwiftUI

### Basic Navigation Titles

In SwiftUI, you can display a title in the navigation bar using the `.navigationTitle()` modifier:

```swift
NavigationStack {
    Text("Hello, world!")
        .navigationTitle("SwiftUI")
}
```

This sets a **static** title in the navigation bar.


### Editable Titles with a Binding

If you’re using `.inline` display mode, you can make the title editable directly in the navigation bar by **passing a `@State` variable with `$` (a `Binding`)**.

```swift
struct ContentView: View {
    @State private var title = "SwiftUI"

    var body: some View {
        NavigationStack {
            Text("Hello, world!")
                .navigationTitle($title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
```

#### What happens:

* iOS displays a **small arrow** next to the title.
* When tapped, a **"Rename"** option appears.
* Selecting it lets the user **edit the title in place**, without needing a `TextField` in your UI.

### When to Use

Editable titles are ideal when:

* The title reflects user-generated content (e.g. document names, folder names, notes).
* You want a clean interface without adding an extra text input.
* You want a native-feeling editing experience that aligns with system design.

### Important Notes

| Requirement            | Explanation                                                                            |
| ---------------------- | -------------------------------------------------------------------------------------- |
| `.inline` display mode | Editable titles only appear in `.inline` mode, not `.large`.                           |
| `@State` + `Binding`   | You must pass a `$`-wrapped binding, like `$title`, not a hardcoded string.            |
| iOS-only behavior      | This rename feature is iOS-specific and may not behave identically on other platforms. |


### Recap

| Feature                   | How to Implement                            | Benefit                   |
| ------------------------- | ------------------------------------------- | ------------------------- |
| Static navigation title   | `.navigationTitle("My Title")`              | Displays a fixed title    |
| Editable navigation title | `.navigationTitle($title)` + `.inline` mode | User can rename in place  |
| Best for                  | Notes, documents, folders, tasks, and more  | Clean, native, dynamic UX |

---

## Challenge 

### iExpense – Challenge Summaries & Solutions

#### Challenge 1: Replace Sheet with NavigationLink

**Goal:**  
Replace the `.sheet` presentation used for adding a new expense with a `NavigationLink`, and ensure users must explicitly choose Cancel to back out (instead of using the system back button).

**Solution:**
- Removed `.sheet(isPresented:)` and replaced it with a `NavigationLink` in the toolbar.
- Embedded the form for adding a new expense inside a `NavigationStack`.
- Used `.navigationBarBackButtonHidden()` to prevent users from navigating back using the default Back button.
- Added a Cancel button using `.toolbar` with `.cancellationAction` to dismiss manually.

```swift
.toolbar {
    NavigationLink(destination: AddView(expenses: expenses)) {
        Label("Add Expenses", systemImage: "plus")
    }
}
````

```swift
.navigationBarBackButtonHidden()
.toolbar {
    ToolbarItem(placement: .cancellationAction) {
        Button("Cancel") {
            dismiss()
        }
    }
}
```

---

#### Challenge 2: Editable Navigation Title

**Goal:**
Allow users to edit the expense name by tapping the navigation bar title directly, instead of using a separate text field.

**Solution:**

* Removed the section containing the name `TextField`.
* Replaced the fixed title with a binding to a `@State` variable using `.navigationTitle($name)`.
* Required `.navigationBarTitleDisplayMode(.inline)` to enable inline title editing UI.

```swift
@State private var name = "New Expense"

.navigationTitle($name)
.navigationBarTitleDisplayMode(.inline)
```

With this setup, the title shows a chevron arrow. When tapped, users can rename the expense inline without needing a separate input field.

### Overall Improvements

* The UI feels more structured and native by integrating with SwiftUI’s `NavigationStack`.
* Replacing modals with navigation pushes improves UX consistency.
* Making the title editable adds a modern, context-aware interaction pattern.


### Moonshot Challenge 3

#### Summary

This challenge focused on modernizing navigation in the Moonshot app by switching from the classic `NavigationLink(destination:)` initializer to the more flexible `NavigationLink(value:)` combined with 
`.navigationDestination()`.

#### What Was Done

- **Mission Conformance:** Updated the `Mission` struct and its nested `CrewRole` to conform to `Hashable`, enabling use as a navigation value.
- **Value-based Navigation:** Replaced closure-based `NavigationLink` calls in both grid and list layouts with `NavigationLink(value:)`, passing the `Mission` object as the navigation value.
- **Centralized Navigation Destination:** Moved the destination view creation (`MissionView`) into a single `.navigationDestination(for: Mission.self)` modifier attached to the `NavigationStack` in `ContentView`.
- **Layout Switching:** Implemented a toolbar button in `ContentView` to toggle between grid and list layouts, both supporting the new navigation style seamlessly.
- **Clean Code Structure:** Kept the `GridLayoutView` and `ListLayoutView` responsible for UI only, with navigation logic centralized in the parent view.

**GridLayoutView**

```swift
                    NavigationLink(value: missionViewModel.mission) {
                        VStack {
                            Image(missionViewModel.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                                
                            VStack {
                                Text(missionViewModel.displayName)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text(missionViewModel.formattedLaunchDate)
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.lightBackground)
                        }
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightBackground)
                        )
                        .padding(.bottom, 10)
                    }

```
 
**ListLayoutView**

```swift
                    NavigationLink(value: missionViewModel.mission) {
                        HStack {
                            Image(missionViewModel.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                            
                            VStack {
                                Text(missionViewModel.displayName)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text(missionViewModel.formattedLaunchDate)
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.lightBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .listRowBackground(Color.darkBackground)
                }
```
**Mission Model**

```swift

struct Mission: Codable, Identifiable, Hashable {
    
    struct CrewRole: Codable, Hashable {
        let name: String
        let role: String
    }
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
}

```

**ContentView**

```swift
            Group{
                if showingGrid{
                    GridLayoutView(missions: missionViewModels, astronauts: astronauts)
                        .navigationDestination(for: Mission.self) { mission in
                            MissionView(mission: mission, astronauts: astronauts)
                        }
                }else{
                    ListLayoutView(missions: missionViewModels, astronauts: astronauts)
                        .navigationDestination(for: Mission.self) { mission in
                            MissionView(mission: mission, astronauts: astronauts)
                        }
                }
            }

```
