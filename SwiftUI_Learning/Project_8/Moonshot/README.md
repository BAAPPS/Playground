# Moonshot Summary

---

## Day 39 – Project 8, part one

---

## Image Sizing in SwiftUI

SwiftUI's `Image` view automatically sizes itself to match its image's native dimensions, which can be too large for most layouts. This guide explains how to properly size and scale images, including how to use relative 
frames to make images adapt to screen size dynamically.

### Default Image Behavior

By default:

```swift
Image("Example")
```

An image will appear at its full size, such as 1000x500, which can easily overflow the screen.

### ⚠️ Common Mistake with `.frame()`

Simply applying a `.frame(width: height:)` doesn't resize the image content—it only changes the frame **around** the image.

```swift
Image(.example)
    .frame(width: 300, height: 300)
```

You’ll see a 300x300 box, but the image itself remains oversized unless modified.

### ✅ Resizing the Image

To make the image content actually scale to the frame, use `.resizable()`:

```swift
Image(.example)
    .resizable()
    .frame(width: 300, height: 300)
```

However, this may distort the image if its aspect ratio differs from the frame.

### Maintain Aspect Ratio

Use `.scaledToFit()` or `.scaledToFill()` to preserve proportions:

* **Fit** keeps the whole image visible, possibly leaving empty space:

```swift
Image(.example)
    .resizable()
    .scaledToFit()
    .frame(width: 300, height: 300)
```

* **Fill** covers the entire frame but may crop parts of the image:

```swift
Image(.example)
    .resizable()
    .scaledToFill()
    .frame(width: 300, height: 300)
```

### Dynamic Sizing with `containerRelativeFrame`

Instead of fixed dimensions, you can scale images based on screen size:

```swift
Image(.example)
    .resizable()
    .scaledToFit()
    .containerRelativeFrame(.horizontal) { size, axis in
        size * 0.8
    }
```

This will:

* Make the image fill 80% of the screen’s width.
* Automatically compute the height to maintain the aspect ratio.

SwiftUI handles the math for you based on the container’s size and the image’s original aspect ratio.


### Recap

* Use `.resizable()` to scale image content.
* Use `.scaledToFit()` or `.scaledToFill()` for aspect ratio control.
* Use `.containerRelativeFrame()` for responsive layouts.

---

## Using ScrollView in SwiftUI

SwiftUI’s `ScrollView` provides a flexible way to scroll through **arbitrary content**, not just lists or forms. You can scroll vertically, horizontally, or in both directions, and fully control the content and layout 
behavior.


### ScrollView Basics

To scroll through manually created views, wrap them inside a `ScrollView`. For example:

```swift
ScrollView {
    VStack(spacing: 10) {
        ForEach(0..<100) {
            Text("Item \($0)")
                .font(.title)
        }
    }
}
```

* This creates a vertical scroll view.
* Content respects the safe area.
* It’s scrollable by default but only in areas where the view exists.


### Improving Touch Interactions

By default, `VStack` takes up only the needed width, which may limit scroll interactions. To fix that, expand the width:

```swift
ScrollView {
    VStack(spacing: 10) {
        ForEach(0..<100) {
            Text("Item \($0)")
                .font(.title)
        }
    }
    .frame(maxWidth: .infinity)
}
```

This allows tapping and dragging **anywhere** on the screen for a smoother experience.

### ⚠️ Performance Warning: Eager Loading

All views inside a standard `ScrollView` are created **immediately**, even if they're off-screen.

Example:

```swift
struct CustomText: View {
    let text: String

    var body: some View {
        Text(text)
    }

    init(_ text: String) {
        print("Creating a new CustomText")
        self.text = text
    }
}
```

Using it in a scroll view:

```swift
ForEach(0..<100) {
    CustomText("Item \($0)")
        .font(.title)
}
```

This will print "Creating a new CustomText" **100 times**, because SwiftUI eagerly builds every view.


### Optimize with Lazy Stacks

To avoid eager loading, use `LazyVStack` or `LazyHStack`:

```swift
ScrollView {
    LazyVStack(spacing: 10) {
        ForEach(0..<100) {
            CustomText("Item \($0)")
                .font(.title)
        }
    }
    .frame(maxWidth: .infinity)
}
```

Lazy stacks load views **on-demand** as they appear on screen, improving performance for long content.

> ⚠️ Lazy stacks always take up all available space in the layout, unlike regular stacks which size to fit their content.

### Horizontal ScrollViews

You can make scroll views scroll horizontally by specifying `.horizontal`:

```swift
ScrollView(.horizontal) {
    LazyHStack(spacing: 10) {
        ForEach(0..<100) {
            CustomText("Item \($0)")
                .font(.title)
        }
    }
}
```

Use `LazyHStack` for performance, and ensure the internal layout matches the scroll direction.

### Recap

* Use `ScrollView` for freeform, scrollable layouts.
* Wrap content in `.frame(maxWidth: .infinity)` for better gesture support.
* Use `LazyVStack`/`LazyHStack` to **defer view creation** and save resources.
* Use `.horizontal` for horizontal scrolling.
* Understand that lazy stacks take up all available layout space by default.

---


## Navigation in SwiftUI with NavigationStack

SwiftUI’s `NavigationStack` provides a powerful, native way to navigate between views, mimicking the familiar stack-based navigation seen in apps like Settings or Messages. It also automatically handles navigation bars and 
back buttons with elegant animations.


### What is NavigationStack?

`NavigationStack` is a container that:

* Displays a navigation bar.
* Lets you **push** new views onto a **view stack**.
* Automatically adds a back button and enables swipe-to-go-back gestures.

Example of basic usage:

```swift
NavigationStack {
    Text("Tap Me")
        .navigationTitle("SwiftUI")
}
```

At this point, the text is static and non-interactive.


### Adding Navigation with NavigationLink

To move from one view to another, wrap tappable content in a `NavigationLink`.

```swift
NavigationStack {
    NavigationLink("Tap Me") {
        Text("Detail View")
    }
    .navigationTitle("SwiftUI")
}
```

Tapping "Tap Me" pushes a new view onto the navigation stack with a smooth transition, and the title transforms into a back button.


### Custom Labels with NavigationLink

You’re not limited to text-only labels—use complex views as tappable content:

```swift
NavigationStack {
    NavigationLink {
        Text("Detail View")
    } label: {
        VStack {
            Text("This is the label")
            Text("So is this")
            Image(systemName: "face.smiling")
        }
        .font(.largeTitle)
    }
}
```

This gives full creative control over how your navigation link appears.


### NavigationStack vs. sheet()

| Feature     | `NavigationLink`      | `.sheet()`                         |
| ----------- | --------------------- | ---------------------------------- |
| Purpose     | Drill-down navigation | Present unrelated or modal views   |
| Behavior    | Pushes onto stack     | Slides up modally                  |
| Example Use | Showing item details  | Showing settings or compose screen |

Choose based on how related the new screen is to the current context.


### Using NavigationLink in Lists

One of the most common use cases for `NavigationLink` is inside a `List`. SwiftUI even automatically adds the iOS-style disclosure indicator:

```swift
NavigationStack {
    List(0..<100) { row in
        NavigationLink("Row \(row)") {
            Text("Detail \(row)")
        }
    }
    .navigationTitle("SwiftUI")
}
```

* Each row is tappable.
* SwiftUI shows the disclosure indicator automatically.
* Tapping a row navigates to the corresponding detail view.

If you remove `NavigationLink`, the indicators disappear—proving SwiftUI is smart enough to infer user expectations.


### Recap

* `NavigationStack` is SwiftUI’s way to manage a navigation bar and stack of views.
* `NavigationLink` handles pushing new views into the stack.
* Use `.sheet()` when the new view is not part of a drill-down hierarchy.
* Lists work seamlessly with `NavigationLink` for building classic navigation tables.
* Customize both the **label** and **destination** to fit your UI needs.

---

## Decoding Nested JSON with Codable in Swift

Swift's `Codable` protocol makes it simple to decode structured JSON — even with nested arrays and objects. When working with hierarchical data, you only need to mirror that structure using Swift `struct`s, and Swift takes 
care of the rest.


### Codable and Flat Data

For flat data (e.g. a single object or an array of objects), decoding with `Codable` **"Just Works"** with minimal setup.

Example:

```swift
struct Person: Codable {
    let name: String
}
```

But when your data has **nested objects**, you’ll need multiple nested types.

### Example: Decoding Nested JSON

Let’s look at some sample JSON:

```json
{
    "name": "Taylor Swift",
    "address": {
        "street": "555, Taylor Swift Avenue",
        "city": "Nashville"
    }
}
```

This JSON has a nested object: `address`. To decode it, define two corresponding Swift structs:

```swift
struct User: Codable {
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let city: String
}
```

### Decoding in SwiftUI

To decode this inside a SwiftUI view, you could add a button like so:

```swift
Button("Decode JSON") {
    let input = """
    {
        "name": "Taylor Swift",
        "address": {
            "street": "555, Taylor Swift Avenue",
            "city": "Nashville"
        }
    }
    """
    
    let data = Data(input.utf8)
    let decoder = JSONDecoder()

    if let user = try? decoder.decode(User.self, from: data) {
        print(user.address.street)
    }
}
```

When the button is tapped, the JSON string is converted to `Data`, decoded into a `User` instance, and prints the street address.


### Displaying Nested Data: sheet vs NavigationLink

When decoding and displaying nested JSON data such as a user's address, you may choose to show the details using a **modal sheet** or a **navigation link**. Each has its ideal use case depending on context.

#### The JSON Structure

```json
{
  "name": "Taylor Swift",
  "address": {
    "street": "555, Taylor Swift Avenue",
    "city": "Nashville"
  }
}
```

#### Option 1: Using `.sheet` for Modal Presentation

This approach presents the address in a modal sheet after decoding.

```swift
struct ContentView: View {
    @State private var showAddressDetails = false

    var body: some View {
        Button("Decode JSON") {
            showAddressDetails = true
        }
        .sheet(isPresented: $showAddressDetails) {
            let input = """
            {
                "name": "Taylor Swift",
                "address": {
                    "street": "555, Taylor Swift Avenue",
                    "city": "Nashville"
                }
            }
            """
            let data = Data(input.utf8)
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                VStack {
                    Text("Street: \(user.address.street)")
                    Text("City: \(user.address.city)")
                }
                .padding()
            }
        }
    }
}
```

* ✅ Good for modal, temporary views.
* 🚫 Not ideal for showing related or hierarchical data.

#### Option 2: Using `NavigationLink` for Drill-Down Navigation

This approach uses a navigation stack to drill down into the address details after decoding the user.

```swift
struct ContentView: View {
    @State private var user: User?

    var body: some View {
        NavigationStack {
            VStack {
                Button("Decode JSON") {
                    let input = """
                    {
                        "name": "Taylor Swift",
                        "address": {
                            "street": "555, Taylor Swift Avenue",
                            "city": "Nashville"
                        }
                    }
                    """
                    let data = Data(input.utf8)
                    let decoder = JSONDecoder()
                    if let decodedUser = try? decoder.decode(User.self, from: data) {
                        user = decodedUser
                    }
                }

                if let user = user {
                    NavigationLink("Show Address") {
                        AddressView(address: user.address)
                    }
                }
            }
            .navigationTitle("User Info")
        }
    }
}

struct AddressView: View {
    let address: Address

    var body: some View {
        VStack(spacing: 20) {
            Text("Street: \(address.street)")
            Text("City: \(address.city)")
        }
        .navigationTitle("Address")
        .padding()
    }
}
```

* Better for showing **related or hierarchical** data.
* Standard iOS navigation feel with back button and swipe gesture.


#### Comparison: `.sheet` vs. `NavigationLink`

| Feature              | `.sheet`                       | `NavigationLink`                        |
| -------------------- | ------------------------------ | --------------------------------------- |
| Style                | Modal, overlays entire screen  | Pushes new view onto a navigation stack |
| UX Expectation       | Temporary/independent info     | Drill-down into related info            |
| Ideal Use Case       | Settings, form, pop-up help    | Detail views (e.g., user → address)     |
| Supports Back Button | No (requires dismiss manually) | Yes (auto back navigation)              |
| Contextual Relevance | Often unrelated                | Directly related                        |
| SwiftUI Integration  | Requires `.sheet()` binding    | Works naturally with `List`, `Stack`    |


#### Recommendation

For showing a **user’s address**, which is directly related and part of their profile data, `NavigationLink` is the better choice — it fits the mental model of “digging deeper” into information and provides a more consistent iOS experience.


### Why This Works

* Each level of JSON is represented by a matching Swift struct.
* Swift decodes the data recursively, as long as the structure matches exactly.
* You don’t need to write custom parsing logic.

> 📌 Tip: If decoding fails, check that all your property names and types exactly match the JSON structure.


### Unlimited Nesting

There’s no hard limit to how deep your JSON structure can go — `Codable` will handle multiple levels of nesting as long as your Swift types reflect the hierarchy properly.

### Recap

* Use `Codable` to decode nested JSON with ease.
* Create a separate struct for each nested level.
* Ensure your property names and types match the JSON.
* Decode using `JSONDecoder()` and `Data`.

---

## Day 40 – Project 8, part two

--

## JSON Sources

* `astronauts.json`: Contains a dictionary of astronauts keyed by ID.
* `missions.json`: Contains an array of mission objects.
* All assets and data originate from NASA (Public Domain) and Wikipedia (CC-BY-SA 3.0).

### Astronaut Model

```swift
struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}
```

* Conforms to `Codable` for easy decoding from JSON.
* Conforms to `Identifiable` so it can be used in SwiftUI’s `ForEach`.

### Loading JSON Data

We use an extension on `Bundle` to load and decode our JSON from the app bundle into Swift models.

### ❌ Why hardcoding `[String: Astronaut]` is a bad idea

Initially, we might write:

```swift
func decode(_ file: String) -> [String: Astronaut] { ... }
```

But this is **not reusable** — it only works for one specific data type. If we want to decode `[Mission]`, we’d have to write an entirely new method. That goes against clean, maintainable code.

### The Generic Solution

Instead, we refactor the `decode` method to work with **any** Decodable type:

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
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Missing key '\(key.stringValue)' – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Invalid JSON.")
        } catch {
            fatalError("Decoding failed: \(error.localizedDescription)")
        }
    }
}
```

This approach is:

* **Reusable**: Works for `[String: Astronaut]`, `[Mission]`, or any other model.
* **Maintainable**: Centralized decoding logic with detailed error reporting.
* **Cleaner Views**: Keeps decoding out of the `View` layer.

#### Usage Example

```swift
let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
let missions: [Mission] = Bundle.main.decode("missions.json")
```

### Benefits of This Architecture

* **Decoupled Views**: No parsing logic inside SwiftUI views.
* **Error Transparency**: Helpful decoding error messages.
* **Flexible & Scalable**: Easily add more data types.

### License

* Astronaut images and mission badges are in the public domain (NASA).
* Astronaut descriptions from Wikipedia are licensed under [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/).

---

## Swift Codable Guide

Swift provides powerful protocols for working with structured data like JSON, Plist, or custom formats. 
This guide explains the differences between `Codable`, `Decodable`, and `Encodable`, and when to use each — with real examples and best practices.


### Codable vs Decodable vs Encodable

| Protocol     | Purpose                  | Use Case                        |
|--------------|---------------------------|----------------------------------|
| `Decodable`  | Read / parse data         | Load JSON into models           |
| `Encodable`  | Write / save data         | Convert models into JSON        |
| `Codable`    | Both decode and encode    | Full round-trip: read + write   |

> 💡 `Codable` is just shorthand for `Encodable & Decodable`


#### When to Use Each

##### `Decodable`

Use when you're only **reading** data:

```swift
func decode<T: Decodable>(_ file: String) -> T
````

Great for loading static JSON into Swift structs.


##### `Encodable`

Use when you're only **writing** data:

```swift
func save<T: Encodable>(_ object: T, to filename: String)
```

Ideal for exporting, saving to disk, or sending JSON to an API.

##### `Codable`

Use when your app does **both** reading and writing. For example:

* Forms and editors
* Saving app state
* Syncing to cloud
* Round-trip APIs

```swift
func decode<T: Codable>(_ file: String) -> T
func save<T: Codable>(_ object: T, to filename: String)
```

**Full Round-Trip Example**

```swift
struct Note: Codable {
    let id: UUID
    var content: String
}

// Decode from bundle
let notes: [Note] = Bundle.main.decode("notes.json")

// Encode back to file
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

if let encoded = try? encoder.encode(notes) {
    try? encoded.write(to: fileURL)
}
```


### Best Practice

Always use the **most specific protocol** needed:

| Scenario                   | Protocol    |
| -------------------------- | ----------- |
| Loading JSON only          | `Decodable` |
| Saving/exporting JSON only | `Encodable` |
| Round-trip read/write JSON | `Codable`   |


---

## Mission Grid UI with Computed Properties, Date Decoding & Dark Theme

This section covers the design and implementation of a scrollable grid layout for displaying space missions with images, launch dates, and a polished visual style.

### Features Implemented

* **Computed Properties for Clean Code**

  * `Mission.displayName`: Formats mission name like "Apollo 11".
  * `Mission.image`: Constructs the image name from mission ID.
  * `Mission.formattedLaunchDate`: Converts optional `Date?` into a formatted string or `"N/A"`.

* **Date Decoding with Custom Format**

  * JSON date strings like `"1969-07-16"` are decoded using:

    ```swift
    let formatter = DateFormatter()
    formatter.dateFormat = "y-MM-dd"
    decoder.dateDecodingStrategy = .formatted(formatter)
    ```

* **Responsive Grid with Adaptive Columns**

  * Layout adapts to screen width using:

    ```swift
    let columns = [ GridItem(.adaptive(minimum: 150)) ]
    ```

* **SwiftUI Navigation & Grid**

  ```swift
  NavigationStack {
      ScrollView {
          LazyVGrid(columns: columns) {
              ForEach(missions) { mission in
                  NavigationLink {
                      Text("Detail view")
                  } label: {
                      VStack {
                          Image(mission.image)
                              .resizable()
                              .scaledToFit()
                              .frame(width: 100, height: 100)
                              .padding()

                          VStack {
                              Text(mission.displayName)
                                  .font(.headline)
                                  .foregroundStyle(.white)
                              Text(mission.formattedLaunchDate)
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
                  }
              }
          }
          .padding([.horizontal, .bottom])
      }
      .navigationTitle("Moonshot")
      .background(.darkBackground)
      .preferredColorScheme(.dark)
  }
  ```

* **Custom App Theme Colors**
  Defined in `Color-Theme.swift`:

  ```swift
  extension ShapeStyle where Self == Color {
      static var darkBackground: Color {
          Color(red: 0.1, green: 0.1, blue: 0.2)
      }

      static var lightBackground: Color {
          Color(red: 0.2, green: 0.2, blue: 0.3)
      }
  }
  ```

---

## Day 41 – Project 8, part three

---

## Merging Codable Data Structures Across Multiple JSON Files

To effectively present astronaut crew information for each Apollo mission, we needed to **merge data from two separate JSON sources**: one for missions and another for astronauts. This was a key step in making the app 
dynamic, DRY (Don’t Repeat Yourself), and scalable.

### ✅ The Problem: Split & Hierarchical Data

* `missions.json` contains each mission’s metadata and a list of crew IDs with roles:

  ```json
  {
    "id": "apollo11",
    "crew": [
      { "name": "armstrong", "role": "Commander" }
    ]
  }
  ```

* `astronauts.json` maps those IDs to full astronaut profiles:

  ```json
  {
    "armstrong": {
      "id": "armstrong",
      "name": "Neil A. Armstrong",
      "description": "First man on the Moon."
    }
  }
  ```

While this structure eliminates redundancy (since astronauts appear in multiple missions), it requires **merging** the two datasets in code using `Codable`.

### The Solution: Join Data via `CrewMember` Struct

We created a custom struct inside `MissionView`:

```swift
struct CrewMember {
    let role: String
    let astronaut: Astronaut
}
```

This allows us to store a fully resolved pairing of an astronaut and their role in a mission.

### Custom Initializer to Resolve Crew Data

```swift
init(mission: Mission, astronauts: [String: Astronaut]) {
    self.mission = mission
    self.crew = mission.crew.map { member in
        if let astronaut = astronauts[member.name] {
            return CrewMember(role: member.role, astronaut: astronaut)
        } else {
            fatalError("Missing \(member.name)")
        }
    }
}
```

* **Maps each crew member ID** to its corresponding `Astronaut`.
* **Fails loudly** using `fatalError()` if any data is missing — this is intentional, since such mismatch indicates bad static data, not a runtime error.

### Displaying Merged Data in Scrollable Layout

Below the mission description, we added a horizontally scrollable list of crew members:

```swift
ScrollView(.horizontal, showsIndicators: false) {
    HStack {
        ForEach(crew, id: \.role) { crewMember in
            NavigationLink {
                Text("Astronaut details")
            } label: {
                HStack {
                    Image(crewMember.astronaut.id)
                        .resizable()
                        .frame(width: 104, height: 72)
                        .clipShape(.capsule)
                        .overlay(
                            Capsule()
                                .strokeBorder(.white, lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(crewMember.astronaut.name)
                            .foregroundStyle(.white)
                            .font(.headline)
                        Text(crewMember.role)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
```

### Layout Design Decisions

| Area                    | Decision                                                                 |
| ----------------------- | ------------------------------------------------------------------------ |
| **ScrollView**          | Used `ScrollView(.horizontal)` to show crew edge-to-edge                 |
| **Padding & Placement** | Scroll view placed *after* main `VStack` for visual breathing room       |
| **Image Styling**       | Capsule clipping with stroke border for clean astronaut image thumbnails |
| **Navigation**          | `NavigationLink` to allow tapping into astronaut detail view             |


### Preview with Both JSON Sources

Because we merged data from two sources, we needed to load both in our preview:

```swift
#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
```

### Visual Polish & Titles

* **Custom Divider** between description and crew:

  ```swift
  Rectangle()
      .frame(height: 2)
      .foregroundStyle(.lightBackground)
      .padding(.vertical)
  ```

* **Crew Section Title** (placed carefully inside `VStack`):

  ```swift
  Text("Crew")
      .font(.title.bold())
      .padding(.bottom, 5)
  ```

This ensures consistent padding and alignment with other text elements.

---

## Recap: Why This Approach Matters

* ✅ **Efficient:** Reuses astronaut definitions across missions.
* ✅ **Type-Safe:** Uses `Codable` to ensure valid parsing at compile time.
* ✅ **Composable:** Data merging handled in one place, keeping UI code clean.
* ✅ **Scalable:** Supports larger missions and expanding astronaut bios without redundancy.

This pattern — **merging Codable structs from different JSON sources** — is essential when working with normalized data in SwiftUI and forms a solid foundation for clean, scalable apps.

---

## Day 42 – Project 8, part four

---

## Challenge Solutions

### 1. Add Launch Date to `MissionView`

* The mission badge now shows the formatted launch date right below the image.
* The date is displayed using SwiftUI’s `.formatted()` method with `.abbreviated` style for locale-appropriate formatting.
* The date view is styled with a semi-transparent white background, rounded corners, and padding to stand out clearly.

```swift
VStack {
    Text(mission.formattedLaunchDate)
        .font(.title2)
}
.padding(.vertical, 20)
.padding(.horizontal, 80)
.background(.white.opacity(0.9))
.clipShape(.rect(cornerRadius: 10))
.foregroundColor(.gray)
```

---

### 2. Extract Subviews for Better Code Organization

To keep the code clean and reusable, I refactored some UI pieces into separate SwiftUI views:

* ** `CrewMembersView` **: Displays the horizontally scrolling crew list, showing each astronaut’s picture, name, and role.
* ** `RectangleDivider` **: A custom, stylized divider used to visually separate sections in `MissionView`.

Example: 

** `RectangleDivider` implementation** 

```swift
struct RectangleDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}
```

** `CrewMembersView` implementation** 

```swift

struct CrewMembersView: View {
    
    let crew: [Mission.CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(.capsule)
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.white, lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                Text(crewMember.role)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }

    }
}

```

---

### 3. Toolbar Toggle to Switch Between Grid and List Layouts

A toolbar button in `ContentView` toggles the missions display between:

* **Grid view** (`GridLayoutView`): Uses a `LazyVGrid` for an adaptive grid of missions with mission badges, names, and dates.
* **List view** (`ListLayoutView`): A vertical list showing the same mission data with a slightly different style.

This toggle improves usability and lets users pick their preferred view.

```swift
@State private var showingGrid = false

.toolbar {
    Button {
        showingGrid.toggle()
    } label: {
        Label("Switch Layout", systemImage: showingGrid ? "list.bullet" : "square.grid.2x2")
    }
}
```

The main body conditionally shows either layout:

```swift
Group {
    if showingGrid {
        GridLayoutView(missions: missions, astronauts: astronauts)
    } else {
        ListLayoutView(missions: missions, astronauts: astronauts)
    }
}
```

