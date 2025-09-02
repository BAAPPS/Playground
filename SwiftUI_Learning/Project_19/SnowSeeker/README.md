# SnowSeeker Summary
---

## Day 96: Project 19, Part One

---

Introduced `NavigationSplitView` for building adaptive multi-column navigation in SwiftUI, especially suited for iPad and multitasking scenarios.

## NavigationSplitView in SwiftUI

### Why NavigationSplitView?
SwiftUI’s `NavigationStack` and `NavigationView` work well on iPhone, but they aren’t ideal on iPad where the larger screen makes full-width navigation transitions feel clunky.  
`NavigationSplitView` solves this by allowing **two or three columns** of data to be shown side by side, with iPadOS automatically adapting the layout depending on screen size, orientation, and multitasking.

### Basic Usage
```swift
NavigationSplitView {
    Text("Primary")
} detail: {
    Text("Content")
}
````

* **iPhone:** Shows only the primary view.
* **iPad (landscape):** Sidebar with Primary + Content.
* **iPad (portrait):** Content fills the screen.

iPadOS adds:

1. A toggle button to show/hide the primary view.
2. Automatic layout adjustments in multitasking mode.

### Automatic Linking

Navigation links in the **primary view** automatically load their content into the **secondary view**:

```swift
NavigationSplitView {
    NavigationLink("Primary") {
        Text("New view")
    }
} detail: {
    Text("Content")
}
```

### Customization Options

#### Column Visibility

Force all columns to stay visible:

```swift
NavigationSplitView(columnVisibility: .constant(.all)) {
    NavigationLink("Primary") {
        Text("New view")
    }
} detail: {
    Text("Content")
        .navigationTitle("Content View")
}
.navigationSplitViewStyle(.balanced)
```

> Tip: `columnVisibility` is a binding, so it can be stored in state and updated dynamically.

#### Preferred Compact Column

Prefer the **detail view** when space is constrained (useful on iPhone):

```swift
NavigationSplitView(preferredCompactColumn: .constant(.detail)) {
    ...
}
```

#### Toolbar Behavior

You can hide toolbars with:

```swift
.toolbar(.hidden, for: .navigationBar)
```

⚠️ Be careful: this will also hide the **sidebar toggle button**.

### Three-Column Layout

`NavigationSplitView` supports a **third view** for sidebar navigation:

* First view → controls the second.
* Second view → controls the third.

This is the same pattern used in apps like **Notes** for folders → lists → detail content.


---

## Alerts and Sheets in SwiftUI

### Two Ways to Present Alerts and Sheets
SwiftUI provides **two main approaches** for presenting alerts and sheets:

1. **Boolean Binding**  
   A simple `@State Bool` that toggles presentation when set to `true`.  

2. **Optional Identifiable Binding**  
   A more flexible approach using an **optional Identifiable object**.  
   - Presentation occurs when the optional has a value.  
   - SwiftUI automatically resets the optional to `nil` when dismissed.  
   - The closure provides a non-optional instance for safe use.  

### Using an Identifiable with Sheets
Define a trivial `User` struct:
```swift
struct User: Identifiable {
    var id = "Taylor Swift"
}
````

Track selection in your view:

```swift
@State private var selectedUser: User? = nil
```

Update the state and present the sheet:

```swift
Button("Tap Me") {
    selectedUser = User()
}
.sheet(item: $selectedUser) { user in
    Text(user.id)
}
```

* Tapping the button sets `selectedUser`.
* Sheet displays `"Taylor Swift"`.
* When dismissed, SwiftUI resets `selectedUser` to `nil`.

### Using an Identifiable with Alerts

Alerts require **both a Boolean and an optional Identifiable**.

Track the Boolean:

```swift
@State private var isShowingUser = false
```

Toggle inside the button action:

```swift
isShowingUser = true
```

Present the alert:

```swift
.alert("Welcome", isPresented: $isShowingUser, presenting: selectedUser) { user in
    Button(user.id) { }
}
```

* Boolean controls presentation.
* `selectedUser` is passed safely into the alert closure.

### Presentation Detents

Sheets can use **detents** to control size.
This allows sheets to take up partial screen space instead of always being full screen.

Example:

```swift
Text(selectedUser.id)
    .presentationDetents([.medium, .large])
```

* Starts at `.medium`.
* Users can drag up to `.large` using a grab handle.


## Summary

* **Booleans** → simple show/hide control.
* **Optionals with Identifiable** → safer, more flexible, automatically reset.
* **Alerts** can use both a Boolean and an Identifiable.
* **Sheets** support presentation detents for adaptive sizing.

---

## Group and Adaptive Layouts in SwiftUI

### What is Group?
SwiftUI’s `Group` view:
- Does **not** affect layout directly.  
- Acts as a **transparent container** for grouping multiple views.  
- Lets you apply **modifiers to multiple views** at once.  
- Allows you to return multiple views without needing `@ViewBuilder`.  

Example:
```swift
struct UserView: View {
    var body: some View {
        Group {
            Text("Name: Paul")
            Text("Country: England")
            Text("Pets: Luna and Arya")
        }
        .font(.title)
    }
}
````

Here, the font modifier applies to all three `Text` views, but the parent decides the layout (vertical, horizontal, etc.).

### Flexible Layout Example

Use `Group` inside a button that toggles between `VStack` and `HStack`:

```swift
struct ContentView: View {
    @State private var layoutVertically = false

    var body: some View {
        Button {
            layoutVertically.toggle()
        } label: {
            if layoutVertically {
                VStack {
                    UserView()
                }
            } else {
                HStack {
                    UserView()
                }
            }
        }
    }
}
```

* Tap the button → switch between vertical and horizontal layouts.
* Common in adaptive UI design for multiple device sizes.

### Size Classes

Apple provides **size classes** to help with adaptive layouts:

* Horizontal: `.compact` or `.regular`
* Vertical: `.compact` or `.regular`

Example:

```swift
struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        if horizontalSizeClass == .compact {
            VStack {
                UserView()
            }
        } else {
            HStack {
                UserView()
            }
        }
    }
}
```

Shorter version:

```swift
if horizontalSizeClass == .compact {
    VStack(content: UserView.init)
} else {
    HStack(content: UserView.init)
}
```

💡 Example:

* iPhone 15 Pro → compact horizontal in both portrait & landscape.
* iPhone 15 Pro Max → regular horizontal in landscape.


### ViewThatFits

For even simpler adaptive layouts, use `ViewThatFits`.
It tries multiple layouts in order, showing the first one that fits.

Example:

```swift
ViewThatFits {
    Rectangle()
        .frame(width: 500, height: 200)

    Circle()
        .frame(width: 200, height: 200)
}
```

* Attempts to display the `Rectangle`.
* If it doesn’t fit, falls back to the `Circle`.
* Preserves **view state** across layout changes.


## Summary

* **Group** is a transparent container for grouping multiple views without affecting layout.
* Layout is determined by the **parent** (e.g., `VStack`, `HStack`).
* **Size classes** let you adapt UIs for compact vs. regular screen widths/heights.
* **ViewThatFits** provides automatic fallback layouts for responsive design.

---

## Adding Search in SwiftUI with `searchable()`

### The `searchable()` Modifier
SwiftUI allows you to add a **search bar** to your views with the `.searchable()` modifier.  
- Bind it to a `@State String` to capture user input.  
- Works best when the view is inside a `NavigationStack`.  

Example:
```swift
struct ContentView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            Text("Searching for \(searchText)")
                .searchable(text: $searchText, prompt: "Look for something")
                .navigationTitle("Searching")
        }
    }
}
````

⚠️ Without `NavigationStack`, iOS won’t have anywhere to place the search bar.

### Filtering Data with Search

A common use case is filtering a dataset as the user types.

Example:

```swift
struct ContentView: View {
    @State private var searchText = ""
    let allNames = ["Subh", "Vina", "Melvin", "Stefanie"]

    var filteredNames: [String] {
        if searchText.isEmpty {
            allNames
        } else {
            allNames.filter { $0.localizedStandardContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredNames, id: \.self) { name in
                Text(name)
            }
            .searchable(text: $searchText, prompt: "Look for something")
            .navigationTitle("Searching")
        }
    }
}
```

### iOS Behavior

* On lists, the search bar might be **hidden at first**.
* Pull down gently to reveal it (just like Mail or Messages).
* Search results update **dynamically** as the user types.

---

### Best Practices

* Use `localizedStandardContains()` for filtering:

  * Ignores case sensitivity.
  * Handles accents (e.g., `"café"` matches `"cafe"`).

## Summary

* `.searchable()` easily adds a **search bar** to SwiftUI views.
* Must be inside a `NavigationStack`.
* Combine with computed properties to filter datasets dynamically.
* `localizedStandardContains()` ensures user-friendly search results.

---

## Sharing Data with @Observable and @Environment in SwiftUI

### When to Use @Environment
- `@State` and `@Observable` make it easy to manage data in local views.  
- But if the **same object needs to be shared across many views**, manually passing it down becomes tedious.  
- Solution: Place the object into the **environment** and retrieve it with `@Environment`.  

### Step 1: Create an Observable Object
Define a class using the `@Observable` macro:
```swift
@Observable
class Player {
    var name = "Anonymous"
    var highScore = 0
}
````

### Step 2: Local Usage with @State

Passing values directly:

```swift
struct HighScoreView: View {
    var player: Player

    var body: some View {
        Text("Your high score: \(player.highScore)")
    }
}

struct ContentView: View {
    @State private var player = Player()

    var body: some View {
        VStack {
            Text("Welcome!")
            HighScoreView(player: player)
        }
    }
}
```

✅ Works, but becomes repetitive if many views need `player`.


### Step 3: Place Object in the Environment

Instead of passing directly, inject into the environment:

```swift
VStack {
    Text("Welcome!")
    HighScoreView()
}
.environment(player)
```

> ⚠️ Works only for classes using `@Observable`.
> The macro automatically makes the type conform to `Observable` (protocol), which `environment()` requires.

### Step 4: Read Object from the Environment

In the child view:

```swift
struct HighScoreView: View {
    @Environment(Player.self) var player

    var body: some View {
        Text("Your high score: \(player.highScore)")
    }
}
```

* Automatically updates when `player` changes.
* ⚠️ Crashes if the environment object isn’t provided.


### Binding Problem with @Environment

Trying to bind directly doesn’t work:

```swift
struct HighScoreView: View {
    @Environment(Player.self) var player

    var body: some View {
        Stepper("High score: \(player.highScore)", value: $player.highScore) // ❌
    }
}
```

This fails because environment values cannot be bound directly.


### Apple’s Workaround: @Bindable

Inside the body, create a local `@Bindable` wrapper:

```swift
struct HighScoreView: View {
    @Environment(Player.self) var player

    var body: some View {
        @Bindable var player = player
        Stepper("High score: \(player.highScore)", value: $player.highScore)
    }
}
```

* Provides binding support for environment values.
* A bit clunky, but necessary (at least on iOS 17).


## Summary

* Use `@Observable` + `@Environment` for **shared app-wide state**.
* Inject with `.environment()` and access with `@Environment`.
* ⚠️ Direct bindings to environment values don’t work.
* Use `@Bindable` inside the body as a workaround.

---

## Day 97 – Project 19, part two

---

## SnowSeeker App

This project demonstrates how to build a split-view app in SwiftUI, similar to Apple’s Mail and Notes apps. We’ll display a list of ski resorts in a primary view, and when a resort is tapped, details will appear in a secondary view.

### Data Model

We define a `Resort` struct to represent ski resort data:

```swift
struct Resort: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var country: String
    var description: String
    var imageCredit: String
    var price: Int
    var size: Int
    var snowDepth: Int
    var elevation: Int
    var runs: Int
    var facilities: [String]
}
````

#### Example Data

* Resorts are loaded from **`resorts.json`** in the app bundle.
* The `Bundle-Decodable` extension is used to decode JSON into Swift types.
* Example static properties are provided for previews and testing:

```swift
static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
static let example = allResorts[0]
```

### Bundle-Decodable Extension

A reusable extension to decode JSON files from the app bundle:

```swift
extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Failed to decode \(file): \(error.localizedDescription)")
        }
    }
}
```

### Current UI

The app uses a **NavigationSplitView** with a list of resorts:

```swift
NavigationSplitView {
    List(resorts) { resort in
        NavigationLink(value: resort) {
            HStack {
                Image(resort.country)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 25)
                    .clipShape(.rect(cornerRadius: 5))
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1))

                VStack(alignment: .leading) {
                    Text(resort.name).font(.headline)
                    Text("\(resort.runs) runs").foregroundStyle(.secondary)
                }
            }
        }
    }
    .navigationTitle("Resorts")
} detail: {
    Text("Detail")
}
```
---

## Handling the Initial Detail View

When using `NavigationSplitView`, the detail view typically shows information about a selection from the sidebar. However, when the app first launches, there may not be a selection yet.  

- **iPhone**: Only the sidebar is visible, so this isn’t an issue.  
- **iPad**: The detail view may appear by default, depending on orientation, leaving users with a blank screen.

### Solution: WelcomeView

Create a simple SwiftUI view to guide users when the app first launches:

```swift
struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)
            Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundStyle(.secondary)
        }
    }
}
````

* This view contains static instructions for users.
* It is displayed in the detail view only until a resort is selected.

### Integration

Replace the previous placeholder in `ContentView`:

```swift
detail: {
    WelcomeView()
}
```

Now the app provides a clear starting point for users, regardless of device or orientation.

* Test on iPhone and iPad in both portrait and landscape to see how the interface adapts automatically.

---

## Adding Resort Details

So far, our `NavigationLink` only navigated to a placeholder. Now we build a full **ResortView** that displays detailed information about each ski resort.

### ResortView

The `ResortView` shows:

- Resort image
- Description text
- List of facilities
- Navigation title with resort name and country

```swift
struct ResortView: View {
    let resort: Resort

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()

                HStack {
                    ResortDetailsView(resort: resort)
                    SkiDetailsView(resort: resort)
                }
                .padding(.vertical)
                .background(.primary.opacity(0.1))

                Group {
                    Text(resort.description)
                        .padding(.vertical)

                    Text("Facilities")
                        .font(.headline)

                    Text(resort.facilities, format: .list(type: .and))
                        .padding(.vertical)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ResortView(resort: .example)
}

````

* Facilities are now formatted naturally using `.list(type: .and)` instead of `joined(separator:)`.

### SkiDetailsView

Displays ski-specific information:

* Elevation in meters
* Snow depth in centimeters

```swift
struct SkiDetailsView: View {
    let resort: Resort

    var body: some View {
        Group {
            VStack {
                Text("Elevation").font(.caption.bold())
                Text("\(resort.elevation)m").font(.title3)
            }
            VStack {
                Text("Snow").font(.caption.bold())
                Text("\(resort.snowDepth)cm").font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
```

### ResortDetailsView

Displays resort size and price:

* Size: `"Small"`, `"Average"`, `"Large"` (mapped from numeric value)
* Price: `$`, `$$`, `$$$` (mapped from numeric value)

```swift
struct ResortDetailsView: View {
    let resort: Resort

    var size: String {
        switch resort.size {
        case 1: "Small"
        case 2: "Average"
        default: "Large"
        }
    }

    var price: String {
        String(repeating: "$", count: resort.price)
    }

    var body: some View {
        Group {
            VStack {
                Text("Size").font(.caption.bold())
                Text(size).font(.title3)
            }
            VStack {
                Text("Price").font(.caption.bold())
                Text(price).font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
```

### Navigation Integration

Update `ContentView` to navigate to `ResortView`:

```swift
.navigationDestination(for: Resort.self) { resort in
    ResortView(resort: resort)
}
```

Now tapping a resort in the sidebar shows the full details, including resort information, ski statistics, and a readable list of facilities.

---

## Day 98 – Project 19, part three

---

## Adding Search Functionality

To improve user experience, we add a **search bar** to filter the list of resorts using SwiftUI’s `.searchable()` modifier.

### Steps to Implement Search

1. **Add a State Property**

Create a new `@State` property in `ContentView` to store the search text:

```swift
@State private var searchText = ""
````

2. **Bind Search to the List**

Attach the `.searchable()` modifier to your `List`:

```swift
.searchable(text: $searchText, prompt: "Search for a resort")
```

3. **Filter Resorts**

Create a computed property to filter resorts based on the search text:

```swift
var filteredResorts: [Resort] {
    if searchText.isEmpty {
        resorts
    } else {
        resorts.filter { $0.name.localizedStandardContains(searchText) }
    }
}
```

4. **Use Filtered Data**

Update the `List` to use the filtered resorts:

```swift
List(filteredResorts) { resort in
    NavigationLink(value: resort) {
        // Your row content here
    }
}
```

### Result

* Users can pull down the list to reveal the search box.
* Typing in the search bar filters the resorts in real time.
* This adds a powerful, high-impact feature with minimal code using SwiftUI.

---

## Adaptive Layout with Size Classes and Dynamic Type

To make the resort details layout more flexible, we use **SwiftUI environment values** to detect the current size class and adjust our layout accordingly.

### Problem

Currently, `ResortDetailsView` and `SkiDetailsView` are placed in a horizontal `HStack`:

```swift
HStack {
    ResortDetailsView(resort: resort)
    SkiDetailsView(resort: resort)
}
````

* Works well with plenty of horizontal space.
* On compact screens (iPhone portrait, split-screen iPad) this layout can feel cramped.
* We want to switch to a 2×2 vertical layout when space is limited.

### Using Horizontal Size Class

Add an environment property to `ResortView`:

```swift
@Environment(\.horizontalSizeClass) var horizontalSizeClass
```

* `.compact` → limited horizontal space
* `.regular` → plenty of horizontal space

Replace the `HStack` with a conditional layout:

```swift
HStack {
    if horizontalSizeClass == .compact {
        VStack(spacing: 10) { ResortDetailsView(resort: resort) }
        VStack(spacing: 10) { SkiDetailsView(resort: resort) }
    } else {
        ResortDetailsView(resort: resort)
        SkiDetailsView(resort: resort)
    }
}
.padding(.vertical)
.background(.primary.opacity(0.1))
```

* Compact width → two vertical stacks side by side
* Regular width → single horizontal line

### Combining with Dynamic Type

We can also adapt the layout to **Dynamic Type sizes**:

```swift
@Environment(\.dynamicTypeSize) var dynamicTypeSize

if horizontalSizeClass == .compact && dynamicTypeSize > .large {
    VStack(spacing: 10) { ResortDetailsView(resort: resort) }
    VStack(spacing: 10) { SkiDetailsView(resort: resort) }
} else {
    ResortDetailsView(resort: resort)
    SkiDetailsView(resort: resort)
}
```

* Ensures the layout adapts if the user has enlarged text for accessibility.
* Keeps horizontal layout when space allows.

### Limiting Dynamic Type Sizes (Optional)

If very large text sizes break the layout, you can restrict the maximum size:

```swift
.dynamicTypeSize(...DynamicTypeSize.xxxLarge)
```

* Allows text up to `.xxxLarge` while preventing excessive scaling.
* Useful for views that cannot gracefully expand indefinitely.

### Summary

* Child views (`ResortDetailsView` and `SkiDetailsView`) remain **layout-neutral**.
* Parent view decides whether to use `HStack` or `VStack` based on size class and dynamic type.
* No code duplication, fully adaptive across devices, orientations, and accessibility settings.

---

## Facility Icons with Alerts

Instead of showing resort facilities as plain text, we enhance the UI by displaying **interactive icons**. Tapping an icon presents an alert describing that facility.

### Facility Model

Create a `Facility` struct to map facility names to SF Symbols and store descriptions:

```swift
struct Facility: Identifiable {
    let id = UUID()
    var name: String

    private let icons = [
        "Accommodation": "house",
        "Beginners": "1.circle",
        "Cross-country": "map",
        "Eco-friendly": "leaf.arrow.circlepath",
        "Family": "person.3"
    ]

    private let descriptions = [
        "Accommodation": "This resort has popular on-site accommodation.",
        "Beginners": "This resort has lots of ski schools.",
        "Cross-country": "This resort has many cross-country ski routes.",
        "Eco-friendly": "This resort has won an award for environmental friendliness.",
        "Family": "This resort is popular with families."
    ]

    var icon: some View {
        if let iconName = icons[name] {
            Image(systemName: iconName)
                .accessibilityLabel(name)
                .foregroundStyle(.secondary)
        } else {
            fatalError("Unknown facility type: \(name)")
        }
    }

    var description: String {
        if let message = descriptions[name] {
            message
        } else {
            fatalError("Unknown facility type: \(name)")
        }
    }
}
````

### Generating Facility Instances

Inside the `Resort` struct, add a computed property:

```swift
var facilityTypes: [Facility] {
    facilities.map(Facility.init)
}
```

### Displaying Icons in ResortView

Replace the previous text list with an icon-based layout:

```swift
HStack {
    ForEach(resort.facilityTypes) { facility in
        facility.icon
            .font(.title)
    }
}
.padding(.vertical)
```

### Adding Alerts

Make each facility icon tappable to show an alert:

```swift
@State private var selectedFacility: Facility?
@State private var showingFacility = false

HStack {
    ForEach(resort.facilityTypes) { facility in
        Button {
            selectedFacility = facility
            showingFacility = true
        } label: {
            facility.icon
                .font(.title)
        }
    }
}
```

Attach the optional alert to `ResortView`:

```swift
.alert(selectedFacility?.name ?? "More information", 
       isPresented: $showingFacility, 
       presenting: selectedFacility) { _ in
} message: { facility in
    Text(facility.description)
}
```

* The alert title uses `selectedFacility?.name ?? "More information"` to safely handle the optional.
* The message closure reads the unwrapped facility’s description.
* No custom buttons are needed; the system provides a default **OK** button.

### Result

* Users see facility icons instead of text.
* Tapping an icon shows a descriptive alert.
* Fully accessible with VoiceOver via `accessibilityLabel()`.

---

## Adding Favorites

The final feature allows users to **mark resorts as favorites**, with persistence using `UserDefaults`.

### Favorites Model

Create a new `Favorites` class:

```swift
@Observable
class Favorites {
    private var resorts: Set<String>  // stores resort IDs
    private let key = "Favorites"

    init() {
        // load saved favorites or start with empty set
        resorts = []
    }

    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }

    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }

    func save() {
        // write resorts to UserDefaults
    }
}
````

* `Set` ensures uniqueness of favorites.
* All modifications call `save()` to persist changes.

### Injecting Favorites into the Environment

1. Add a `Favorites` instance to `ContentView`:

```swift
@State private var favorites = Favorites()
```

2. Inject it into the environment for all views:

```swift
NavigationSplitView {
    ...
}
.environment(favorites)
```

3. Access it in any view (e.g., `ResortView`):

```swift
@Environment(Favorites.self) var favorites
```

### Adding Favorite Button

Add a button at the bottom of `ResortView`’s scroll view:

```swift
Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
    if favorites.contains(resort) {
        favorites.remove(resort)
    } else {
        favorites.add(resort)
    }
}
.buttonStyle(.borderedProminent)
.padding()
```

* Updates the favorites set and persists changes automatically.

### Displaying Favorite Icon

In `ContentView`, show a heart icon next to favorite resorts:

```swift
if favorites.contains(resort) {
    Spacer()
    Image(systemName: "heart.fill")
        .accessibilityLabel("This is a favorite resort")
        .foregroundStyle(.red)
}
```

* Uses SF Symbols and `foregroundStyle()` for styling.
* Gives users visual feedback on which resorts are favorited.

### Result

* Users can **add/remove favorites** from each resort detail view.
* Favorite resorts are **marked with a red heart** in the list.
* Changes persist across app launches using `UserDefaults`.

---

## Day 99 – Project 19, part four

---

## Challenge 2 Solution

### 1️⃣ Add a photo credit over the ResortView image

In `ResortView.swift`, overlay a small text at the bottom-right corner of the image:

```swift
Image(decorative: vm.resort.id)
    .resizable()
    .scaledToFit()
    .overlay(
        Text("Photo: \(vm.resort.imageCredit)")
            .font(.caption2)
            .padding(4)
            .background(Color.black.opacity(0.6))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(6),
        alignment: .bottomTrailing
    )
```

* Uses `overlay` to place the credit text.
* Semi-transparent background ensures readability.
* `alignment: .bottomTrailing` positions it neatly in the corner.

### 2️⃣ Fill in the loading and saving methods for Favorites

Here’s the fully reactive `FavoritesVM` that automatically saves whenever favorites change:

```swift
import SwiftUI

@Observable
class FavoritesVM {
    private var resorts: Set<String> {
        didSet { save() }
    }
    
    private let key = "Favorites"
    
    init() {
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            resorts = Set(saved)
        } else {
            resorts = []
        }
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
    }
    
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
    }
    
    private func save() {
        let array = Array(resorts)
        UserDefaults.standard.set(array, forKey: key)
    }
}
```

* No need to call `save()` manually; `didSet` handles it.
* Works seamlessly with `@Environment(FavoritesVM.self)` in `ResortView` and `ContentView`.

### 3️⃣ Allow the user to sort resorts in ContentView

#### ResortSearchVM already handles search & sorting

```swift
@Observable
class ResortSearchVM {
    let resorts: [Resort]
    
    var searchText: String = ""
    var sortOrder: SortOrder = .defaultOrder
    
    enum SortOrder: String, CaseIterable, Identifiable {
        case defaultOrder = "Default"
        case alphabetical = "Alphabetical"
        case country = "Country"
        
        var id: String { rawValue }
    }
    
    init(resorts: [Resort]) {
        self.resorts = resorts
    }
    
    var filteredResorts: [Resort] {
        var result: [Resort]
        
        if searchText.isEmpty {
            result = resorts
        } else {
            result = resorts.filter { $0.name.localizedStandardContains(searchText) }
        }
        
        switch sortOrder {
        case .alphabetical:
            result.sort { $0.name < $1.name }
        case .country:
            result.sort { $0.country < $1.country }
        case .defaultOrder:
            break
        }
        
        return result
    }
}
```

* All filtering and sorting logic lives in the VM.
* `@Observable` ensures SwiftUI views automatically update when `searchText` or `sortOrder` changes.

####  Update ContentView to use the VM

Add a `Picker` for sorting and update the list dynamically:


```swift
struct ContentView: View {
    @State private var favorites = FavoritesVM()
    @State private var searchVM = ResortSearchVM(resorts: Bundle.main.decode("resorts.json"))

    var body: some View {
        NavigationSplitView {
            VStack {
                // Sort order picker
                Picker("Sort by", selection: $searchVM.sortOrder) {
                    ForEach(ResortSearchVM.SortOrder.allCases) { order in
                        Text(order.rawValue).tag(order)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Resort list
                List(searchVM.filteredResorts) { resort in
                    NavigationLink(value: resort) {
                        HStack {
                            Image(resort.country)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 25)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1))

                            VStack(alignment: .leading) {
                                Text(resort.name).font(.headline)
                                Text("\(resort.runs) runs").foregroundStyle(.secondary)
                            }

                            if favorites.contains(resort) {
                                Spacer()
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.red)
                                    .accessibilityLabel("This is a favorite resort")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self) { resort in
                ResortView()
                    .environment(ResortVM(resort: resort))
            }
            .searchable(text: $searchVM.searchText, prompt: "Search for a resort")
        } detail: {
            WelcomeView()
        }
        .environment(favorites)
    }
}
```

* `Picker` allows choosing sort order: default, alphabetical, or by country.
* The resorts list updates automatically when the user changes the sort order.

