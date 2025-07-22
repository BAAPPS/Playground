# BucketList Summary

---

## Day 68 – Project 14, part one

---

## Making Custom Types Comparable in Swift

### Overview

Swift makes a lot of functionality feel effortless. For example, expressions like `4 < 5` and `[1, 5, 3].sorted()` work out of the box thanks to built-in protocol conformances and the power of `Comparable`.

This ease extends to SwiftUI. When we build a list of integers, Swift knows how to sort and display them. But what happens when we want to sort custom types, like a `User` struct? By default, Swift doesn’t know how to sort them — unless we explicitly teach it how.

### The Problem

Given a `User` struct like this:

```swift
struct User: Identifiable {
    let id = UUID()
    var firstName: String
    var lastName: String
}
```

We can easily use it in a SwiftUI `List` because it conforms to `Identifiable`. However, calling `.sorted()` on an array of `User` instances fails — Swift doesn’t know *how* to sort them (e.g., by `firstName`, `lastName`, etc.).

You could sort with a closure:

```swift
users.sorted { $0.lastName < $1.lastName }
```

But this approach:

1. Mixes model logic into the view layer.
2. Leads to duplicated, hard-to-maintain sorting logic.

### The Swift Way: Conforming to `Comparable`

To cleanly enable `.sorted()` without parameters, conform your custom type to `Comparable`:

```swift
struct User: Identifiable, Comparable {
    let id = UUID()
    var firstName: String
    var lastName: String

    static func <(lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
}
```

This gives you:

* Cleaner views.
* Centralized, reusable sorting logic.
* Automatic support for both `<` and `>`.

### Key Concepts

* **Comparable Protocol**: Enables automatic sorting by defining the `<` operator.
* **Static Method**: The `<` method must be static and return a `Bool`.
* **Operator Overloading**: Adds custom behavior to existing operators like `<`.
* **lhs/rhs**: Conventions for "left-hand side" and "right-hand side" in comparisons.
* **Clean Architecture**: Keeps sorting logic in the model, not duplicated in the view.

### Final Result

Now this works seamlessly:

```swift
let users = [
    User(firstName: "Arnold", lastName: "Rimmer"),
    User(firstName: "Kristine", lastName: "Kochanski"),
    User(firstName: "David", lastName: "Lister")
].sorted()
```

Swift understands how to compare and sort your custom type — just like it does with integers.

---

## Reading and Writing Files in iOS

### Overview

Previously, we explored using **UserDefaults** for storing small data and **SwiftData** for managing complex relationships. In this project, we’re taking a middle-ground approach: saving data directly to files in the device’s storage.

This is a common and powerful technique for apps where data isn’t too complex but also doesn’t fit in UserDefaults. It’s efficient, flexible, and fully under your control.

### Why Not UserDefaults or SwiftData?

* **UserDefaults**: Great for simple settings, but not suitable for unbounded data.
* **SwiftData**: Excellent for complex relationships, but may be overkill for simpler needs.

**File writing** is a solid, scalable alternative – especially when you just need to store or retrieve raw data.

### The Documents Directory

Every iOS app gets a *sandboxed* file system — meaning it can only read/write inside its own container. That includes a **Documents** directory, ideal for storing user-generated content.

You can access it using:

```swift
print(URL.documentsDirectory)
```

> ✅ Bonus: This folder is automatically backed up with iCloud and deleted when the app is removed.

### Writing Data to Files

You can write data using `write(to:options:)`, and it’s recommended to use:

* `.atomic`: Ensures the entire file is written at once, avoiding partial reads.
* `.completeFileProtection`: Encrypts the file and restricts access to unlocked devices.

**Example:**

```swift
Button("Read and Write") {
    let data = Data("Test Message".utf8)
    let url = URL.documentsDirectory.appending(path: "message.txt")

    do {
        try data.write(to: url, options: [.atomic, .completeFileProtection])
        let input = try String(contentsOf: url)
        print(input)
    } catch {
        print(error.localizedDescription)
    }
}
```

Tapping the button writes `"Test Message"` to disk and reads it back, confirming the file I/O cycle.

### Recap

* Apps have full access to their **Documents directory**.
* Use `Data.write(to:)` and `String(contentsOf:)` for I/O.
* Use `.atomic` and `.completeFileProtection` for safety and security.
* This approach is ideal when you want more control than UserDefaults, without the overhead of a full database.

---

## Managing View State with Enums in SwiftUI

### Overview

In SwiftUI, it's common to show different views based on app state. While simple conditions like this work:

```swift
if Bool.random() {
    Rectangle()
} else {
    Circle()
}
```

A more scalable approach involves using enums to manage multiple states in a clean, maintainable way — ideal as your app grows in complexity.


### Why Use Enums for View State?

Using `if` statements works for simple scenarios, but when dealing with multiple UI states (e.g., loading, success, failure), enums provide:

* Better structure
* Cleaner code
* Compiler-enforced safety
* Easier expansion in the future


#### Step 1: Define a View State Enum

Start by creating an enum to represent your various states:

```swift
enum LoadingState {
    case loading, success, failed
}
```

This acts as a source of truth for your UI flow.

#### Step 2: Create Views for Each State

Build small, focused views for each case:

```swift
struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}
```

These can be reused or customized independently.

#### Step 3: Use the Enum in `ContentView`

Track the current state with a `@State` property:

```swift
@State private var loadingState = LoadingState.loading
```

Then render the appropriate view conditionally:

##### Option 1 – `if` / `else if`

```swift
if loadingState == .loading {
    LoadingView()
} else if loadingState == .success {
    SuccessView()
} else if loadingState == .failed {
    FailedView()
}
```

##### Option 2 – `switch` (recommended)

```swift
switch loadingState {
case .loading:
    LoadingView()
case .success:
    SuccessView()
case .failed:
    FailedView()
}
```

> ✅ **Tip**: Using `switch` ensures all enum cases are handled — Swift will alert you if one is missing!


### Benefits

* Encourages separation of concerns between UI and state
* Keeps `ContentView` clean and focused
* Makes it easy to add new states in the future
* Enables reuse of views elsewhere

## Recap

Enums and view composition are powerful tools in SwiftUI. By modeling your app’s state explicitly, you create a robust, scalable UI architecture that’s easier to read, test, and extend.

This is a key step in learning to **think in SwiftUI**.

---

## Day 69 – Project 14, part two

---

##  Working with Maps in SwiftUI

### Overview

Maps have been part of iOS since day one, and with **MapKit** and **SwiftUI's `Map` view**, it's easier than ever to integrate maps into your app. SwiftUI lets you display maps, customize styles, add annotations, track user interaction, and more – all while maintaining declarative UI structure.

#### Step 1: Showing a Simple Map

To start, import `MapKit` and place a map in your view:

```swift
import MapKit

Map()
```

### Simulator Tips:

* **⌥ Option** = Pinch
* **⌥ Option + ⇧ Shift** = Pan
* **Tap + drag** = Zoom

#### Step 2: Customizing Map Style

Control the appearance with `.mapStyle()`:

```swift
Map().mapStyle(.imagery)               // Satellite
Map().mapStyle(.hybrid)               // Satellite + streets
Map().mapStyle(.hybrid(elevation: .realistic)) // 3D terrain
```

#### Step 3: Controlling Interaction

Adjust how users interact with the map:

```swift
Map(interactionModes: [.zoom, .rotate]) // Allow zoom and rotation
Map(interactionModes: [])               // Disable all interaction
```

#### Step 4: Setting and Tracking Map Position

You can set a **fixed camera position** or use `@State` to track and update the camera dynamically.

##### Initial Position:

```swift
let position = MapCameraPosition.region(
    MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    )
)

Map(initialPosition: position)
```

##### Dynamic Binding:

```swift
@State private var position = /* same value */

Map(position: $position)
```

### Add Buttons to Jump to Locations:

```swift
HStack {
    Button("Paris") { position = /* Paris region */ }
    Button("Tokyo") { position = /* Tokyo region */ }
}
```

##### Tracking Position Changes:

```swift
Map(position: $position)
    .onMapCameraChange { context in
        print(context.region) // Print on change end
    }

Map(position: $position)
    .onMapCameraChange(frequency: .continuous) { context in
        print(context.region) // Print continuously
    }
```

#### Step 5: Adding Map Annotations

Define a model for locations:

```swift
struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

let locations = [
    Location(name: "Buckingham Palace", coordinate: /* ... */),
    Location(name: "Tower of London", coordinate: /* ... */)
]
```

##### Add Markers:

```swift
Map {
    ForEach(locations) { location in
        Marker(location.name, coordinate: location.coordinate)
    }
}
```

##### Custom Annotations:

```swift
Annotation(location.name, coordinate: location.coordinate) {
    Text(location.name)
        .font(.headline)
        .padding()
        .background(.blue)
        .foregroundStyle(.white)
        .clipShape(.capsule)
}
.annotationTitles(.hidden)
```

#### Step 6: Handling Map Taps

To convert tap positions into coordinates, use `MapReader`:

```swift
MapReader { proxy in
    Map()
        .onTapGesture { position in
            if let coordinate = proxy.convert(position, from: .local) {
                print(coordinate)
            }
        }
}
```

> 🔍 `.local` means the tap is relative to the top-left of the map view.

### Recap

* `Map` in SwiftUI makes adding interactive maps easy and intuitive.
* You can:

  * Customize map style and interaction
  * Set and track position
  * Place markers and custom annotations
  * Handle user taps and convert them to coordinates
* This offers a powerful foundation for building location-aware apps in SwiftUI.

---

## Biometric Authentication with SwiftUI (Updated)

### Overview

This function uses Apple’s biometric authentication (Face ID or Touch ID) to unlock app content. It includes a special bypass for the simulator to avoid crashes and simplify testing.

### How It Works

```swift
/// Handles biometric authentication using Face ID or Touch ID.
/// Automatically bypasses authentication on the simulator for smoother testing.
/// On success, sets `isUnlocked` to true on the main thread.
func authenticate() {
    let context = LAContext()
    var error: NSError?

    #if targetEnvironment(simulator)
    // Bypass biometric auth in simulator
    isUnlocked = true
    #else
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        let reason = "We need to unlock your data."
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            if success {
                DispatchQueue.main.async {
                    isUnlocked = true
                }
            }
        }
    }
    #endif
}
```

### Why This Setup?

* **Simulator bypass:**
  Biometric APIs can cause crashes or fail silently on the iOS Simulator because biometric hardware isn't present. To prevent this, the function sets `isUnlocked = true` immediately when running in the simulator, allowing smooth development and testing without biometrics.

* **Main thread updates:**
  The authentication callback runs on a background thread. Because SwiftUI’s `@State` properties like `isUnlocked` must be modified on the **main thread**, the update is dispatched asynchronously to the main queue.

* **Check capability before authenticating:**
  The call to `canEvaluatePolicy` ensures biometrics are available and configured before attempting authentication, preventing errors on unsupported devices.

---

## Day 70 – Project 14, part three

---

## Interactive Map with Custom Locations

### Overview

This project lets users **add custom locations to a map** — places they want to visit. It starts with a full-screen map centered on the UK, and lets users tap to drop new pins. We'll also structure our data using a custom 
`Location` type to track name, coordinates, and more.


### Step 1: Import MapKit

At the top of your `ContentView.swift`:

```swift
import MapKit
```

### Step 2: Set the Starting Map Position

Add this property to control the initial map region:

```swift
let startPosition = MapCameraPosition.region(
    MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 56, longitude: -3), // Centered on the UK
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
)
```

### Step 3: Basic Map View

To display the full-screen map:

```swift
Map(initialPosition: startPosition)
```

> 💡 Try changing the map style using `.mapStyle(.hybrid)` or `.mapStyle(.imagery)`.


### Step 4: Add Tap Gesture Support

Wrap the `Map` inside a `MapReader` to convert tap positions into map coordinates:

```swift
MapReader { proxy in
    Map(initialPosition: startPosition)
        .onTapGesture { position in
            if let coordinate = proxy.convert(position, from: .local) {
                print("Tapped at \(coordinate)")
            }
        }
}
```

> ⚠️ Use tap gestures carefully — they are less accessible than buttons.

### Step 5: Create the Location Model

Create a new file `Location.swift` and add:

```swift
struct Location: Codable, Equatable, Identifiable {
    let id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
}
```

> ✅ `Identifiable` lets us use `ForEach`
> ✅ `Codable` enables saving/loading
> ✅ `Equatable` allows easy comparison

### Step 6: Add Location Data to ContentView

Inside `ContentView`, add a state array for storing locations:

```swift
@State private var locations = [Location]()
```

### Step 7: Append Locations on Map Tap

Update the tap gesture to create and store a new location:

```swift
if let coordinate = proxy.convert(position, from: .local) {
    let newLocation = Location(
        id: UUID(),
        name: "New location",
        description: "",
        latitude: coordinate.latitude,
        longitude: coordinate.longitude
    )
    locations.append(newLocation)
}
```

### Step 8: Display Location Markers on the Map

Update the `Map` view to use dynamic markers:

```swift
Map(initialPosition: startPosition) {
    ForEach(locations) { location in
        Marker(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
    }
}
```

### Result

✅ You now have a fully interactive map.
📍 Users can tap anywhere to drop new location pins.
🌐 Locations are stored dynamically and rendered in real-time.


### Recap

You’ve now built a dynamic map interface in SwiftUI using:

* `MapReader` to convert taps to coordinates
* A `Location` struct for storing places
* `@State` to manage the list of locations
* `Marker` views to show pins on the map

This forms the **core of a travel planning or custom geolocation app**, with future enhancements including saving data, editing details, and showing detailed place views.

---

## Custom Annotations & Location Struct Refinements

### Overview

Now that we can place pins on a map, it’s time to **enhance them visually** using fully custom SwiftUI views — not just system markers. We’ll also clean up our `Location` struct to make it more powerful, reusable, and 
efficient.


### Step 1: Replace `Marker` with `Annotation`

Instead of using the default marker, switch to a custom view using `Annotation`:

```swift
Annotation(location.name, coordinate: location.coordinate) {
    Image(systemName: "star.circle")
        .resizable()
        .foregroundStyle(.red)
        .frame(width: 44, height: 44)
        .background(.white)
        .clipShape(.circle)
}
```

> 🎯 This makes your pins **visually distinct and fully customizable**.

### Step 2: Simplify Location Coordinates with a Computed Property

Update `Location.swift` to include a computed property that creates the coordinate:

```swift
import MapKit

struct Location: Codable, Equatable, Identifiable {
    // existing properties...
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
```

Now, in `ContentView`, replace:

```swift
CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
```

with the cleaner:

```swift
location.coordinate
```

> 🧼 Keeps your UI code **cleaner and more readable**.

### Step 3: Add Example Data for Previews

Inside `Location.swift`, add an example static property to simplify previews:

```swift
static let example = Location(
    id: UUID(),
    name: "Buckingham Palace",
    description: "Lit by over 40,000 lightbulbs.",
    latitude: 51.501,
    longitude: -0.141
)
```

> 🧪 Great for SwiftUI Previews
> 🛡️ Wrap it in `#if DEBUG` if you want to exclude it from production builds:

```swift
#if DEBUG
static let example = ...
#endif
```

### Step 4: Optimize the Equality Comparison

Swift synthesizes `==` by checking all properties, which is unnecessary here.
Instead, add a custom `==` that compares only the `id`:

```swift
static func ==(lhs: Location, rhs: Location) -> Bool {
    lhs.id == rhs.id
}
```

> ⚡ This is **faster and cleaner**, since each location is uniquely identified by its UUID.

### Final Result

✅ You now have **custom SwiftUI annotations**
✅ Your `Location` struct is **simplified and optimized**
✅ You’ve improved **previewing and performance** for free

### Recap

We’ve upgraded both the **appearance** of map pins and the **design** of the underlying data model. These changes:

* Make your app more flexible
* Improve maintainability
* Set the stage for previews and editing later

You should now see a **star icon marker** at each tapped location — fully styled and fully dynamic, backed by a lean, clean data structure.

---

## Editable Locations with Sheets and Map Annotations

### Overview

Users can now drop markers on the map — but those markers are static. Let’s bring them to life by letting users **view and edit a location’s name and description** via a modal interface.

There are **two approaches** available depending on your needs:

---

### ✅ Option 1: Button-Based Annotation (Recommended for Reliability)

> ⚠️ **Why?** `onLongPressGesture` does **not** work reliably inside `Map` annotations in SwiftUI. It fails to trigger consistently — even though the gesture works elsewhere in your UI. Apple’s `Map` view captures gestures differently, so buttons are more reliable.

Use a `Button` inside the annotation instead:

```swift
Annotation(location.name, coordinate: location.coordinate) {
    Button {
        selectedPlace = location
    } label: {
        Image(systemName: "star.circle")
            .resizable()
            .foregroundStyle(.red)
            .frame(width: 44, height: 44)
            .background(.white)
            .clipShape(.circle)
    }
}
```

And present a sheet when a location is selected:

```swift
.fullScreenCover(item: $selectedPlace) { place in
    EditView(location: place) { updatedLocation in
        if let index = locations.firstIndex(of: place) {
            locations[index] = updatedLocation
        }
    }
}
```

This approach is **fast, consistent, and works across iOS versions.**

---

### ⚠️ Option 2: Long Press Gesture (Unreliable with Map)

If you prefer the gesture-based experience, you might try this — just know it may not fire at all due to how `Map` captures input.

```swift
Annotation(location.name, coordinate: location.coordinate) {
    Image(systemName: "star.circle")
        .resizable()
        .foregroundStyle(.red)
        .frame(width: 44, height: 44)
        .background(.white)
        .clipShape(.circle)
        .onLongPressGesture {
            selectedPlace = location
        }
}
```

Attach a `.sheet(item:)` to show an editor:

```swift
.sheet(item: $selectedPlace) { place in
    EditView(location: place) { updatedLocation in
        if let index = locations.firstIndex(of: place) {
            locations[index] = updatedLocation
        }
    }
}
```

🧪 **Note**: While the code compiles and works in preview/testing, **the gesture is likely to fail** during runtime. Use **Option 1 (Button)** if you want guaranteed behavior.

---

### EditView: A Simple Editor for Location Info

Create a reusable editor view:

```swift
struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location

    @State private var name: String
    @State private var description: String

    var onSave: (Location) -> Void

    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description

                    onSave(newLocation)
                    dismiss()
                }
            }
        }
    }
}
```

And in your preview:

```swift
#Preview {
    EditView(location: .example) { _ in }
}
```

### Step 5: Fix Renaming Problem by Making `id` Mutable and Assigning New UUID on Save

Because `id` was immutable and SwiftUI treats two items with the same ID as the same, renaming markers didn’t update the map properly.

Fix this by changing `Location`'s `id` property to mutable:

```swift
var id: UUID
```

And when creating the updated location in `EditView`’s Save button, assign a new UUID:

```swift
newLocation.id = UUID()
```

### Recap

* Added a **selectedPlace optional** to control sheet presentation
* Used **long press gestures** on annotations to trigger editing
* Created a reusable **EditView** for viewing and editing location details
* Passed a **callback closure** to send edited data back
* Made `id` mutable and regenerated it on save so **SwiftUI detects changes properly**
* ✅ **Use buttons inside `Annotation`** to select locations — they’re reliable.
* ⚠️ `onLongPressGesture` often fails inside `Map`; avoid if possible.
* Use `.sheet(item:)` or `.fullScreenCover(item:)` to present an editor for the selected location.


Now users can add locations, long press to edit their names and descriptions, and see those changes reflected immediately on the map. Data persistence is still pending but the UI flow is fully functional!

---

## Day 71 – Project 14, part four

---

## Show Nearby Places in EditView Using Wikipedia API

### Overview

To make the app more useful, we enhance `EditView` to show **interesting places nearby** the selected location. We’ll fetch data from Wikipedia’s geosearch API using the location’s GPS coordinates and display a list of nearby points of interest.

### Step 1: Define Codable Structs to Match Wikipedia JSON

Wikipedia’s API returns a nested JSON structure like this:

* Root contains `query`
* `query` contains `pages` dictionary keyed by page IDs
* Each `page` contains info like `pageid`, `title`, and `terms`

Create a new Swift file `Result.swift` with these structs:

```swift
struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
}
```

### Step 2: Track Loading State & Pages in EditView

Add an enum inside `EditView` to represent the loading state:

```swift
enum LoadingState {
    case loading, loaded, failed
}
```

Add two `@State` properties to track the current state and loaded pages:

```swift
@State private var loadingState = LoadingState.loading
@State private var pages = [Page]()
```

### Step 3: Show Pages or Status in the Form

Below the existing form section, add a new one that conditionally shows content based on loading state:

```swift
Section("Nearby…") {
    switch loadingState {
    case .loaded:
        ForEach(pages, id: \.pageid) { page in
            Text(page.title)
                .font(.headline)
            + Text(": ") +
            Text("Page description here") // Placeholder
                .italic()
        }
    case .loading:
        Text("Loading…")
    case .failed:
        Text("Please try again later.")
    }
}
```

*Tip:* Use `+` to concatenate differently styled `Text` views in SwiftUI.

### Step 4: Fetch Nearby Places from Wikipedia

Add this asynchronous method to `EditView` to perform the network request:

```swift
func fetchNearbyPlaces() async {
    let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

    guard let url = URL(string: urlString) else {
        print("Bad URL: \(urlString)")
        return
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)

        let items = try JSONDecoder().decode(Result.self, from: data)

        pages = items.query.pages.values.sorted { $0.title < $1.title }
        loadingState = .loaded
    } catch {
        loadingState = .failed
    }
}
```

*Note:* The URL is long and precise — consider copy-pasting it carefully.

### Step 5: Trigger Fetch on View Appear

Add this `.task` modifier to `EditView` so the fetch begins when the view appears:

```swift
.task {
    await fetchNearbyPlaces()
}
```

### Recap

* Defined `Result`, `Query`, and `Page` structs to decode Wikipedia’s JSON
* Added `LoadingState` enum and `pages` array to `EditView`
* Updated the UI to show loading, loaded, or failure states dynamically
* Used async/await to fetch nearby places using the Wikipedia geosearch API
* Sorted and displayed the pages by title in a new section of the form

Run your app and open `EditView` on a location — you’ll see nearby Wikipedia places load and display dynamically, enriching your bucket list experience with real-world suggestions!

---

## Enhancing Wikipedia Results Sorting and Description Display in EditView

### Sorting Pages by Title Using Comparable

Wikipedia returns results sorted by their internal page IDs, which isn’t helpful for user display. Instead of sorting inline with a closure every time, we make the `Page` struct conform to `Comparable` for cleaner, reusable sorting.

### Steps:

1. Update the `Page` struct declaration to conform to `Comparable`:

```swift
struct Page: Codable, Comparable {
    // existing properties
}
```

2. Implement the `<` operator comparing titles:

```swift
static func <(lhs: Page, rhs: Page) -> Bool {
    lhs.title < rhs.title
}
```

3. Now you can call `.sorted()` on arrays of `Page` without a closure, simplifying code like this in `fetchNearbyPlaces()`:

```swift
pages = items.query.pages.values.sorted()
```

### Showing a Real Description or a Fallback

Wikipedia’s `terms` dictionary contains an optional `"description"` key, which itself might be absent or empty, complicating UI code.

#### Solution:

Add a computed property `description` to the `Page` struct to extract the first description if available or provide a default string:

```swift
var description: String {
    terms?["description"]?.first ?? "No further information"
}
```

### Updating the UI

Replace placeholder text in the `EditView` section showing pages with the actual description:

```swift
Text(page.description)
```

### Result

* Cleaner and reusable sorting of Wikipedia pages by title.
* Robust, concise handling of optional descriptions.
* UI now shows meaningful descriptions or fallback text for each nearby place.

This completes the `EditView` functionality for Wikipedia data integration, making the app’s nearby places feature polished and user-friendly.

---

## Day 72 – Project 14, part five

---


## Introducing MVVM Architecture to Organize SwiftUI Code

### What is MVVM?

* MVVM stands for **Model-View-ViewModel** — a common architectural pattern for separating concerns in app code.
* The **ViewModel** manages app data and logic, allowing views to focus purely on UI.
* This separation makes code cleaner, easier to maintain, and more testable.

### Creating a ViewModel for ContentView

1. **Create a new Swift file**: `ContentView-ViewModel.swift`.
2. **Import MapKit** (for location-related types).
3. Define the ViewModel class inside an extension of `ContentView`:

```swift
extension ContentView {
    @Observable
    class ViewModel {
        var locations = [Location]()
        var selectedPlace: Location?
    }
}
```

* Using `@Observable` makes the class observable by SwiftUI, so UI updates when data changes.
* Placing the ViewModel inside the view’s extension lets you use the simple name `ViewModel` without polluting global namespaces.

### Moving State into the ViewModel

* Replace `@State` properties in `ContentView` with a single:

```swift
@State private var viewModel = ViewModel()
```

* Update references to state properties to `viewModel.locations` and `viewModel.selectedPlace`.
* This moves app state from the view to a dedicated data manager.

### Encapsulating Data Mutations in ViewModel Methods

* Change the `locations` property to `private(set)` so only the ViewModel can modify it:

```swift
private(set) var locations = [Location]()
```

* Add methods for managing data **inside the ViewModel**:

```swift
import CoreLocation

func addLocation(at point: CLLocationCoordinate2D) {
    let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
    locations.append(newLocation)
    save()
}

func update(location: Location) {
    guard let selectedPlace else { return }
    if let index = locations.firstIndex(of: selectedPlace) {
        locations[index] = location
        save()
    }
}
```

* Modify `ContentView` to call these methods instead of manipulating state directly:

```swift
.onTapGesture { position in
    if let coordinate = proxy.convert(position, from: .local) {
        viewModel.addLocation(at: coordinate)
    }
}
```

and

```swift
EditView(location: place) {
    viewModel.update(location: $0)
}
```

### Adding Persistent Storage to the ViewModel

* Define a file URL to save data:

```swift
let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
```

* Add an initializer to load saved data or start fresh:

```swift
init() {
    do {
        let data = try Data(contentsOf: savePath)
        locations = try JSONDecoder().decode([Location].self, from: data)
    } catch {
        locations = []
    }
}
```

* Add a save method that writes data securely to disk with encryption:

```swift
func save() {
    do {
        let data = try JSONEncoder().encode(locations)
        try data.write(to: savePath, options: [.atomic, .completeFileProtection])
    } catch {
        print("Unable to save data.")
    }
}
```

* Call `save()` after any data modification to keep the file up to date.


### Benefits of this MVVM Setup

* **Separation of concerns:** UI code in `ContentView` only handles layout and display.
* **Testability:** ViewModel’s logic is independent of UI, easier to test.
* **Secure persistence:** Data is saved with iOS encryption (`.completeFileProtection`) so it’s only accessible after device unlock.
* **Simplified maintenance:** Adding features like data syncing or more complex logic can be done inside the ViewModel without cluttering the view.

---

## Adding Biometric Authentication to Protect User Data

### Why?

* The places users add to your app are private.
* Protecting them with Face ID or Touch ID shows respect for user privacy.
* It also gives you a chance to use Apple’s **LocalAuthentication** framework in a practical way.


### Step 1: Add an `isUnlocked` Property to the ViewModel

Track whether the app is unlocked (authenticated) with biometrics:

```swift
var isUnlocked = false
```

### Step 2: Add Face ID Usage Description to Info.plist

* Open your project target, select **Info** tab.
* Add a new key: `Privacy - Face ID Usage Description`
* Provide a message like:
  `"Please authenticate yourself to unlock your places."`

This message explains why your app needs biometric access, shown to users during authentication.

### Step 3: Import LocalAuthentication

At the top of your view model file, add:

```swift
import LocalAuthentication
```

This framework allows you to use Face ID and Touch ID features.

### Step 4: Add an `authenticate()` Method to Your ViewModel

This method handles all biometric authentication logic, keeping it out of your SwiftUI views:

```swift
func authenticate() {
    let context = LAContext()
    var error: NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        let reason = "Please authenticate yourself to unlock your places."

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                if success {
                    self.isUnlocked = true
                } else {
                    // Handle authentication failure if needed
                }
            }
        }
    } else {
        // Handle no biometrics available (e.g., show alert)
    }
}
```

* Creates an `LAContext` for biometric evaluation.
* Checks if biometric authentication is available.
* Starts authentication with a user-visible reason.
* Updates `isUnlocked` if authentication succeeds.
* Runs UI updates on the main thread.

### Step 5: Update `ContentView` to Show Locked/Unlocked UI

Inside the `body` property of `ContentView`, wrap all your current UI inside a conditional that checks `viewModel.isUnlocked`:

```swift
var body: some View {
    if viewModel.isUnlocked {
        // Your existing UI showing map and places here
    } else {
        // Unlock button UI here
        Button("Unlock Places", action: viewModel.authenticate)
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}
```

* When locked, the user only sees an **Unlock Places** button.
* Tapping the button triggers biometric authentication.
* When unlocked, the full app UI is shown.

### Step 6: Testing in Simulator

* If using the iOS Simulator for the first time, enable Face ID:

  * In the Simulator menu, select **Features > Face ID > Enrolled**.
* Trigger Face ID using **Features > Face ID > Matching Face**.
* This simulates successful authentication.

## Recap

* ** `isUnlocked` ** controls access to your app’s private data.
* Biometric authentication is cleanly encapsulated in the view model.
* The UI reacts naturally to locked/unlocked states.
* Your app respects user privacy with minimal added code.
* This final step completes your secure, user-friendly SwiftUI app!

