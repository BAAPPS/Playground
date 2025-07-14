# InstaFilter Summary

---

## Day 62 – Project 13, part one

---


## Understanding @State and Property Wrappers

This part of the Instafilter project explores how SwiftUI uses `@State` to manage mutable data in views, how bindings work under the hood, and why certain property observers like `didSet` don’t behave as expected when working with bindings.

### What You’ll Learn

* How `@State` enables data mutation in SwiftUI view structs
* Binding `@State` properties to UI controls using `$`
* Why `didSet` doesn’t get called when a binding changes
* What property wrappers really do behind the scenes
* How `@State` is just a wrapper over a value type (`State<Value>`)
* The difference between direct mutation and binding-based updates

### Key Concepts

#### Binding and @State

SwiftUI’s `@State` lets us write reactive UI by automatically re-invoking a view’s body when the state changes:

```swift
@State private var blurAmount = 0.0
```

You can bind this to a control like so:

```swift
Slider(value: $blurAmount, in: 0...20)
```

#### Property Observers and @State

Using a property observer like this:

```swift
@State private var blurAmount = 0.0 {
    didSet {
        print("New value is \(blurAmount)")
    }
}
```

will **not** work as expected when the value is changed via a binding (like a `Slider`), because the binding bypasses `didSet` and updates the wrapped value directly.

#### Why `didSet` Fails

* `@State` is a property wrapper that produces a `State<Value>` struct.
* The `wrappedValue` has a non-mutating setter.
* Changes via binding bypass the Swift property observer entirely.
* Direct updates (like in a button action) *do* trigger `didSet`.

### Recap

Understanding how `@State` and property wrappers work internally is critical for writing reliable SwiftUI code. If you need to react to **any** kind of state change (including bindings), using view modifiers like 
`.onChange(of:)` is the appropriate solution, rather than relying on `didSet`.

---

## Understanding onChange and Why didSet Doesn’t Work with @State

### Why didSet Fails with @State

In SwiftUI, using `@State` allows a view to react to value changes and re-render its body. However, if you try to observe changes using a property observer like `didSet`, you’ll find that it **does not get called** when the value changes through a binding.

Example that **won’t work** as expected:

```swift
struct ContentView: View {
    @State private var blurAmount = 0.0 {
        didSet {
            print("New value is \(blurAmount)")
        }
    }

    var body: some View {
        VStack {
            Text("Hello, World!")
                .blur(radius: blurAmount)

            Slider(value: $blurAmount, in: 0...20)
        }
    }
}
```

Even though the slider updates the blur amount, `didSet` will not be triggered — because SwiftUI updates the underlying storage directly, bypassing the observer.

### The Fix: Using `.onChange()`

SwiftUI provides a better way to respond to state changes using the `.onChange(of:)` modifier. This allows you to run code whenever a value changes — regardless of how that change happens.

#### Example:

```swift
struct ContentView: View {
    @State private var blurAmount = 0.0

    var body: some View {
        VStack {
            Text("Hello, World!")
                .blur(radius: blurAmount)

            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { oldValue, newValue in
                    print("New value is \(newValue)")
                }
        }
    }
}
```

Now, whenever the slider moves, the new value is printed to the console as expected.

### Where to Place `.onChange()`

You can attach `.onChange()` anywhere in your view hierarchy, but best practice is to place it close to the element being changed. This makes your code easier to read and maintain.

### Variants of `.onChange()`

SwiftUI offers several ways to use `.onChange()`:

* `.onChange(of: value) { oldValue, newValue in ... }`
  → The most complete form, introduced in iOS 17.

* `.onChange(of: value) { newValue in ... }`
  → Deprecated in iOS 17. Use only if supporting iOS 16 or earlier.

* `.onChange(of: value) { ... }`
  → Use when you don’t care about either old or new value.

### Recap

To track changes to `@State` properties, avoid `didSet` and use `.onChange()` instead. It gives you predictable and flexible hooks for running side effects or triggering additional logic based on state updates.

Let me know if you want to include visuals, sample outputs, or a version compatibility chart.

---

## Using `confirmationDialog()` in SwiftUI

SwiftUI provides several tools for presenting choices to the user, including `alert()` for critical decisions and `sheet()` for presenting full views. In between those two lies `confirmationDialog()`, a flexible way to present multiple choices in a visually distinct style.

### 🆚 Alert vs Confirmation Dialog

| Feature           | `alert()`                    | `confirmationDialog()`               |
| ----------------- | ---------------------------- | ------------------------------------ |
| Appearance        | Centered pop-up              | Slides up from the bottom            |
| Dismissal         | Requires button tap          | Tap a button, outside, or use Cancel |
| Number of buttons | Typically limited            | Can contain many buttons             |
| Best use case     | Important alerts or warnings | Presenting a list of user options    |

### Basic Setup Example

```swift
struct ContentView: View {
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white

    var body: some View {
        Button("Hello, World!") {
            showingConfirmation = true
        }
        .frame(width: 300, height: 300)
        .background(backgroundColor)
        .confirmationDialog("Change background", isPresented: $showingConfirmation) {
            Button("Red") { backgroundColor = .red }
            Button("Green") { backgroundColor = .green }
            Button("Blue") { backgroundColor = .blue }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Select a new color")
        }
    }
}
```

### How It Works

* `.confirmationDialog()` is a **modifier** attached to a view, like `.alert()`.
* It’s shown when a `@State` Boolean becomes `true`.
* It accepts:

  * A **title** (`String`)
  * A **Boolean binding** to control visibility
  * A **closure** containing the buttons (actions)
  * An optional **message** closure

### Best Practices

* Always include a **Cancel** button for clarity, even if users can tap outside to dismiss.
* Use confirmation dialogs when the user has **multiple actions** to choose from.
* Avoid using them for destructive or critical decisions — use `alert()` instead.

### Recap

When you run the app:

* Tapping the "Hello, World!" button opens a confirmation dialog.
* Tapping a color changes the background color.
* The dialog slides up from the bottom, offering a smooth user experience.


---

## Day 63 – Project 13, part two

---

## Integrating Core Image with SwiftUI

Core Image is Apple’s powerful image processing framework, allowing us to apply visual effects like blur, sharpen, pixellation, vignettes, and more. Although Core Image doesn’t integrate naturally with SwiftUI, with a little work we can bridge them to unlock a wide array of filter effects.

### What is Core Image?

* Core Image focuses on **manipulating existing images**, not drawing new ones.
* Examples include filters like **sepia tone**, **blur**, **pixellate**, **crystallize**, and more.
* It is GPU-accelerated and highly optimized for performance on Apple devices.

### Why Integration Is Tricky

* SwiftUI’s `Image` view is **not editable**.
* UIKit’s `UIImage` and Core Graphics’ `CGImage` also don’t directly support Core Image processing.
* Core Image works primarily with `CIImage`, which acts as a **recipe** for rendering an image, not the image itself.

### The Four Image Types

| Type      | Framework     | Purpose                                                       |
| --------- | ------------- | ------------------------------------------------------------- |
| `Image`   | SwiftUI       | View-only, cannot be edited                                   |
| `UIImage` | UIKit         | Editable, displayable, versatile format                       |
| `CGImage` | Core Graphics | Raw pixel data, used to render and convert                    |
| `CIImage` | Core Image    | Describes how to generate an image – the basis for processing |

### Image Conversion Workflow

To apply Core Image filters in SwiftUI, we follow this pipeline:

1. Load a **`UIImage`** from asset catalog
2. Convert it to a **`CIImage`**
3. Apply a **Core Image filter**
4. Use **`CIContext`** to render the filtered `CIImage` into a `CGImage`
5. Convert the `CGImage` into a **`UIImage`**
6. Convert that `UIImage` into a **SwiftUI `Image`**

### Setup Example: Applying a Sepia Filter

```swift
@State private var image: Image?

func loadImage() {
    let inputImage = UIImage(resource: .example)
    let beginImage = CIImage(image: inputImage)

    let context = CIContext()
    let currentFilter = CIFilter.sepiaTone()
    currentFilter.inputImage = beginImage
    currentFilter.intensity = 1

    guard let outputImage = currentFilter.outputImage else { return }
    guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

    let uiImage = UIImage(cgImage: cgImage)
    image = Image(uiImage: uiImage)
}
```

Use `.onAppear(perform: loadImage)` in your view to trigger it.

### Playing with Filters

You can easily swap filters using:

#### Pixellate:

```swift
let currentFilter = CIFilter.pixellate()
currentFilter.inputImage = beginImage
currentFilter.scale = 100
```

#### Crystallize:

```swift
let currentFilter = CIFilter.crystallize()
currentFilter.inputImage = beginImage
currentFilter.radius = 200
```

#### Twirl Distortion:

```swift
let currentFilter = CIFilter.twirlDistortion()
currentFilter.inputImage = beginImage
currentFilter.radius = 1000
currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
```

### Dynamically Setting Filter Parameters

Some filters accept different keys. You can query supported input keys like this:

```swift
let currentFilter = CIFilter.twirlDistortion()
currentFilter.inputImage = beginImage

let amount = 1.0
let inputKeys = currentFilter.inputKeys

if inputKeys.contains(kCIInputIntensityKey) {
    currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
}
if inputKeys.contains(kCIInputRadiusKey) {
    currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
}
if inputKeys.contains(kCIInputScaleKey) {
    currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
}
```

This older API (based on `setValue(_:forKey:)`) lets you **dynamically set filter parameters**, regardless of the specific filter being used.


### Recap

* Use `CIImage` for processing, `CGImage` for rendering, `UIImage` for conversion, and `Image` for SwiftUI display.
* Core Image is powerful, but not designed for Swift — the API is still string-based and verbose.
* Once you understand the conversion flow, you can easily swap and combine filters for creative effects.

---

## Using `ContentUnavailableView` in SwiftUI

SwiftUI’s `ContentUnavailableView` provides a clean, consistent UI for when your app has no content to show. It helps improve the user experience in empty states, such as when there’s no data, no search results, or the user hasn’t interacted with your app yet.

### When to Use It

* Onboarding: The user hasn't created any data yet
* Search: No results match the query
* Loading states that result in empty datasets
* Placeholder views for feature-based UI

Instead of showing a blank screen or a custom message, you can use a **built-in Apple-styled** placeholder UI with minimal effort.

### Basic Usage

```swift
ContentUnavailableView("No snippets", systemImage: "swift")
```

This will display:

* A large **Swift logo** from SF Symbols
* A title below it: “No snippets”

### Adding a Description

You can add a secondary line of text with additional context:

```swift
ContentUnavailableView(
    "No snippets",
    systemImage: "swift",
    description: Text("You don't have any saved snippets yet.")
)
```

Use `Text` so you can apply modifiers like `.font()`, `.foregroundColor()`, etc.

### Full Customization

You can also use custom views for the title, description, and even add **buttons**:

```swift
ContentUnavailableView {
    Label("No snippets", systemImage: "swift")
} description: {
    Text("You don't have any saved snippets yet.")
} actions: {
    Button("Create Snippet") {
        // create a snippet
    }
    .buttonStyle(.borderedProminent)
}
```

This version:

* Uses a `Label` for the title (icon + text)
* Shows styled description text
* Adds a button to guide the user toward the next step

### Benefits

* Native appearance with minimal code
* Encourages good UX for empty or transitional states
* Fully customizable with SwiftUI views
* Adapts well to accessibility and dynamic type

### Recap

`ContentUnavailableView` is a **simple but powerful** addition to your UI toolkit. Use it instead of showing blank screens or ad hoc messages — your users will appreciate the guidance and polish it provides.

---

## Day 64 – Project 13, part three

---

## Using `PhotosPicker` in SwiftUI

SwiftUI’s `PhotosPicker` gives you a clean, modern way to let users select one or more images from their photo library. It handles privacy, performance, and async loading by giving you a lightweight reference (`PhotosPickerItem`) until you're ready to load the image data.

### How It Works (5-Step Flow)

1. **Import the framework:**

```swift
import SwiftUI
import PhotosUI
```

2. **Create state properties:**

```swift
@State private var pickerItem: PhotosPickerItem?
@State private var selectedImage: Image?
```

3. **Add the `PhotosPicker` view:**

```swift
PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
```

4. **Watch for changes and load the image:**

```swift
.onChange(of: pickerItem) {
    Task {
        selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
    }
}
```

5. **Display the loaded image:**

```swift
selectedImage?
    .resizable()
    .scaledToFit()
```

> You can test this in the Simulator using built-in sample images.

### Example: Full Minimal Implementation

```swift
import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?

    var body: some View {
        VStack {
            selectedImage?
                .resizable()
                .scaledToFit()

            PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
        }
        .onChange(of: pickerItem) {
            Task {
                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
            }
        }
    }
}
```

### Supporting Multiple Image Selection

1. **Declare arrays:**

```swift
@State private var pickerItems = [PhotosPickerItem]()
@State private var selectedImages = [Image]()
```

2. **Use the array version of `PhotosPicker`:**

```swift
PhotosPicker("Select images", selection: $pickerItems, matching: .images)
```

3. **Display selected images:**

```swift
ScrollView {
    ForEach(0..<selectedImages.count, id: \.self) { i in
        selectedImages[i]
            .resizable()
            .scaledToFit()
    }
}
```

4. **Load them asynchronously:**

```swift
.onChange(of: pickerItems) {
    Task {
        selectedImages.removeAll()

        for item in pickerItems {
            if let loadedImage = try await item.loadTransferable(type: Image.self) {
                selectedImages.append(loadedImage)
            }
        }
    }
}
```

### Customizing `PhotosPicker`

#### Limit selection count:

```swift
PhotosPicker("Select images", selection: $pickerItems, maxSelectionCount: 3, matching: .images)
```

#### Custom label:

```swift
PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .images) {
    Label("Select a picture", systemImage: "photo")
}
```

#### Filter certain image types:

```swift
PhotosPicker(
    selection: $pickerItems,
    maxSelectionCount: 3,
    matching: .any(of: [.images, .not(.screenshots)])
) {
    Label("Select a picture", systemImage: "photo")
}
```

### Recap

* `PhotosPicker` is the modern, async-safe way to let users pick images in SwiftUI.
* The view returns a lightweight `PhotosPickerItem`, which you can load into SwiftUI `Image` views.
* You can support single or multiple selection, and filter exactly what media types are shown.

---

## Using `ShareLink` in SwiftUI

`ShareLink` in SwiftUI makes it easy for users to **export content** from your app — whether it's a URL, image, or custom data — to other apps like Messages, Mail, AirDrop, and more. It uses the native **iOS share sheet** for a consistent, system-wide experience.

### Basic Usage

Share a URL with just one line:

```swift
ShareLink(item: URL(string: "https://www.hackingwithswift.com")!)
```

This automatically creates a default "Share" button. On a real device, tapping it will bring up a list of apps and actions that support the data type.

### Adding Subject and Message

Some apps (like Mail or Messages) support a **subject** and **message**:

```swift
ShareLink(
    item: URL(string: "https://www.hackingwithswift.com")!,
    subject: Text("Learn Swift here"),
    message: Text("Check out the 100 Days of SwiftUI!")
)
```

> Not all apps use this metadata, but it’s helpful when supported.

### Customizing the Button

Replace the default share button with a custom label:

```swift
ShareLink(item: URL(string: "https://www.hackingwithswift.com")!) {
    Label("Spread the word about Swift", systemImage: "swift")
}
```

This gives you full control over the look and text of the share button.

### Sharing Images with a Preview

Even when sharing images, Apple recommends attaching a **preview** so recipients see what’s being shared.

```swift
let example = Image(.example)

ShareLink(item: example, preview: SharePreview("Singapore Airport", image: example)) {
    Label("Click to share", systemImage: "airplane")
}
```

The `SharePreview` provides a title and thumbnail so the user can recognize the shared content quickly.

### Why Use `ShareLink`

* Promotes data sharing with other apps and services
* Encourages user engagement and discoverability
* Supports custom preview metadata for clarity
* Works seamlessly with images, links, text, and more

### Recap

SwiftUI’s `ShareLink` gives you a modern, minimal-effort way to let users share your app’s content. Whether it's a link to your website or a photo created in-app, `ShareLink` connects your content to the broader ecosystem 
of iOS.

---

## Asking for App Store Reviews in SwiftUI

SwiftUI makes it simple to **prompt users for an App Store review** using a special environment value: `.requestReview`. Apple handles the entire user interface, frequency limits, and suppresses requests if a user has already reviewed your app.

### Why Use It

* Boost visibility and credibility on the App Store
* Seamlessly integrates with SwiftUI
* Apple ensures users aren't overwhelmed with prompts
* Automatically respects system settings and rate limits

### How It Works (3-Step Setup)

#### 1. **Import StoreKit**

```swift
import StoreKit
```

#### 2. **Access the Review Request Environment**

```swift
@Environment(\.requestReview) var requestReview
```

#### 3. **Trigger the Review Prompt**

```swift
Button("Leave a review") {
    requestReview()
}
```

**Important:** This only *requests* a review prompt. Apple might silently ignore it if:

* The system-wide prompt limit has been reached
* The user has already submitted a review
* The user has disabled review prompts

### Best Practices

* Don’t use a “Review” button as your only call to action
* Trigger `.requestReview()` **after meaningful moments** — e.g., completing a task, hitting a usage milestone, or submitting a form
* Apple recommends requesting reviews based on **engagement**, not time or session count

### Example: Review Trigger After Task

```swift
if tasksCompleted >= 5 {
    requestReview()
}
```

Or as part of a more complete interaction:

```swift
Button("Submit Feedback") {
    submitFeedback()
    requestReview()
}
```

### Recap

SwiftUI’s `.requestReview` environment value provides an **Apple-approved**, user-friendly way to ask for App Store reviews. Use it thoughtfully, and your most engaged users will help boost your app’s rating and visibility.

---

## Day 65 – Project 13, part four

---

## Instafilter: Initial User Interface Setup

This step focuses on building the **basic layout** for the Instafilter app. It includes image importing, an intensity slider for filters, and a share button — all wrapped in a `NavigationStack`.

### What We're Building

* A `NavigationStack` with the app title
* A tappable image display area
* A `Slider` to control Core Image filter intensity
* Buttons for changing the filter and sharing the image
* Conditional layout using `ContentUnavailableView`

### State Properties

Add these to `ContentView` to track image and filter intensity:

```swift
@State private var processedImage: Image?
@State private var filterIntensity = 0.5
```

### Basic Layout

Here’s the starting layout using SwiftUI:

```swift
NavigationStack {
    VStack {
        Spacer()

        if let processedImage {
            processedImage
                .resizable()
                .scaledToFit()
        } else {
            ContentUnavailableView(
                "No Picture",
                systemImage: "photo.badge.plus",
                description: Text("Tap to import a photo")
            )
        }

        Spacer()

        HStack {
            Text("Intensity")
            Slider(value: $filterIntensity)
        }
        .padding(.vertical)

        HStack {
            Button("Change Filter", action: changeFilter)

            Spacer()

            // Add share button here later
        }
    }
    .padding([.horizontal, .bottom])
    .navigationTitle("Instafilter")
}
```

> The two `Spacer()` views ensure the image area stays vertically centered while controls remain pinned to the bottom.

### Cleaner Button Actions

Keep action logic out of your view for better clarity and reusability:

```swift
func changeFilter() {
    // logic to update the Core Image filter
}
```

Then call it like this:

```swift
Button("Change Filter", action: changeFilter)
```

### Recap

* `@State` manages the image and slider values
* `ContentUnavailableView` shows a placeholder when no image is selected
* Layout is prepared for image selection, filter control, and sharing
* `changeFilter()` is separated for cleaner, maintainable code

---

## Photo Import with PhotosPicker

This step focuses on enabling users to select a photo from their library and display it in `ContentView`. Due to Core Image’s requirements, this involves a few important steps to bridge SwiftUI and UIKit image handling.

### 1️⃣ Setup: Import PhotosUI and Track Selection

Add this import to the top of your `ContentView.swift`:

```swift
import PhotosUI
```

Add a state property to track the selected photo item:

```swift
@State private var selectedItem: PhotosPickerItem?
```

### 2️⃣ Add PhotosPicker to the View

Wrap the image display area (or placeholder) inside a `PhotosPicker` so users can tap anywhere to import a photo:

```swift
PhotosPicker(selection: $selectedItem) {
    if let processedImage {
        processedImage
            .resizable()
            .scaledToFit()
    } else {
        ContentUnavailableView(
            "No Picture",
            systemImage: "photo.badge.plus",
            description: Text("Import a photo to get started")
        )
    }
}
```

> **Tip:** By default, this adds a blue tint to the placeholder for interactivity. Disable it with `.buttonStyle(.plain)` if you want no styling.

### 3️⃣ Loading the Selected Image for Core Image

Since SwiftUI `Image` can’t be directly used with Core Image filters, load the photo as `Data` and convert to `UIImage`.

Add this async method to `ContentView`:

```swift
func loadImage() {
    Task {
        guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
        guard let inputImage = UIImage(data: imageData) else { return }

        // more code to integrate with Core Image filters will come here
    }
}
```

### 4️⃣ Trigger Image Loading on Selection Change

Attach an `.onChange` modifier to respond whenever the user picks a new photo:

```swift
.onChange(of: selectedItem, loadImage)
```

Place this modifier on the `PhotosPicker` or elsewhere inside your `ContentView`.

---

## Applying Core Image Filters with SwiftUI

Now that your app lets users select an image, this step adds Core Image processing so users can apply a filter — starting with a sepia tone filter — and adjust its intensity using a slider.

### 1️⃣ Setup Core Image Imports

At the top of `ContentView.swift`, add these imports:

```swift
import CoreImage
import CoreImage.CIFilterBuiltins
```

### 2️⃣ Add Core Image Properties

Add a Core Image context and a filter property to your view:

```swift
@State private var currentFilter = CIFilter.sepiaTone()
let context = CIContext()
```

* **`context`** renders `CIImage` into a `CGImage`.
* **`currentFilter`** holds the filter being applied; starting with sepia tone.

### 3️⃣ Create the Processing Method

Add a method to apply the filter to the selected image, update the filter intensity, and update the displayed image:

```swift
func applyProcessing() {
    currentFilter.intensity = Float(filterIntensity)  // Core Image uses Float, not Double

    guard let outputImage = currentFilter.outputImage else { return }
    guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

    let uiImage = UIImage(cgImage: cgImage)
    processedImage = Image(uiImage: uiImage)
}
```

### 4️⃣ Update Image Loading to Use Core Image Filter

Modify your existing `loadImage()` method so it converts the selected `UIImage` into a `CIImage`, sets it on the filter, then applies processing:

```swift
func loadImage() {
    Task {
        guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
        guard let inputImage = UIImage(data: imageData) else { return }

        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey) // safer than using inputImage property

        applyProcessing()
    }
}
```

### 5️⃣ React to Intensity Slider Changes

The filter intensity slider modifies `filterIntensity`, but that alone doesn’t trigger reprocessing. Use `.onChange()` to watch for changes and call `applyProcessing()` again:

```swift
Slider(value: $filterIntensity)
    .onChange(of: filterIntensity, applyProcessing)
```

Attach this modifier to the slider, where the value changes directly.

### 6️⃣ Try It Out!

Run the app. You should now be able to:

* Select an image.
* See the sepia tone filter applied.
* Adjust the intensity slider to change the filter’s strength in real time.

> **Note:** Core Image is fast on actual devices but can be slow in the Simulator, so expect some lag there.

---

## Day 66 – Project 13, part five

--- 

## Let Users Choose Core Image Filters with a Confirmation Dialog

So far, your app applies a fixed sepia tone filter. Now, let's let users pick from many Core Image filters via a confirmation dialog — a slide-up menu of buttons on iPhone — and adjust the filter intensity dynamically.

### 1️⃣ Add State to Track Filter Selection Dialog

Add this property to your `ContentView`:

```swift
@State private var showingFilters = false
```

This controls whether the confirmation dialog is shown.

### 2️⃣ Show the Confirmation Dialog

Attach this modifier to your `NavigationStack`, just below `.navigationTitle(...)`:

```swift
.confirmationDialog("Select a filter", isPresented: $showingFilters) {
    // buttons here
}
```

### 3️⃣ Trigger the Dialog from Button

Modify your `changeFilter()` method to show the dialog:

```swift
func changeFilter() {
    showingFilters = true
}
```

### 4️⃣ Change `currentFilter` Property Type

Update `currentFilter` so it’s typed as the more general `CIFilter` instead of a specific protocol:

```swift
@State private var currentFilter: CIFilter = CIFilter.sepiaTone()
```

This lets you assign any filter, but you lose direct access to typed properties like `.intensity`.

### 5️⃣ Replace `.intensity` Property Use with `setValue(_:forKey:)`

Since `currentFilter` is now generic, replace this line in your processing code:

```swift
// old code
currentFilter.intensity = Float(filterIntensity)
```

with this safer, generic approach:

```swift
currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
```

### 6️⃣ Add a Method to Change Filters and Reload Image

Add this helper method to `ContentView`:

```swift
func setFilter(_ filter: CIFilter) {
    currentFilter = filter
    loadImage()
}
```

This changes the filter and reprocesses the current image.

### 7️⃣ Add Filter Buttons to Confirmation Dialog

Replace the `// buttons here` comment in the `.confirmationDialog` modifier with:

```swift
Button("Crystallize") { setFilter(CIFilter.crystallize()) }
Button("Edges") { setFilter(CIFilter.edges()) }
Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
Button("Pixellate") { setFilter(CIFilter.pixellate()) }
Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
Button("Vignette") { setFilter(CIFilter.vignette()) }
Button("Cancel", role: .cancel) { }
```

Feel free to add more filters using Xcode’s code completion on `CIFilter.`

### 8️⃣ Safely Set Filter Parameters Based on Supported Keys

The main challenge: not every filter supports the same input keys (`intensity`, `radius`, `scale`). Blindly setting an unsupported key causes crashes.

Replace this line in `applyProcessing()`:

```swift
currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
```

with:

```swift
let inputKeys = currentFilter.inputKeys

if inputKeys.contains(kCIInputIntensityKey) {
    currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
}
if inputKeys.contains(kCIInputRadiusKey) {
    currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
}
if inputKeys.contains(kCIInputScaleKey) {
    currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
}
```

This safely sets keys supported by the current filter and scales values for keys like radius and scale to produce visible effects.

### 9️⃣ Test Your App!

* Run the app.
* Select a photo.
* Tap “Change Filter” to bring up the confirmation dialog.
* Pick different filters.
* Adjust the intensity slider to see different effects.
* No more crashes from unsupported keys!

### Recap

* The `setFilter()` method calls `loadImage()`, which means the image reloads every time you change filters. For better performance, you could store the original image in a state property so you don’t have to reload it each time.
* The slider dynamically adapts to whatever keys the filter supports, making it flexible and reusable.

This adds powerful, safe dynamic filter selection to your Core Image + SwiftUI app!

---

## Final Features: Sharing & Review Requests

To finish the app, we’ll add two key features:

1. **Sharing** the filtered image using SwiftUI’s `ShareLink`.
2. **Prompting the user to review the app** after they’ve used it enough.

### 1️⃣ Add Image Sharing with ShareLink

Replace the `// share the picture` comment in your UI with this:

```swift
if let processedImage {
    ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
}
```

* This creates a share button only when an image is available.
* Tapping it shows the system share sheet with apps that can handle images.
* Test on a real device to see full sharing capabilities.

### 2️⃣ Prepare for Review Requests

First, import **StoreKit** at the top of your file:

```swift
import StoreKit
```

Next, add these two properties to your `ContentView`:

```swift
@AppStorage("filterCount") var filterCount = 0
@Environment(\.requestReview) var requestReview
```

* `filterCount` tracks how many times the user changed filters.
* `requestReview` gives you access to the App Store review prompt.

### 3️⃣ Update `setFilter()` to Count Filter Changes and Request Review

At the end of your existing `setFilter()` method, add:

```swift
filterCount += 1

if filterCount >= 20 {
    requestReview()
}
```

### 4️⃣ Run `setFilter()` on the Main Actor to Fix Compile Error

Swift requires UI work on the **main actor**, so update your method declaration like this:

```swift
@MainActor
func setFilter(_ filter: CIFilter) {
    currentFilter = filter
    loadImage()

    filterCount += 1

    if filterCount >= 20 {
        requestReview()
    }
}
```

This ensures the review prompt is called safely on the main thread.


### Testing Tip

For quicker testing, reduce `20` to `5` or any smaller number so you don’t have to change filters many times before seeing the review prompt.

### Final Step: Test Your App

* Import a photo.
* Change filters multiple times.
* Share the processed image.
* After enough filter changes, the review prompt will appear.

---

## Day 67 – Project 13, part six

---


## Challenges

### Challenge 1: Disable Controls When No Image Is Selected

Prevent users from interacting with sliders or filter changes until an image is loaded.

```swift
var hasImage: Bool {
    processedImage != nil
}

// Usage in UI
Slider(value: $filterIntensity)
    .disabled(!hasImage)

Button("Change Filter", action: changeFilter)
    .disabled(!hasImage)
```


### Challenge 2: Multiple Sliders for Filter Parameters

Added sliders for `filterRadius` and `filterScale`, updating Core Image inputs dynamically.

```swift
@State private var filterRadius = 100.0
@State private var filterScale = 1.0

HStack {
    Text("Radius")
    Slider(value: $filterRadius, in: 0...200)
        .onChange(of: filterRadius, applyProcessing)
        .disabled(!hasImage)
}

HStack {
    Text("Scale")
    Slider(value: $filterScale, in: 0...10)
        .onChange(of: filterScale, applyProcessing)
        .disabled(!hasImage)
}
```

In `applyProcessing()`:

```swift
let inputKeys = currentFilter.inputKeys

if inputKeys.contains(kCIInputIntensityKey) {
    currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
}
if inputKeys.contains(kCIInputRadiusKey) {
    currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
}
if inputKeys.contains(kCIInputScaleKey) {
    currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey)
}
```

### Challenge 3: Added Three New Core Image Filters

Expanded the filter selection dialog with more options:

```swift
.confirmationDialog("Select a filter", isPresented: $showingFilters) {
    Button("Bloom") { setFilter(CIFilter.bloom()) }
    Button("Color Invert") { setFilter(CIFilter.colorInvert()) }
    Button("Color Monochrome") { setFilter(CIFilter.colorMonochrome()) }
    // Existing filters...
    Button("Cancel", role: .cancel) { }
}
```

When selecting a filter:

```swift
@MainActor func setFilter(_ filter: CIFilter) {
    currentFilter = filter
    loadImage()
    
    filterCount += 1
    if filterCount >= 10 {
        requestReview()
    }
}
```

## Recap

* UI controls are only active when an image is loaded.
* Sliders adjust multiple Core Image filter parameters.
* New filters added for richer image effects.
* Share processed images with `ShareLink`.
* Requests App Store review after 10 filter changes.


