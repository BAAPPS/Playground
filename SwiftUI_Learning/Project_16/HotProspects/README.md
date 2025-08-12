# HotProspects Summary

---

## Day 79 – Project 16, part one

---

## List Row Selection

It’s common to place a `NavigationLink` inside a `List` row so users can tap to see more details.
But sometimes you need more control — tapping should *only* select an item, letting you act on it later.

### 1. Single Selection

```swift
struct ContentView: View {
    let users = ["Tohru", "Yuki", "Kyo", "Momiji"]
    @State private var selection: String?   // Tracks selected row

    var body: some View {
        VStack {
            List(users, id: \.self, selection: $selection) { user in
                Text(user)
            }

            if let selection {
                Text("You selected \(selection)")
            }
        }
    }
}
```

* `@State` holds the selected item (optional means none selected by default).
* Binding `selection` to the list makes it update when rows are tapped.
* Updating the state programmatically also updates the UI selection.

### 2. Multiple Selection

```swift
struct ContentView: View {
    let users = ["Tohru", "Yuki", "Kyo", "Momiji"]
    @State private var selection = Set<String>()   // Tracks multiple rows

    var body: some View {
        VStack {
            EditButton() // Enables multi-select mode

            List(users, id: \.self, selection: $selection) { user in
                Text(user)
            }

            if selection.isEmpty == false {
                Text("You selected \(selection.formatted())")
            }
        }
    }
}
```

* Change state to a `Set` for multi-selection.
* `.formatted()` turns the set into a readable string.
* `EditButton()` toggles selection mode with checkboxes.
* Hidden iOS gesture: two-finger horizontal swipe to enable multi-select without edit mode.

---


## TabView Basics & Programmatic Control

`NavigationStack` is great for hierarchical, drill-down navigation.
For switching between *unrelated* views, SwiftUI’s `TabView` is the better choice — it displays a tab bar at the bottom with a separate view for each tab.

### 1. Basic TabView

```swift
TabView {
    Text("Tab 1")
    Text("Tab 2")
}
```

* Works, but without customization the tab bar is an empty gray area — not a great user experience.

### 2. Adding Tab Items

Attach `.tabItem()` to each view to customize the label and icon:

```swift
TabView {
    Text("Tab 1")
        .tabItem {
            Label("One", systemImage: "star")
        }

    Text("Tab 2")
        .tabItem {
            Label("Two", systemImage: "circle")
        }
}
```

### 3. Programmatic Tab Switching

To change tabs from code:

1. Create a `@State` property to track the selected tab.
2. Update that property to switch tabs.
3. Bind it to `TabView(selection:)`.
4. Assign each tab a unique `.tag()` value.

### Example:

```swift
struct ContentView: View {
    @State private var selectedTab = "One" // Tracks current tab

    var body: some View {
        TabView(selection: $selectedTab) {
            Button("Show Tab 2") {
                selectedTab = "Two"
            }
            .tabItem {
                Label("One", systemImage: "star")
            }
            .tag("One")

            Text("Tab 2")
                .tabItem {
                    Label("Two", systemImage: "circle")
                }
                .tag("Two")
        }
    }
}
```

* Clicking the first tab’s button switches to the second tab.
* `.tag()` values should be unique and descriptive — avoid relying on array indexes.

### 4. Best Practices

* Use **string tags** that describe the view’s purpose (e.g., `"Profile"`, `"Settings"`).
* If combining with `NavigationStack`, make `TabView` the **parent** and put `NavigationStack` *inside* each tab.

---

## Day 80 – Project 16, part two

---

## Using `Result` for Success or Failure

Swift’s `Result` type encapsulates either:

* A **successful value** (e.g., a `String`)
* An **error** conforming to `Error`

It’s like an optional — but instead of *some value or nil*, it’s *success or failure*.

### 1. Without `Result` – Direct Async Fetch

```swift
struct ContentView: View {
    @State private var output = ""

    var body: some View {
        Text(output)
            .task {
                await fetchReadings()
            }
    }

    func fetchReadings() async {
        do {
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            output = "Found \(readings.count) readings"
        } catch {
            print("Download error")
        }
    }
}
```

* Works fine, but it **handles the result immediately**.
* No way to *store*, *pass*, or *cancel* the work easily.


### 2. With `Result` via `Task`

We can use `Task` to wrap the work, return a value, and store success/failure in a single `Result`:

```swift
func fetchReadings() async {
    let fetchTask = Task {
        let url = URL(string: "https://hws.dev/readings.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let readings = try JSONDecoder().decode([Double].self, from: data)
        return "Found \(readings.count) readings"
    }

    // Later: read the result
    let result = await fetchTask.result // Result<String, Error>
}
```

Advantages:

* Store the work for later use.
* Cancel it if no longer needed.
* Handle success/failure when *you* choose.

### 3. Handling the Result

#### Option A – Using `.get()` with `do`/`catch`

```swift
let result = await fetchTask.result

do {
    output = try result.get()
} catch {
    output = "Error: \(error.localizedDescription)"
}
```

#### Option B – Switching on `.success` / `.failure`

```swift
switch await fetchTask.result {
case .success(let str):
    output = str
case .failure(let error):
    output = "Error: \(error.localizedDescription)"
}
```

### Why Use `Result`?

* Encapsulates *both* success and failure in one type.
* Lets you **pass results** across code boundaries without immediately handling them.
* Errors are stored — you decide **when** to read them.

---

## Controlling Image Interpolation

When a SwiftUI `Image` is stretched beyond its original size, iOS applies **image interpolation** by default — blending pixels smoothly to reduce visible jagged edges.

This works well in most cases, but **for precise pixel art or line art**, interpolation can cause **unwanted blur**.

### 1. Default Interpolation (Blurry Edges)

```swift
Image(.example)
    .resizable()
    .scaledToFit()
    .background(.black)
```

* `example@3x.png` is a **small** image (66×92 px).
* SwiftUI blends pixels to smooth scaling.
* Result: **jagged + blurry edges**, especially visible in solid colors.

### 2. Disabling Interpolation (Pixel-Perfect)

SwiftUI’s `.interpolation()` modifier lets you control pixel blending.
For crisp, sharp edges, use `.none`:

```swift
Image(.example)
    .interpolation(.none)
    .resizable()
    .scaledToFit()
    .background(.black)
```

* Turns **off** blending.
* Preserves the pixelated style — perfect for **retro games** or **line art**.
* Improves visual clarity when precise pixel boundaries matter.

### 3. When to Use `.interpolation(.none)`

✅ Retro-style pixel art
✅ UI icons that must stay sharp
✅ Line drawings or technical diagrams
⚠️ Avoid for photos — disabling interpolation can make them look harsh.

---

## Adding Context Menus

In SwiftUI, **context menus** let users press and hold (long-press) on a view to access extra options — similar to the old 3D Touch feature.

They’re added using the `.contextMenu()` modifier and can contain a list of `Button`s or `Label`s.


### 1. Basic Context Menu

```swift
struct ContentView: View {
    @State private var backgroundColor = Color.red

    var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
                .background(backgroundColor)

            Text("Change Color")
                .padding()
                .contextMenu {
                    Button("Red") { backgroundColor = .red }
                    Button("Green") { backgroundColor = .green }
                    Button("Blue") { backgroundColor = .blue }
                }
        }
    }
}
```

* Long-pressing **"Change Color"** opens a menu.
* Menu items appear in the order they’re added.

### 2. Using Labels with SF Symbols

You can give each menu item text + an icon:

```swift
Button("Red", systemImage: "checkmark.circle.fill") {
    backgroundColor = .red
}
```

> **Note:** SwiftUI ignores `.foregroundStyle()` on menu items — Apple enforces a uniform look.


### 3. Marking Destructive Actions

To signal a destructive option (e.g., delete, reset, or “dangerous” changes), set a `role`:

```swift
Button("Red", systemImage: "checkmark.circle.fill", role: .destructive) {
    backgroundColor = .red
}
```

### 4. Best Practices for Context Menus

* **Be consistent:** Use them across your app, not just in one spot.
* **Keep them short:** Aim for **three or fewer** menu items.
* **Avoid redundancy:** Don’t repeat visible UI actions.
* **Don’t hide essentials:** Important actions should be accessible without long-press.

---

## Day 81 – Project 16, part three

---

## Adding Swipe Actions to List Rows

iOS has long supported **“swipe to delete”**, but now list rows can have **multiple swipe actions** — on **either side** of the row — using SwiftUI’s `.swipeActions()` modifier.

### 1. Basic Swipe Action (Right Edge, Default Style)

```swift
List {
    Text("Taylor Swift")
        .swipeActions {
            Button("Send message", systemImage: "message") {
                print("Hi")
            }
        }
}
```

* Swipe **right-to-left** to reveal the button.
* By default: gray button, **right edge** only.

### 2. Customizing Edge & Color

* Use `edge: .leading` for **left-side** actions.
* Add `.tint()` for custom colors.
* Or use `role` (e.g., `.destructive`) for system colors.

```swift
List {
    Text("Taylor Swift")
        .swipeActions {
            Button("Delete", systemImage: "minus.circle", role: .destructive) {
                print("Deleting")
            }
        }
        .swipeActions(edge: .leading) {
            Button("Pin", systemImage: "pin") {
                print("Pinning")
            }
            .tint(.orange)
        }
}
```

### 3. Best Practices

* **Don’t hide critical actions** in swipe gestures — they’re invisible until discovered.
* Use **clear, short labels** and recognizable SF Symbols.
* Combine with **context menus** when you want both gesture-based and long-press options.

---

## Scheduling Local Notifications

iOS provides the **UserNotifications** framework for displaying alerts on the lock screen.
There are two main types:

* **Local notifications** – scheduled directly from the device.
* **Remote notifications (push)** – sent from a server via Apple’s Push Notification Service (APNS).

We’ll focus on **local notifications**, since they’re easier to set up and don’t require a backend.

### 1. Setup

Add the import:

```swift
import UserNotifications
```

Create two buttons in your `ContentView` to **request permission** and **schedule a notification**:

```swift
VStack {
    Button("Request Permission") {
        // Request permission
    }

    Button("Schedule Notification") {
        // Schedule a notification
    }
}
```

### 2. Request Permission

Ask for **alerts**, **badges**, and **sounds**.
This will prompt the user the first time it’s called.

```swift
UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
    if success {
        print("All set!")
    } else if let error {
        print(error.localizedDescription)
    }
}
```

### 3. Schedule a Notification

A notification is made of three parts:

1. **Content** – the title, subtitle, sound, and more.
2. **Trigger** – when to show it (time, date, or location).
3. **Request** – bundles the content and trigger with a unique ID.

Example: Show a notification **5 seconds from now**.

```swift
let content = UNMutableNotificationContent()
content.title = "Feed the cat"
content.subtitle = "It looks hungry"
content.sound = UNNotificationSound.default

let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

UNUserNotificationCenter.current().add(request)
```

### 4. Testing

* Run your app.
* Tap **Request Permission**.
* Tap **Schedule Notification**.
* Lock the simulator (`Cmd+L`).
* Wait 5 seconds — you should see and hear your alert.

### Best Practices

* **Request permission early** if notifications are core to your app, otherwise wait until it’s needed.
* Keep titles **short** and **actionable**.
* Avoid spamming — users can revoke permission at any time.

---

## Loading Remote Images with Kingfisher

So far, we’ve written our code from scratch, but sometimes it’s smarter to rely on well-tested libraries rather than reinventing the wheel. For image downloading and caching, 
**[Kingfisher](https://github.com/onevcat/Kingfisher.git)** is one of the most popular Swift packages. It handles:

* Downloading images from a URL.
* Caching them automatically for faster subsequent loads.
* Smoothly updating your SwiftUI views when the image is ready.

### 1. Adding Kingfisher via Swift Package Manager

1. In Xcode, go to **File → Add Package Dependencies**.
2. Enter the package URL:

   ```
   https://github.com/onevcat/Kingfisher
   ```
3. Choose **Version – Up to Next Major** (recommended).
4. Click **Add Package** twice to confirm.

You should now see **Kingfisher** in the **Swift Package Dependencies** section of your project.

### 2. Importing Kingfisher

At the top of your Swift file:

```swift
import Kingfisher
```

### 3. Displaying an Image from the Web

Kingfisher provides the `KFImage` view for SwiftUI.
Here’s a minimal example:

```swift
import SwiftUI
import Kingfisher

struct ContentView: View {
    var body: some View {
         KFImage(URL(string: "https://picsum.photos/300/200"))
            .placeholder {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .opacity(0.5)
            }
            .onFailure { error in
                print("Kingfisher failed to load image: \(error)")
            }
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.top, 110)
    }
}
```

### 4. How It Works

* ** `KFImage`** takes a `URL?` and downloads the image asynchronously.
* **Caching** happens automatically — once loaded, Kingfisher stores it locally.
* **Placeholders** let you show a loading indicator or fallback image.
* Works seamlessly with **SwiftUI’s layout and modifiers**.


### 5. Best Practices

* Use `placeholder` to improve perceived performance.
* Combine with `.cacheOriginalImage()` if you plan to reuse the same file later.
* Always validate your URLs before passing them to `KFImage` to avoid silent failures.

---

## Day 82 – Project 16, part four

---

## HotProspects – Creating a Tab Bar with Filtered Views

This app will display **four tabs**:

* Everyone you met
* People you have contacted
* People you haven’t contacted
* Your personal info for others to scan

The first three are variations of the same view, so we’ll represent our UI with just **three views**:

* `ProspectsView` — displays people, filtered as needed
* `MeView` — shows your personal information
* `ContentView` — holds the `TabView` combining all views

### 1. Create Placeholder Views

* Add two new SwiftUI views: **ProspectsView** and **MeView**
* Leave their bodies as default `"Hello, World!"` for now


### 2. Setup the TabView in ContentView

Replace your `ContentView` body with this:

```swift
TabView {
    ProspectsView()
        .tabItem {
            Label("Everyone", systemImage: "person.3")
        }
    ProspectsView()
        .tabItem {
            Label("Contacted", systemImage: "checkmark.circle")
        }
    ProspectsView()
        .tabItem {
            Label("Uncontacted", systemImage: "questionmark.diamond")
        }
    MeView()
        .tabItem {
            Label("Me", systemImage: "person.crop.square")
        }
}
```

Run the app to see a tab bar letting you switch between four tabs.


### 3. Add Filtering Logic to ProspectsView

Inside `ProspectsView`, add this enum to represent filter types:

```swift
enum FilterType {
    case none, contacted, uncontacted
}
```

Add a property to customize the view:

```swift
let filter: FilterType
```


### 4. Show Different Titles per Filter

Add a computed property to return a title string based on the filter:

```swift
var title: String {
    switch filter {
    case .none:
        "Everyone"
    case .contacted:
        "Contacted people"
    case .uncontacted:
        "Uncontacted people"
    }
}
```

Update the body to use a navigation stack and show the title:

```swift
NavigationStack {
    Text("Hello, World!")
        .navigationTitle(title)
}
```

### 5. Full Code

```swift
enum FilterType {
    case none, contacted, uncontacted
}

struct ProspectsView: View {
    let filter: FilterType
    var title: String {
        switch filter {
        case .none:
            "All Prospects"
        case .contacted:
            "Contacted Prospects"
        case .uncontacted:
            "Uncontacted Prospects"
        }
    }
    var body: some View {
        NavigationStack {
            Text("Hello, World!")
                .navigationTitle(title)
        }
    }
}

#Preview {
    ProspectsView(filter:.contacted)
}
```

### 5. Update Initializers and Previews

* Update `ProspectsView` initializers in `ContentView` to pass the correct filter:

```swift
ProspectsView(filter: .none)
ProspectsView(filter: .contacted)
ProspectsView(filter: .uncontacted)
```

---

## HotProspects – Using SwiftData to Share and Query Model Data

Many apps are great candidates for **SwiftData**, and setting it up often takes surprisingly little effort.

### 1. Defining the Data Model

Create a new Swift file called **Prospect.swift**, import **SwiftData**, and add this model:

```swift
import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
}
```

* Use Xcode’s autocomplete to add the initializer. (type **in**)
* Remember: the `@Model` macro works only on classes.
* This lets multiple views share and stay updated on the same data instances.

### 2. Setting Up the Model Container

In **HotProspectsApp.swift**, import SwiftData and modify the `WindowGroup` to add the model container:

```swift
WindowGroup {
    ContentView()
}
.modelContainer(for: Prospect.self)
```

* This creates persistent storage for the `Prospect` class.
* It also injects a shared SwiftData model context into all SwiftUI views.

### 3. Querying Shared Data in Views

Open **ProspectsView\.swift**, import SwiftData, then add these properties to the `ProspectsView` struct:

```swift
@Query(sort: \Prospect.name) var prospects: [Prospect]
@Environment(\.modelContext) var modelContext
```

* `@Query` fetches all `Prospect` objects sorted by name.
* `modelContext` gives access to the shared data context.
* **Tip:** For Xcode previews, add `.modelContainer(for: Prospect.self)` to preview code to avoid errors.

### 4. Adding Test Data and Showing Counts

Update the body of `ProspectsView` to show the number of prospects and add a toolbar button for testing:

```swift
NavigationStack {
    Text("People: \(prospects.count)")
        .navigationTitle(title)
        .toolbar {
            Button("Scan", systemImage: "qrcode.viewfinder") {
                let prospect = Prospect(name: "Paul Hudson", emailAddress: "paul@hackingwithswift.com", isContacted: false)
                modelContext.insert(prospect)
            }
        }
}
```

* The **Scan** button inserts a new prospect into the shared model context.
* All three instances of `ProspectsView` show updated counts simultaneously because they share the same data.

### Summary

SwiftData makes it easy to define, store, and share data models across multiple views with minimal code. Using `@Model`, `@Query`, and `modelContainer(for:)`, your app’s data stays in sync seamlessly.

---

## Filtering SwiftData Queries Based on View State


### 1. Default Query Loads All Data

By default, we query all `Prospect` objects sorted by name:

```swift
@Query(sort: \Prospect.name) var prospects: [Prospect]
```

* This works fine for the **Everyone** tab, but isn’t enough for filtering **Contacted** and **Uncontacted** tabs.


### 2. Using FilterType to Customize Queries

Our app passes a `FilterType` value to each `ProspectsView` instance to indicate which data it should show. We can use that to override the default query by adding a custom initializer:

```swift
init(filter: FilterType) {
    self.filter = filter

    if filter != .none {
        let showContactedOnly = filter == .contacted

        _prospects = Query(filter: #Predicate {
            $0.isContacted == showContactedOnly
        }, sort: [SortDescriptor(\Prospect.name)])
    }
}
```

* The line `let showContactedOnly = filter == .contacted` evaluates to `true` if the filter is `.contacted`, otherwise `false`.
* This lets the query predicate check `isContacted` against that boolean, filtering prospects accordingly.
* When `filter` is `.none`, the default query (all prospects) remains in effect.


### 3. Displaying Filtered Results

Replace the previous simple text view with a `List` to show filtered results, displaying each prospect’s name and email:

```swift
List(prospects) { prospect in
    VStack(alignment: .leading) {
        Text(prospect.name)
            .font(.headline)
        Text(prospect.emailAddress)
            .foregroundStyle(.secondary)
    }
}
```

* This creates a nicely formatted list showing relevant details.
* Run the app to see each tab correctly filtered by contact status.

### Summary

By overriding the default `@Query` with a custom initializer and predicate, you can easily create filtered views of your shared data model — allowing each tab to show exactly what it needs.

---

## Day 83 – Project 16, part five

---

## Generating a Sharp QR Code Using Core Image and SwiftUI

### 1. Storing User Input with @AppStorage

We want the user to enter their **name** and **email address**, then generate a QR code from that data.

Add these two properties to `MeView`:

```swift
@AppStorage("name") private var name = "Anonymous"
@AppStorage("emailAddress") private var emailAddress = "you@yoursite.com"
```

* Using `@AppStorage` automatically persists values across app launches.

### 2. Creating the Input Form

We use a `Form` with two `TextField`s, applying `.textContentType()` modifiers to help iOS offer autocomplete suggestions:

```swift
NavigationStack {
    Form {
        TextField("Name", text: $name)
            .textContentType(.name)
            .font(.title)

        TextField("Email address", text: $emailAddress)
            .textContentType(.emailAddress)
            .font(.title)
    }
    .navigationTitle("Your code")
}
```

### 3. Import Core Image and Setup Filter

To generate QR codes, import Core Image filters and add properties for:

* A Core Image context
* A QR code generator filter

```swift
import CoreImage.CIFilterBuiltins

let context = CIContext()
let filter = CIFilter.qrCodeGenerator()
```

### 4. Generate the QR Code Image

Define a method to convert a string into a QR code image:

```swift
func generateQRCode(from string: String) -> UIImage {
    filter.message = Data(string.utf8)

    if let outputImage = filter.outputImage {
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
    }

    return UIImage(systemName: "xmark.circle") ?? UIImage()
}
```

* Converts string to data for the filter.
* Converts output `CIImage` to `CGImage`, then to `UIImage`.
* Returns a fallback image if anything fails.

### 5. Displaying the QR Code

Add an `Image` view below the text fields, using `generateQRCode(from:)` and scale it nicely:

```swift
Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
    .resizable()
    .scaledToFit()
    .frame(width: 200, height: 200)
```

* Combines name and email with a line break for easy encoding and later decoding.


### 6. Disable Image Interpolation for Crisp Pixels

The QR code may look blurry because SwiftUI smooths pixels when scaling. For pixel-perfect sharpness, add this modifier:

```swift
.interpolation(.none)
```

* Prevents SwiftUI from blending pixels.
* Makes the QR code appear sharp and clear, especially important for line art like QR codes.

### Summary

By combining `@AppStorage` for persistent input, Core Image’s QR code generator, and SwiftUI’s image handling with interpolation disabled, you create a dynamic, crisp QR code that updates as the user types their 
information.

---

## Scanning QR Codes in SwiftUI Using the CodeScanner Package

### 1. Add the CodeScanner Package

We use a prebuilt Swift package called **CodeScanner** to handle QR and barcode scanning with minimal setup.

Steps to add it in Xcode:

* Go to **File > Add Package Dependencies**.
* Enter URL: `https://github.com/twostraws/CodeScanner`
* Leave version rule as **Up to Next Major**.
* Press **Add Package**.

This adds a `CodeScannerView` SwiftUI view we can use for scanning.

### 2. Prepare ProspectsView for Scanning

First, import the package in `ProspectsView.swift`:

```swift
import CodeScanner
```

Add a new state property to control scanner presentation:

```swift
@State private var isShowingScanner = false
```

### 3. Replace the "Scan" Button Action

Instead of adding test data, use the button to present the scanner:

```swift
.toolbar {
    Button("Scan", systemImage: "qrcode.viewfinder") {
        isShowingScanner = true
    }
}
```

### 4. Handle Scanning Results

Add this method to `ProspectsView` to process the scanned data:

```swift
func handleScan(result: Result<ScanResult, ScanError>) {
    isShowingScanner = false

    switch result {
    case .success(let result):
        let details = result.string.components(separatedBy: "\n")
        guard details.count == 2 else { return }

        let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
        modelContext.insert(person)

    case .failure(let error):
        print("Scanning failed: \(error.localizedDescription)")
    }
}
```

* This expects the QR code to contain two lines: name and email address.
* On success, creates a new `Prospect` and inserts it into the model context.
* On failure, prints an error message.

### 5. Request Camera Permission

Before using the scanner on a real device, add a usage description:

* Go to your target’s **Info** tab.
* Add a new key: **Privacy - Camera Usage Description**
* Set its value to: `"We need to scan QR codes."`


### 6. Present the Scanner Using a Sheet

Attach this `.sheet` modifier to your view (typically below `.toolbar`):

```swift
.sheet(isPresented: $isShowingScanner) {
    CodeScannerView(
        codeTypes: [.qr],
        simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
        completion: handleScan
    )
}
```

* `codeTypes` specifies we only scan QR codes here.
* `simulatedData` allows testing in the simulator (which has no camera).
* `completion` handles scan results via the method above.


### 7. Testing the Scanner

* **Simulator:** The scanner shows a test UI. Tap anywhere to dismiss and send back simulated data.
* **Real device:** The app asks for camera permission. After allowing, you can scan real QR codes.
* **Pro tip:** Run the app simultaneously on simulator and device, then scan the QR code displayed in the simulator using your device’s camera.


### Summary

Using the CodeScanner Swift package simplifies adding QR code scanning to SwiftUI apps by providing a ready-made scanner view, handling permissions, scan results, and simulator support, letting you focus on what to do with 
the scanned data.

---

## Adding Swipe Actions and Multi-Select Deletion in ProspectsView

### 1. Swipe Actions to Toggle Contacted Status

To allow users to move prospects between Contacted and Uncontacted tabs, add swipe actions on each list row:

```swift
.swipeActions {
    if prospect.isContacted {
        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
            prospect.isContacted.toggle()
        }
        .tint(.blue)
    } else {
        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
            prospect.isContacted.toggle()
        }
        .tint(.green)
    }
}
```

> **Note:** Toggling the `isContacted` Boolean automatically updates the UI and saves changes with SwiftData.

### 2. Adding Swipe-to-Delete Button

To replicate the default swipe-to-delete behavior alongside your new toggle actions, add this button **first** in the swipe actions list so users can swipe all the way to delete:

```swift
Button("Delete", systemImage: "trash", role: .destructive) {
    modelContext.delete(prospect)
}
```

### 3. Enable Multi-Selection and Bulk Delete

Add new state to track selected prospects:

```swift
@State private var selectedProspects = Set<Prospect>()
```

Bind selection to your `List`:

```swift
List(prospects, selection: $selectedProspects) { prospect in
    VStack(alignment: .leading) {
        Text(prospect.name).font(.headline)
        Text(prospect.emailAddress).foregroundStyle(.secondary)
    }
    .swipeActions { /* swipe actions here */ }
    .tag(prospect)  // Important for identifying selection
}
```

### 4. Add Delete Method for Bulk Deletion

Create a method to delete all selected prospects:

```swift
func delete() {
    for prospect in selectedProspects {
        modelContext.delete(prospect)
    }
    selectedProspects.removeAll()
}
```

### 5. Add Toolbar Items for Edit and Delete Buttons

Wrap toolbar items using `ToolbarItem` modifiers inside your existing `.toolbar`:

```swift
.toolbar {
    ToolbarItem(placement: .topBarLeading) {
        EditButton()
    }
    
    ToolbarItem(placement: .topBarTrailing) {
        Button("Scan", systemImage: "qrcode.viewfinder") {
            isShowingScanner = true
        }
    }
    
    if !selectedProspects.isEmpty {
        ToolbarItem(placement: .bottomBar) {
            Button("Delete Selected", action: delete)
        }
    }
}
```

* The **EditButton** toggles multi-selection mode.
* The **Delete Selected** button only appears when there are selected items.
* The **Scan** button remains in the top trailing position.

### 6. Complete Example: Updated List and Toolbar in ProspectsView

```swift
List(prospects, selection: $selectedProspects) { prospect in
    VStack(alignment: .leading) {
        Text(prospect.name).font(.headline)
        Text(prospect.emailAddress).foregroundStyle(.secondary)
    }
    .swipeActions {
        Button("Delete", systemImage: "trash", role: .destructive) {
            modelContext.delete(prospect)
        }
        
        if prospect.isContacted {
            Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                prospect.isContacted.toggle()
            }
            .tint(.blue)
        } else {
            Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                prospect.isContacted.toggle()
            }
            .tint(.green)
        }
    }
    .tag(prospect)
}
.toolbar {
    ToolbarItem(placement: .topBarLeading) {
        EditButton()
    }
    
    ToolbarItem(placement: .topBarTrailing) {
        Button("Scan", systemImage: "qrcode.viewfinder") {
            isShowingScanner = true
        }
    }
    
    if !selectedProspects.isEmpty {
        ToolbarItem(placement: .bottomBar) {
            Button("Delete Selected", action: delete)
        }
    }
}
```

### Summary

* Users can swipe any prospect to toggle contact status or delete individually.
* They can enter multi-selection mode via the Edit button.
* When selecting multiple prospects, a Delete Selected button appears for batch removal.
* SwiftUI and SwiftData handle UI updates and data persistence automatically.

---

## Day 84 – Project 16, part six

---

## Adding a ShareLink to the QR Code in MeView with Caching

### 1. Add a Cached QR Code @State Property

Add this property to cache the generated QR code image:

```swift
@State private var qrCode = UIImage()
```

### 2. Update `generateQRCode(from:)` to Just Return the Image

Simplify `generateQRCode(from:)` so it **only returns** the generated UIImage, without modifying state:

```swift
func generateQRCode(from string: String) -> UIImage {
    filter.message = Data(string.utf8)

    if let outputImage = filter.outputImage {
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
    }

    return UIImage(systemName: "xmark.circle") ?? UIImage()
}
```

### 3. Create a Method to Update Cached QR Code

Create a method that generates the QR code from the current name and email, and stores it in the `qrCode` state:

```swift
func updateCode() {
    qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
}
```

### 4. Use the Cached QR Code Image in the View

Update your Image view to use the cached QR code:

```swift
Image(uiImage: qrCode)
    .interpolation(.none)
    .resizable()
    .scaledToFit()
    .frame(width: 200, height: 200)
    .contextMenu {
        ShareLink(item: Image(uiImage: qrCode), 
                  preview: SharePreview("My QR Code", image: Image(uiImage: qrCode)))
    }
```

### 5. Refresh the Cached QR Code on Appear and When Name/Email Change

Attach `.onAppear` and `.onChange` modifiers to update the cached code at the right times:

```swift
.navigationTitle("Your code")
.onAppear(perform: updateCode)
.onChange(of: name) { _ in updateCode() }
.onChange(of: emailAddress) { _ in updateCode() }
```

### 6. Add Photo Library Usage Description in Info.plist

For sharing or saving images, add this key-value pair to your app’s Info.plist:

* **Key:** Privacy - Photo Library Additions Usage Description
* **Value:** We want to save your QR code.

### Summary

By caching the generated QR code in a `@State` property and updating it only when necessary, you avoid SwiftUI’s "Modifying state during view update" warning and have a clean `ShareLink` in a context menu attached to your 
QR code image.

### Complete Relevant Snippet in `MeView`:

```swift
import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    @AppStorage("name") private var name = "Anonymous"
    @AppStorage("emailAddress") private var emailAddress = "you@yoursite.com"
    
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                
                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu {
                        ShareLink(item: Image(uiImage: qrCode),
                                  preview: SharePreview("My QR Code", image: Image(uiImage: qrCode)))
                    }
            }
            .navigationTitle("Your code")
            .onAppear(perform: updateCode)
            .onChange(of: name, updateCode)
            .onChange(of: emailAddress, updateCode)
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
}
```

---

