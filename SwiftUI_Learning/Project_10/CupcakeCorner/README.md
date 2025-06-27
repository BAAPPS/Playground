# Cupcake Corner Summary

---

## Day 49 – Project 10, part one

--- 

## Networking + Codable in SwiftUI

iOS provides built-in tools for networking using `URLSession`, and when combined with `Codable`, it's easy to convert Swift types to and from JSON. This project fetches data from Apple's iTunes Search API and displays it in a SwiftUI `List`.


### Data Model

We define two basic models conforming to `Codable`:

```swift
struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
````

### UI with Dynamic Data

Using SwiftUI, we declare a `@State` property to store the results and bind it to a `List`:

```swift
@State private var results = [Result]()

List(results, id: \.trackId) { item in
    VStack(alignment: .leading) {
        Text(item.trackName)
            .font(.headline)
        Text(item.collectionName)
    }
}
```

Initially, the list is empty. We then load data asynchronously and update the state.


### Asynchronous Networking

We use an `async` function and the `.task` view modifier to handle downloading without blocking the UI:

```swift
.task {
    await loadData()
}
```

Inside `loadData()`, we:

1. Construct the request URL.
2. Fetch data with `URLSession`.
3. Decode JSON into `Response` and assign it to the state.

```swift
func loadData() async {
    guard let url = URL(string: "https://itunes.apple.com/search?term=raymond+lam&entity=song") else {
        print("Invalid URL")
        return
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
            await MainActor.run {
                self.results = decodedResponse.results
            }
        }
    } catch {
        print("Invalid data")
    }
}
```


### Recap

* **async/await**: Used for asynchronous code that may pause execution, such as network calls.
* **Codable**: Automatically handles JSON encoding/decoding.
* **URLSession.shared**: Performs the network request with default configuration.
* **MainActor.run**: Ensures UI state updates happen on the main thread.

---

## AsyncImage in SwiftUI: Loading Remote Images

SwiftUI’s `Image` view works well with local assets, but if you want to load an image from the internet, you need to use `AsyncImage`. SwiftUI handles downloading, caching, and displaying the image with minimal effort.


### Basic Usage

To display a remote image, use:

```swift
AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
````

SwiftUI downloads the image and displays it automatically, but sizing may be incorrect because SwiftUI doesn’t know the image dimensions ahead of time.


### Fixing Image Size with Scale

If you know the scale of your image (e.g. 3x for @3x images), you can hint it to SwiftUI:

```swift
AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 3)
```

This ensures the image is sized more appropriately for the screen.


### Resizing the Image

If you want to constrain the image to a specific size:

```swift
AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
    image
        .resizable()
        .scaledToFit()
} placeholder: {
    Color.red
}
.frame(width: 200, height: 200)
```

This approach gives you:

* Access to the loaded `Image` for customization.
* A customizable placeholder (e.g., `Color.red` or `ProgressView()`).
* Proper behavior with `.resizable()` and `.frame()`.


### Placeholder Options

You can use a wide range of placeholders while the image loads, including:

```swift
placeholder: {
    ProgressView()
}
```

This adds a loading spinner while the image is being downloaded.


### Advanced AsyncImage: Handling Load Phases

If you want full control (loading, success, and error states), use the `AsyncImagePhase` initializer:

```swift
AsyncImage(url: URL(string: "https://hws.dev/img/bad.png")) { phase in
    if let image = phase.image {
        image
            .resizable()
            .scaledToFit()
    } else if phase.error != nil {
        Text("There was an error loading the image.")
    } else {
        ProgressView()
    }
}
.frame(width: 200, height: 200)
```

### Supported States:

* `phase.image`: The image loaded successfully.
* `phase.error`: The image failed to load.
* `default`: The image is still loading.

### Recap

`AsyncImage` simplifies remote image loading in SwiftUI. You can:

* Display remote images with a single line.
* Customize the image and placeholder views.
* Handle errors gracefully using loading phases.

This makes `AsyncImage` a powerful tool for modern, network-aware SwiftUI apps.

--- 

## SwiftUI Form Input with Validation

SwiftUI’s `Form` view provides a fast and convenient way to gather user input. However, validating that input before allowing the user to proceed is just as important. Fortunately, SwiftUI makes this simple with the `.disabled()` modifier.

### Basic Form Setup

Here's a basic form that takes a username and email address:

```swift
struct ContentView: View {
    @State private var username = ""
    @State private var email = ""

    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }

            Section {
                Button("Create account") {
                    print("Creating account…")
                }
            }
        }
    }
}
````

### Disabling Buttons Based on Input

We don’t want users to proceed unless both fields are filled in. We can disable the "Create account" button using `.disabled()`:

```swift
Section {
    Button("Create account") {
        print("Creating account…")
    }
}
.disabled(username.isEmpty || email.isEmpty)
```

This ensures the button is only enabled when both fields contain input.


### Using Computed Properties for Validation

For better readability and reuse, you can extract your validation logic into a computed property:

```swift
var disableForm: Bool {
    username.count < 5 || email.count < 5
}
```

Then reference that property in your `.disabled()` modifier:

```swift
.disabled(disableForm)
```

This makes it easier to scale or tweak validation rules later.


### Try It Out

When the form loads:

* The "Create account" button will be **disabled (gray)** if the username or email is too short.
* As soon as both fields have enough input (e.g., at least 5 characters), the button becomes **active (blue)**.


### Recap

#### What You Learned:

* How to build a simple `Form` in SwiftUI.
* How to disable interactive elements using `.disabled()`.
* How to create computed properties for clean validation logic.

#### When to Use This:

* To prevent form submission until required fields are valid.
* To guide user behavior in real-time with immediate feedback.
* To improve app UX and reduce invalid submissions.

---

## Day 50 – Project 10, part two

--

## Codable with @Observable in Swift

Swift automatically synthesizes `Codable` conformance for types whose properties are themselves `Codable`. However, when using the `@Observable` macro (from the SwiftData or SwiftUI macros system), things get more complicated due to how Swift rewrites the class behind the scenes.


### The Problem: Leaking Internal Details

Here's a minimal example:

```swift
@Observable
class User: Codable {
    var name = "Taylor"
}
````

You might expect encoding this with `JSONEncoder` to produce `{"name":"Taylor"}`. But when you try:

```swift
struct ContentView: View {
    var body: some View {
        Button("Encode Taylor", action: encodeTaylor)
    }

    func encodeTaylor() {
        let data = try! JSONEncoder().encode(User())
        let str = String(decoding: data, as: UTF8.self)
        print(str)
    }
}
```

You get:

```json
{"_name":"Taylor","_$observationRegistrar":{}}
```

####  What's Going On?

The `@Observable` macro rewrites your class to support SwiftUI’s data flow system:

* `name` becomes `_name`
* Extra properties like `_$observationRegistrar` get injected

This "leaks" Swift's internal implementation into your JSON, which breaks expectations and causes issues in APIs that don’t expect these names.


### The Solution: Custom `CodingKeys`

To prevent internal SwiftUI observation data from being included in JSON, you must manually specify what should be encoded and how.

```swift
@Observable
class User: Codable {
    enum CodingKeys: String, CodingKey {
        case _name = "name"
    }

    var name = "Taylor"
}
```

#### What This Does:

* Maps `_name` (the actual stored property) to `"name"` in the JSON
* Prevents `_$observationRegistrar` and other internal SwiftUI types from leaking into the encoded output
* Ensures decoding `"name"` back into `_name` works seamlessly

### Recap

#### When to Use This:

* Any time you’re using `@Observable` and need to serialize your data (e.g., saving to disk, sending to a server)
* When default `Codable` behavior breaks due to macro-generated backing variables

#### Key Takeaways:

* `@Observable` rewrites class internals for observation
* Swift’s default `Codable` behavior exposes those internals
* Use a custom `CodingKeys` enum to map between real JSON keys and internal property names

---

## Haptic Feedback in SwiftUI

SwiftUI offers built-in support for haptic feedback using Apple’s Taptic Engine, allowing you to trigger vibrations in response to user actions. You can choose between **easy built-in options** or **advanced custom haptics** using the `CoreHaptics` framework.

> ⚠️ Haptic feedback works **only on physical iPhones**. It does not function on Macs or most iPads.

### Basic Haptics with `.sensoryFeedback()`

The simplest way to add haptic feedback is by attaching `.sensoryFeedback()` to a view. Here’s a counter example:

```swift
struct ContentView: View {
    @State private var counter = 0

    var body: some View {
        Button("Tap Count: \(counter)") {
            counter += 1
        }
        .sensoryFeedback(.increase, trigger: counter)
    }
}
````

### Supported Built-in Feedback Types

Some commonly used types:

* `.increase`
* `.success`
* `.warning`
* `.error`
* `.start`
* `.stop`

These are good defaults that ensure consistent and meaningful tactile feedback across the system.


### Intermediate: `.impact()` Variants

To fine-tune how feedback feels, use `.impact()` with optional customization:

```swift
// Soft, mild tap
.sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: counter)

// Strong, heavy tap
.sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: counter)
```

These allow you to simulate soft or heavy collisions and fine-tune the effect.


### Advanced Haptics with `CoreHaptics`

For full control over vibration patterns, use `CoreHaptics`. First, import the framework:

```swift
import CoreHaptics
```

#### 1. Prepare the Haptic Engine

```swift
@State private var engine: CHHapticEngine?

func prepareHaptics() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

    do {
        engine = try CHHapticEngine()
        try engine?.start()
    } catch {
        print("Engine creation error: \(error.localizedDescription)")
    }
}
```

#### 2. Create a Simple Haptic Tap

```swift
func complexSuccess() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

    var events = [CHHapticEvent]()
    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
    events.append(event)

    do {
        let pattern = try CHHapticPattern(events: events, parameters: [])
        let player = try engine?.makePlayer(with: pattern)
        try player?.start(atTime: 0)
    } catch {
        print("Failed to play pattern: \(error.localizedDescription)")
    }
}
```

#### 3. Connect to a Button

```swift
Button("Tap Me", action: complexSuccess)
    .onAppear(perform: prepareHaptics)
```


### Custom Haptic Sequences

To generate multiple taps with increasing and decreasing intensity:

```swift
for i in stride(from: 0, to: 1, by: 0.1) {
    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
    events.append(event)
}

for i in stride(from: 0, to: 1, by: 0.1) {
    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
    events.append(event)
}
```

This creates a smooth up-and-down ramp of haptic taps.


### Recap

#### When to Use:

* Use `.sensoryFeedback()` for simple, meaningful effects tied to UI actions.
* Use `.impact()` if you want physical-feeling interactions.
* Use `CoreHaptics` for rich, precise control over tactile feedback.

#### Considerations:

* Respect accessibility: don’t use success-style feedback for errors.
* Always test haptics on a real device.
* Avoid overusing haptics – subtlety improves experience.

Haptics are an easy and powerful way to improve app interactivity when used thoughtfully.

---

## CupcakeCorner: Order Screen Setup

This stage of the CupcakeCorner app introduces a form-based screen for gathering cupcake order details. The screen allows users to select cupcake type, quantity, and customizations, and uses shared state across views via an observable class.


### Data Model: `Order`

We define a single shared `Order` class that stores all order data and uses Swift’s `@Observable` macro so UI updates are reflected automatically.

### `Order.swift`

```swift
import SwiftUI

@Observable
class Order {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }

    var extraFrosting = false
    var addSprinkles = false
}
````

This class:

* Stores cupcake types and user selections
* Automatically disables custom options when the main toggle is off
* Will be shared across multiple screens using state

In `ContentView`, add the shared instance:

```swift
@State private var order = Order()
```

### Building the Order Form

The order screen is made up of **three form sections**:

1. **Cake type and quantity**
2. **Special requests**
3. **Navigation to address screen**

Wrap everything in a `NavigationStack`.

#### Section 1: Type & Quantity

```swift
Section {
    Picker("Select your cake type", selection: $order.type) {
        ForEach(Order.types.indices, id: \.self) {
            Text(Order.types[$0])
        }
    }

    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
}
```

> Using `Order.types.indices` ensures safe binding between the picker and the static array.

#### Section 2: Special Requests

```swift
Section {
    Toggle("Any special requests?", isOn: $order.specialRequestEnabled)

    if order.specialRequestEnabled {
        Toggle("Add extra frosting", isOn: $order.extraFrosting)
        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
    }
}
```

> When `specialRequestEnabled` is toggled off, both `extraFrosting` and `addSprinkles` are reset to `false`.

#### Section 3: Delivery Navigation

We create a basic second screen `AddressView.swift`:

```swift
struct AddressView: View {
    var order: Order

    var body: some View {
        Text("Hello World")
    }
}
```

Back in `ContentView.swift`, add:

```swift
Section {
    NavigationLink("Delivery details") {
        AddressView(order: order)
    }
}
```

---

## Day 51 – Project 10, part three

---

## Step 2: Address Entry & Validation

In this step, users can enter delivery details through a form. We validate the data to ensure it's complete before allowing users to continue to checkout.


### Updating the `Order` Model

We expand the `Order` class to store delivery information and a computed validation check.

#### New Properties

```swift
var name = ""
var streetAddress = ""
var city = ""
var zip = ""
````

#### Address Validation

```swift
var hasValidAddress: Bool {
    if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
        return false
    }
    return true
}
```

### Creating the Checkout View

Before implementing validation, we create a stub for the final screen.

#### `CheckoutView.swift`

```swift
struct CheckoutView: View {
    var order: Order

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    CheckoutView(order: Order())
}
```


### Implementing `AddressView`

In this view, users fill out their name, street, city, and ZIP using a `Form`, then navigate to checkout.

#### Bindable Order

We change the order property to allow two-way binding:

```swift
@Bindable var order: Order
```

> This is required because we're receiving a shared observable class from the previous screen.

#### Address Form UI

```swift
Form {
    Section {
        TextField("Name", text: $order.name)
        TextField("Street Address", text: $order.streetAddress)
        TextField("City", text: $order.city)
        TextField("Zip", text: $order.zip)
    }

    Section {
        NavigationLink("Check out") {
            CheckoutView(order: order)
        }
    }
    .disabled(order.hasValidAddress == false)
}
.navigationTitle("Delivery details")
.navigationBarTitleDisplayMode(.inline)
```

### Recap

* **@Bindable** bridges our `Order` class into the SwiftUI data flow.
* Using `Form` gives us grouped UI fields with built-in behavior.
* The `.disabled()` modifier prevents progressing until the address is valid.
* Navigation is preserved because all views share the same `Order` instance.

#### UX: Persistent Shared State

Thanks to the use of a class and shared reference (`Order`), data entered on any screen is preserved across navigation. Going back and forth won't lose user input — no extra code needed!

---

## Order Pricing Logic

Pricing is determined by combining the base cost per cake with any customizations:

- **Base cost:** $2 per cupcake
- **Extra cost for complicated cakes**
- **+ $1/cake** for extra frosting
- **+ $0.50/cake** for sprinkles

We add a computed property in `Order.swift` to encapsulate all this logic:

```swift
var cost: Decimal {
    // $2 per cake
    var cost = Decimal(quantity) * 2

    // Complicated cakes cost more
    cost += Decimal(type) / 2

    // $1 per cake for extra frosting
    if extraFrosting {
        cost += Decimal(quantity)
    }

    // $0.50 per cake for sprinkles
    if addSprinkles {
        cost += Decimal(quantity) / 2
    }

    return cost
}
````

### CheckoutView UI Layout

The layout includes:

* A cupcake image loaded from a remote URL via `AsyncImage`
* The total cost of the order
* A **Place Order** button

### `CheckoutView.swift`

```swift
ScrollView {
    VStack {
        AsyncImage(
            url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),
            scale: 3
        ) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(height: 233)

        Text("Your total is \(order.cost, format: .currency(code: "USD"))")
            .font(.title)

        Button("Place Order", action: { })
            .padding()
    }
}
.navigationTitle("Check out")
.navigationBarTitleDisplayMode(.inline)
.scrollBounceBehavior(.basedOnSize)
```

### Recap

* **AsyncImage** is used to load a remote cupcake image. This allows future seasonal swaps.
* **.scrollBounceBehavior(.basedOnSize)** improves UX by preventing scroll bounce unless needed.
* The **cost** is calculated dynamically from user selections.
* The **Place Order** button is connected but does nothing yet — it will be wired to submit the order during the networking step.

---

## Networking & Sending Orders with URLSession

iOS provides powerful networking tools, especially the `URLSession` class, which combined with `Codable` lets us send and receive JSON data easily. Using `URLRequest`, we can fully customize how we send data.


### 1. Add an Asynchronous Place Order Method

First, create an async method in `CheckoutView` to handle placing the order:

```swift
func placeOrder() async {
    // Networking code will go here
}
````

Update the **Place Order** button to call this asynchronously by wrapping the call in a `Task`:

```swift
Button("Place Order") {
    Task {
        await placeOrder()
    }
}
.padding()
```

This is necessary because button actions don’t support `async` directly.


### 2. Encode the Order as JSON

Inside `placeOrder()`, encode the current order using `JSONEncoder`:

```swift
guard let encoded = try? JSONEncoder().encode(order) else {
    print("Failed to encode order")
    return
}
```

> **Note:** Make sure the `Order` class conforms to `Codable` by updating its declaration:

```swift
class Order: Codable {
    // existing properties...
}
```

### 3. Configure the URLRequest

Create and configure a `URLRequest` to specify URL, HTTP method, and headers:

```swift
let url = URL(string: "https://reqres.in/api/cupcakes")!
var request = URLRequest(url: url)
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpMethod = "POST"
```

* We use POST because we are sending data.
* The content type is set to JSON to inform the server how to interpret the data.


### 4. Perform the Network Upload

Use `URLSession.shared.upload` to send the encoded data asynchronously:

```swift
do {
    let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
    // handle response here
} catch {
    print("Checkout failed: \(error.localizedDescription)")
}
```

### 5. Decode the Server Response & Show Confirmation

We expect the server to echo back our order. Decode it with `JSONDecoder`, then set a confirmation message and show an alert:

Add these properties to `CheckoutView` for managing the alert:

```swift
@State private var confirmationMessage = ""
@State private var showingConfirmation = false
```

Attach this alert modifier inside `CheckoutView`:

```swift
.alert("Thank you!", isPresented: $showingConfirmation) {
    Button("OK") { }
} message: {
    Text(confirmationMessage)
}
```

Complete the success handling inside `placeOrder()`:

```swift
let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
showingConfirmation = true
```

If decoding fails, print an error (already handled in the catch block).

### 6. Debugging with Breakpoints and LLDB

When dealing with networking bugs or unexpected API responses, **LLDB** is an invaluable tool in Xcode’s debugger console.

* **Set a breakpoint** (e.g., at the start of your `placeOrder()` function or where you encode the order).
* Run your app in debug mode; when it pauses at the breakpoint, open the **LLDB console** at the bottom of Xcode (View > Debug Area > Activate Console or `⇧⌘C`).
* Use this command to inspect your encoded JSON data as a readable string:

```lldb
p String(decoding: encoded, as: UTF8.self)
```

This prints the exact JSON sent over the network, helping you verify property names and values.

Similarly, you can print the raw response data (after the upload) to see what the server actually returned:

```swift
if let rawResponse = String(data: data, encoding: .utf8) {
    print("Server response: \(rawResponse)")
}
```

Without these debugging steps, issues like missing API keys or unexpected JSON formats can cause silent decode failures that are tricky to trace.


### 7. Fixing Coding Keys for Clean JSON

Because of the `@Observable` macro rewriting, property names in JSON have underscores (e.g. `_type`) which servers won’t understand.

To fix this, add a nested `CodingKeys` enum to `Order` to map underscored properties back to clean JSON keys:

```swift
enum CodingKeys: String, CodingKey {
    case _type = "type"
    case _quantity = "quantity"
    case _specialRequestEnabled = "specialRequestEnabled"
    case _extraFrosting = "extraFrosting"
    case _addSprinkles = "addSprinkles"
    case _name = "name"
    case _city = "city"
    case _streetAddress = "streetAddress"
    case _zip = "zip"
}
```

After adding this, rerun the app and check the JSON again — it will now use the proper property names.


### 🛑 Problem Encountered: Missing API Key & Decoding Failure

Initially, the tutorial didn’t mention that the `reqres.in` API **requires an API key** for POST requests. Without this key, the server responded with an error JSON:

```json
{"error":"Missing API key.","how_to_get_one":"https://reqres.in/signup"}
```

Your app tried to decode this error response as an `Order` object, causing the decoding to fail with:

> *"The data couldn’t be read because it is missing."*

---

### ✅ Solution: Add API Key & Update Model for Response

* After obtaining your free API key (`reqres-free-v1`), you must add it as a header in the request:

```swift
request.setValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
```

* The API then started returning your order back with extra fields like `id` and `createdAt`:

```json
{
  "name": "",
  "type": 0,
  "specialRequestEnabled": false,
  "streetAddress": "",
  "zip": "",
  "extraFrosting": false,
  "addSprinkles": false,
  "quantity": 3,
  "city": "",
  "id": "697",
  "createdAt": "2025-06-27T15:57:58.187Z"
}
```

* To decode successfully, update your `Order` model to include these new optional properties:

```swift
var id: String? = nil
var createdAt: String? = nil
```

Alternatively, create a separate response struct matching the server’s response to decode the returned data:

```swift
struct OrderResponse: Codable {
    let id: String
    let createdAt: String
    let name: String
    let type: Int
    let specialRequestEnabled: Bool
    let streetAddress: String
    let zip: String
    let extraFrosting: Bool
    let addSprinkles: Bool
    let quantity: Int
    let city: String
}
```

---

## Day 52 – Project 10, part four

---

## Completed Challenges

### 1. Improved Address Validation

- Updated the delivery address validation logic to **disallow empty or whitespace-only inputs**.
- This ensures users enter meaningful address data before proceeding.
- Validation now trims whitespace and checks for emptiness on all address fields: Name, Street Address, City, and Zip.

```swift
var hasValidAddress: Bool {
    let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedStreet = streetAddress.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedZip = zip.trimmingCharacters(in: .whitespacesAndNewlines)

    return !trimmedName.isEmpty && !trimmedStreet.isEmpty && !trimmedCity.isEmpty && !trimmedZip.isEmpty
}
````

### 2. User-Friendly Network Failure Alerts

* Added error handling in the `placeOrder()` asynchronous function to catch network failures (e.g., no internet connection).
* If the network request fails, an informative alert is presented to the user with the error description.
* This improves user experience by clearly communicating problems during checkout.

```swift
@State private var errorMessage = ""
@State private var showingError = false

// In placeOrder catch block:
catch {
    errorMessage = "Order failed: \(error.localizedDescription)"
    showingError = true
}
```


### 3. Persistent Order Data Storage Using UserDefaults

* Implemented saving and loading of `OrderModel` data as JSON in `UserDefaults`.
* Because `@AppStorage` does not support complex `Codable` types or observable classes, this manual encoding/decoding approach preserves user input between app launches.


```swift
extension OrderModel {
    private static let saveKey = "SavedOrder"

    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }

    static func load() -> OrderModel {
        if let savedData = UserDefaults.standard.data(forKey: saveKey),
           let decodedOrder = try? JSONDecoder().decode(OrderModel.self, from: savedData) {
            return decodedOrder
        }
        return OrderModel()
    }
}
```

* Data is saved when the user taps **Check out**, ensuring the latest delivery details are persisted.

```swift
struct AddressView: View {
    @Bindable var order: OrderModel
    @State private var showingCheckout = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $order.name)
                    TextField("Street Address", text: $order.streetAddress)
                    TextField("City", text: $order.city)
                    TextField("Zip", text: $order.zip)
                }

                Section {
                    Button("Check out") {
                        order.save()      // Save order here
                        showingCheckout = true
                    }
                    .disabled(order.hasValidAddress == false)
                }
            }
            .navigationTitle("Delivery details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showingCheckout) {
                CheckoutView(order: order)
            }
        }
    }
}

```
---

### Usage Notes

* The app uses **SwiftUI's `NavigationStack`** and `.navigationDestination(isPresented:)` for navigation (iOS 16+).
* The `AddressView` saves order data just before navigating to the checkout screen.
* Alerts provide clear feedback on success or failure of network requests.
* Address validation prevents users from submitting incomplete or invalid information.

---

### Recap

These enhancements make the app more robust and user-friendly by:

* Preventing invalid address inputs.
* Providing clear, actionable error messages on network failures.
* Persisting user input so they don’t lose data when navigating or restarting the app.


