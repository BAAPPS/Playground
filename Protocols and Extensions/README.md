# Summary

## Day 13 – Protocols, extensions, and checkpoint 8

---

### Swift Protocols and Vehicle Simulation

#### Overview

- Protocols act as *contracts* that define specific methods and properties that conforming types must implement. 

- They allow us to write flexible, reusable, and scalable code by working with abstractions instead of concrete types.

#### Key Concepts

#### What is a Protocol?

> A protocol defines a blueprint of methods and properties that a conforming type must implement. It doesn’t provide implementations itself.

#### Why Use Protocols?

Protocols let us:

* Work with a common interface (`Vehicle`) rather than specific types like `Car` or `Bicycle`.

* Write generic and extensible code.

* Enforce consistency across multiple types.

* Enable polymorphism (objects behaving differently via the same interface).

---

#### Protocol Design: `Vehicle`

We begin by defining a `Vehicle` protocol. This describes what capabilities every vehicle type must have:

```swift
protocol Vehicle {
    var name: String { get }
    var currentPassengers: Int { get set }

    func estimateTime(for distance: Int) -> Int
    func travel(distance: Int)
}
```

#### Breakdown

| Element             | Requirement | Explanation                                             |
| ------------------- | ----------- | ------------------------------------------------------- |
| `name`              | `get`       | Must be readable — can be a constant or computed value. |
| `currentPassengers` | `get set`   | Must be both readable and writeable.                    |
| `estimateTime()`    | Method      | Returns estimated travel time based on distance.        |
| `travel()`          | Method      | Executes logic to simulate travel.                      |


#### Conforming Types

We now create concrete types (`Car`, `Bicycle`) that conform to the `Vehicle` protocol by implementing all required properties and methods.

#### `Car` Struct

```swift
struct Car: Vehicle {
    let name = "Car"
    var currentPassengers = 1

    func estimateTime(for distance: Int) -> Int {
        distance / 50
    }

    func travel(distance: Int) {
        print("🚗 Driving \(distance)km.")
    }

    func openSunroof() {
        print("☀️ It's a nice day for a sunroof ride!")
    }
}
```

> 💡 The `openSunroof()` method is *not* part of the protocol, but it’s fine to add extra functionality that’s only relevant to `Car`.

#### `Bicycle` Struct

```swift
struct Bicycle: Vehicle {
    let name = "Bicycle"
    var currentPassengers = 1

    func estimateTime(for distance: Int) -> Int {
        distance / 10
    }

    func travel(distance: Int) {
        print("🚴‍♂️ Cycling \(distance)km.")
    }
}
```

#### Commuting Logic

We now write a function that accepts *any* `Vehicle`, not just one specific type:

```swift
func commute(distance: Int, using vehicle: Vehicle) {
    if vehicle.estimateTime(for: distance) > 100 {
        print("❌ That's too slow! I'll try a different vehicle.")
    } else {
        vehicle.travel(distance: distance)
    }
}
```

This allows us to pass in any type that conforms to the `Vehicle` protocol:

```swift
let car = Car()
let bike = Bicycle()

commute(distance: 100, using: car)  // "Driving 100km."
commute(distance: 100, using: bike) // "Cycling 100km."
```

#### Travel Estimate Comparison

We can use protocols to write functions that handle arrays of mixed types:

```swift
func getTravelEstimates(using vehicles: [Vehicle], distance: Int) {
    for vehicle in vehicles {
        let estimate = vehicle.estimateTime(for: distance)
        print("🧾 \(vehicle.name): \(estimate) hours to travel \(distance)km")
    }
}

getTravelEstimates(using: [car, bike], distance: 150)
```

####  Final Takeaways

* **Protocols promote code abstraction**: You can write one `commute()` function that works with *any* vehicle type.

* **Protocols ensure consistency**: All conforming types must implement required methods/properties.

* **Protocols allow polymorphism**: Swift dynamically selects the correct implementation at runtime.

* **Protocols keep your code flexible and future-proof**: You can add new vehicle types without rewriting existing functions.

---


### Opaque Return Types in Swift: An In-Depth Explanation

Swift provides a powerful and somewhat complex feature called **opaque return types**, introduced in Swift 5.1. While it might feel a bit advanced, understanding opaque return types is essential, especially if you plan to 
work with SwiftUI or advanced Swift APIs.

#### What Are Opaque Return Types?

An **opaque return type** is a way to tell Swift:

> "This function returns *some* specific type that conforms to a protocol, but I’m not going to tell you exactly which type."

This is different from returning a protocol type (called an *existential*), where you say:

> "This function returns *any* type that conforms to this protocol."


#### Why Are Opaque Return Types Needed?

Imagine you have a function that returns a value conforming to a protocol, like this:

```swift
func getVehicle() -> Vehicle {
    // returns some Vehicle conforming type
}
```

The problem with this **existential** return type (`Vehicle`) is:

* Swift doesn’t know the exact underlying concrete type.

* This can cause performance overhead.

* You lose some compile-time type information.

Contrast that with:

```swift
func getVehicle() -> some Vehicle {
    // returns one specific Vehicle type, but hides the exact type
}
```

Here, you’re telling Swift:

* The function returns *one specific* concrete type conforming to `Vehicle`.
* Swift knows exactly what that type is, even if you don’t expose it.
* This enables better performance and type safety.

---

#### The Key Difference: `some Protocol` vs. `Protocol`

| Aspect                    | `some Protocol` (Opaque)                    | `Protocol` (Existential)               |
| ------------------------- | ------------------------------------------- | -------------------------------------- |
| Type Information          | Hidden from caller but known to compiler    | Unknown to compiler at compile time    |
| Concrete Type Requirement | Must always return the *same* concrete type | Can return any conforming type         |
| Performance               | Better, because compiler knows exact type   | Slight overhead due to type erasure    |
| Flexibility               | Less flexible (one type per function)       | More flexible (multiple types allowed) |


#### Example: Why You Can’t Return Protocol Types Directly

Consider the protocol `Equatable`, which allows comparing values for equality:

```swift
func getRandomNumber() -> Equatable {  // ❌ This won’t compile
    return Int.random(in: 1...6)
}

func getRandomBool() -> Equatable {  // ❌ This won’t compile
    return Bool.random()
}
```

Swift gives an error:

```
Protocol 'Equatable' can only be used as a generic constraint because it has Self or associated type requirements.
```

#### What’s Happening Here?

* `Equatable` is a protocol with **associated types** (the `Self` type).

* Swift can’t represent `Equatable` as a type on its own (called an *existential*), because it needs to know the concrete type to compare values.

* You can’t just say "some Equatable" and return different types (like `Int` or `Bool`) because Swift requires the **same** concrete type every time.

#### How Opaque Return Types Fix This

Using the keyword `some` tells Swift:

```swift
func getRandomNumber() -> some Equatable {
    return Int.random(in: 1...6)
}

func getRandomBool() -> some Equatable {
    return Bool.random()
}
```

* Each function returns a **single concrete type** (an `Int` or a `Bool`).

* From the caller’s perspective, the type is hidden behind `some Equatable`.

* Swift knows the exact type underneath, so you can use `==` safely when comparing two calls to the same function’s result:

```swift
print(getRandomNumber() == getRandomNumber()) // OK: both are Int
print(getRandomBool() == getRandomBool())     // OK: both are Bool
```

But you **cannot** compare results of `getRandomNumber()` and `getRandomBool()` because they are different underlying types.

---

#### Practical Use in SwiftUI

SwiftUI uses opaque return types extensively, especially the return type `some View`:

```swift
func makeView() -> some View {
    VStack {
        Text("Hello, world!")
    }
}
```

* SwiftUI views have complex nested types.

* Without opaque return types, you’d have to spell out the entire type signature of your view, which can be huge.

* Using `some View` hides the complexity while keeping compile-time type safety.

* Swift always knows the actual underlying view type, enabling optimized layout and rendering.


#### Important Notes and Limitations

* **Consistency:** All return paths in a function returning `some Protocol` must return the **same concrete type**. Different types cause compile errors.
* **Abstraction, not polymorphism:** Opaque types hide the concrete type but don’t support returning different types polymorphically like existentials do.
* **Flexibility:** You can change the concrete type internally later without changing the function signature, as long as the new type conforms to the protocol.

#### Recap

* **Opaque return types** (`some Protocol`) let you return a specific but hidden concrete type.

* They provide **better performance** and **compile-time type safety** than returning a protocol type.

* They are **essential** for SwiftUI and advanced Swift coding.

* Remember: **all returns must be the same concrete type** to satisfy opaque return type requirements.

---

### Swift Extensions: Deep Dive

- Extensions in Swift allow us to add new functionality to any existing type — whether it’s a type you created or one from Apple’s own frameworks.

- This powerful feature helps keep code clean, organized, and expressive.


#### Using Foundation’s `trimmingCharacters(in:)`

- A practical example of an extension-worthy method is `trimmingCharacters(in:)` on strings. 

- It removes specified characters from the start and end of a string. 

- Most commonly, it’s used to remove whitespace and newline characters.

#### What is whitespace and newline?

- **Whitespace** includes spaces, tabs, and similar invisible spacing characters.

- **Newlines** are line breaks in text. There are multiple newline variants (like `\n`, `\r\n`), but `trimmingCharacters(in:)` handles them all.

Example:

```swift
var quote = "   The truth is rarely pure and never simple   "
let trimmed = quote.trimmingCharacters(in: .whitespacesAndNewlines)
print(trimmed) // "The truth is rarely pure and never simple"
````

#### Creating a String Extension for Convenience

Calling `trimmingCharacters(in:)` repeatedly can be verbose, so we can write a String extension to make this cleaner:

```swift
extension String {
    /// Returns a new string by trimming whitespace and newlines from both ends
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
```

This lets us write:

```swift
let trimmedQuote = quote.trimmed()
```

#### Why prefer extensions over global functions?

We could instead write a global function:

```swift
func trim(_ string: String) -> String {
    string.trimmingCharacters(in: .whitespacesAndNewlines)
}
```

And use it like this:

```swift
let trimmed2 = trim(quote)
```

While this works and looks simpler at call site, extensions offer several advantages:

* **Autocomplete:** When typing `quote.` in Xcode, your new methods appear alongside built-in ones.

* **Organization:** Extensions group related functionality by the data type, making code easier to maintain.

* **Access:** Extension methods have full access to the type’s internal data, including private members.

* **In-place modification:** Extensions allow mutating methods that modify values directly, which global functions cannot do.


#### Mutating Extensions

If we want to trim a string **in place** (modify the string variable itself), we can write a mutating method:

```swift
extension String {
    /// Trims whitespace and newlines from this string in place
    mutating func trim() {
        self = self.trimmed()
    }
}
```

Usage:

```swift
var quote = "   Some text   "
quote.trim()
print(quote) // "Some text"
```

#### Naming Conventions

Swift’s naming guidelines distinguish between returning a new value and mutating the existing one:

* Methods returning a new value often end with suffixes like `-ed` or `-ing` (e.g., `trimmed()`, `sorted()`).
* Methods that mutate the value itself use simple verbs (e.g., `trim()`, `sort()`).

#### Adding Computed Properties via Extensions

Extensions can also add computed properties, but **not stored properties** (because that would alter the memory layout of the type).

Example: add a `lines` computed property that splits a string into an array of its lines:

```swift
extension String {
    var lines: [String] {
        self.components(separatedBy: .newlines)
    }
}
```

Usage:

```swift
let lyrics = """
But I keep cruising
Can't stop, won't stop moving
It's like I got this music in my mind
Saying it's gonna be alright
"""

print(lyrics.lines.count) // 4
```

#### Extensions and Initializers in Structs

Swift automatically provides a *memberwise initializer* for structs, like this:

```swift
struct Book {
    let title: String
    let pageCount: Int
    let readingHours: Int
}

let lotr = Book(title: "Lord of the Rings", pageCount: 1178, readingHours: 24)
```

If you add a **custom initializer inside the struct**, Swift disables the automatic memberwise initializer:

```swift
struct Book {
    let title: String
    let pageCount: Int
    let readingHours: Int

    init(title: String, pageCount: Int) {
        self.title = title
        self.pageCount = pageCount
        self.readingHours = pageCount / 50
    }
}
```

This is intentional to prevent bypassing your custom logic.

However, if you want to keep both the automatic memberwise initializer **and** your custom one, put the custom initializer inside an **extension**:

```swift
extension Book {
    init(title: String, pageCount: Int) {
        self.title = title
        self.pageCount = pageCount
        self.readingHours = pageCount / 50
    }
}
```

This way, you get:

* The automatic memberwise initializer.
* Your custom initializer with extra logic.

Usage:

```swift
let swiftBook = Book(title: "Swift Programming", pageCount: 500)
print(swiftBook.readingHours) // 10
```

#### Recap

Extensions in Swift:

* Add new functionality to existing types without subclassing or modifying original code.

* Enable convenient and expressive APIs (like `trimmed()` on String).

* Help organize code logically by type.

* Allow computed properties and mutating methods.

* Let you add initializers without disabling automatic memberwise ones (if placed in extensions).

* Are essential for writing clean, maintainable, and idiomatic Swift code.

---

### Protocol Extensions (Advanced Swift Concepts)

#### What are Protocol Extensions?

- Protocols in Swift define a blueprint or a *contract* that any conforming type must follow. They specify properties, methods, or other requirements a type must implement.

- Extensions, on the other hand, allow you to add new functionality to existing types, even those you don’t own (like Apple’s standard types).

- **Protocol extensions combine these two concepts** — they let you add default method or property implementations directly to protocols. 

- This means any type that conforms to the protocol automatically gets these default implementations unless it provides its own.

#### Why Use Protocol Extensions?

- Imagine you want to add a simple helper to check whether a collection is *not empty*. 

- A common pattern is checking if a collection’s `isEmpty` property is `false`.

Here’s how you might typically check if an array has items:

```swift
let guests = ["Mario", "Luigi", "Peach"]

if guests.isEmpty == false {
    print("Guest count: \(guests.count)")
}
```

Or using the negation operator:

```swift
if !guests.isEmpty {
    print("Guest count: \(guests.count)")
}
```

Both work, but can feel awkward to read — “if not empty”?


#### Adding `isNotEmpty` to Arrays

To make your code clearer, you might add an extension to `Array`:

```swift
extension Array {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}
```

Now you can write:

```swift
if guests.isNotEmpty {
    print("Guest count: \(guests.count)")
}
```

#### Extending the Protocol Instead of the Type

But what if you want `isNotEmpty` to work on **sets, dictionaries, and other collections**?

Duplicating code for each type would be inefficient and error-prone.

The solution: extend the **Collection** protocol — the protocol to which `Array`, `Set`, and `Dictionary` conform, and which requires the `isEmpty` property.

```swift
extension Collection {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}
```

Now, any type conforming to `Collection` automatically gets `isNotEmpty`!

#### Protocol-Oriented Programming with Default Implementations

Protocol extensions allow you to define default behavior. For example, you might define a protocol:

```swift
protocol Person {
    var name: String { get }
    func sayHello()
}
```

Any conforming type must implement `sayHello()`. But with protocol extensions, you can provide a default implementation:

```swift
extension Person {
    func sayHello() {
        print("Hi, I'm \(name)")
    }
}
```

Now, conforming types can use the default or provide their own:

```swift
struct Employee: Person {
    let name: String
    // Uses default sayHello()
}

struct Manager: Person {
    let name: String
    func sayHello() {
        print("Hello, my name is \(name), and I manage the team.")
    }
}

let taylor = Employee(name: "Taylor Swift")
taylor.sayHello() // Hi, I'm Taylor Swift

let alex = Manager(name: "Alex")
alex.sayHello() // Hello, my name is Alex, and I manage the team.
```

---

### Exploring Protocol-Oriented Programming and Advanced Type Features

- Swift makes protocols incredibly powerful by allowing *extensions on protocols* themselves — not just on concrete types. 

- This unlocks highly reusable code, smarter abstractions, and elegant conformance-based design. 

- This guide explores how protocol extensions work, how to use `Self`, and how Swift’s standard library leverages protocol inheritance through `Equatable` and `Comparable`.


#### Why Use Protocol Extensions?

- Protocols define what types *must* do. 

- Extensions let you add functionality to existing types. 

- Put them together, and you get the ability to **define default behavior across many types**, without modifying them individually.

Example:

```swift
protocol Person {
    var name: String { get }
    func sayHello()
}

extension Person {
    func sayHello() {
        print("Hi, I'm \(name)")
    }
}
```

Any type conforming to `Person` gets a `sayHello()` method for free — unless it chooses to override it.

#### A Real-World Example

Let’s improve array readability with an `isNotEmpty` computed property:

```swift
extension Array {
    var isNotEmpty: Bool {
        !isEmpty
    }
}
```

Now instead of writing:

```swift
if !guests.isEmpty { ... }
```

You can write:

```swift
if guests.isNotEmpty { ... }
```

Much more readable, right?

But why stop at arrays? Sets and dictionaries also conform to a shared protocol: `Collection`. Since `Collection` requires `isEmpty`, we can move our extension up:

```swift
extension Collection {
    var isNotEmpty: Bool {
        !isEmpty
    }
}
```

Now `isNotEmpty` works for any type conforming to `Collection`.


#### Advanced: Adding Behavior to Numeric Types

What if we want to define a method that works across both `Int` and `Double`, like squaring a number?

```swift
extension Int {
    func squared() -> Int {
        self * self
    }
}
```

This works for `Int`, but not `Double`. Can we generalize it?

Yes! Both `Int` and `Double` conform to the `Numeric` protocol:

```swift
extension Numeric {
    func squared() -> Self {
        self * self
    }
}
```

#### ⚠️ Why use `Self`?

* `self` refers to the current *value* (e.g., `5`)
* `Self` refers to the current *type* (e.g., `Int`)

So this works for any numeric type, without typecasting.

```swift
let a: Int = 6
let b: Double = 3.5

print(a.squared())  // 36
print(b.squared())  // 12.25
```

#### Equatable: How Swift Compares Types

If your struct conforms to `Equatable`, Swift gives you `==` and `!=` for free.

```swift
struct User: Equatable {
    let name: String
}

let a = User(name: "Link")
let b = User(name: "Zelda")

print(a == b)  // false
print(a != b)  // true
```

#### Comparable: Custom Sorting

Swift can’t auto-generate `<`, but once you implement it, Swift gives you the rest (`>`, `<=`, `>=`) thanks to protocol extensions.

```swift
struct User: Comparable {
    let name: String
}

func <(lhs: User, rhs: User) -> Bool {
    lhs.name < rhs.name
}
```

Now you can compare and sort:

```swift
let taylor = User(name: "Taylor")
let adele = User(name: "Adele")

print(taylor > adele)    // true
```

Bonus: `Comparable` inherits from `Equatable`, so you don’t even need to write `==`.

#### Recap: Why This Matters

* **Protocol extensions** let you add behavior to many types at once.

* ** `Self` ** in protocols refers to the conforming type — enabling generic yet precise code.

* **Swift’s standard protocols** (`Collection`, `Numeric`, `Equatable`, `Comparable`) are designed with extensions in mind.

* **Protocol-oriented programming** encourages you to define behavior at the protocol level instead of duplicating it in every type.


### 🏁 Swift Checkpoint 8 – Protocols & Extensions

#### Overview

In this checkpoint, we explore **protocols** and **protocol extensions** by modeling buildings using a protocol-based design in Swift.

We’ll define a protocol that outlines what all buildings should contain, implement default functionality using **protocol extensions**, and then conform to that protocol with two custom types: `House` and `Office`.


### What I'll Learn 

- How to define a protocol with required properties and methods.

- How to use **protocol extensions** to avoid duplication and provide shared functionality.

- How to create multiple structs that conform to a single protocol.

#### The Challenge

Define a protocol named `Building` that describes any kind of building. The protocol should require:

- A property storing **how many rooms** the building has
.
- A property storing the **cost** as an integer (e.g. `500_000` for $500,000).

- A property storing the **name of the estate agent** responsible for the sale.

- A method that prints a **sales summary** for the building, including all relevant details.

Then create two `struct`s:

- `House`

- `Office`

Both should conform to `Building` and provide their own values for those properties.

#### Solution

##### Step 1 – Define the Protocol

```swift
protocol Building {
    var numberOfRooms: Int { get }
    var cost: Int { get }
    var agentName: String { get }
    var buildingType: String { get }

    func printSalesSummary()
}
````

This protocol describes the **minimum requirements** for anything we consider a "building".

#### Step 2 – Extend the Protocol

Instead of writing the same implementation for every struct, we add default behavior using a **protocol extension**:

```swift
extension Building {
    func printSalesSummary() {
        print("""
        📍 \(buildingType) Summary:
        - Rooms: \(numberOfRooms)
        - Cost: $\(cost)
        - Agent: \(agentName)
        """)
    }
}
```

This extension provides a reusable implementation of `printSalesSummary()` that will work automatically for any type conforming to `Building`.


#### 🏡 Step 3 – Define `House`

```swift
struct House: Building {
    let numberOfRooms: Int
    let cost: Int
    let agentName: String
    let buildingType = "House"
}
```

A simple structure representing a house. It provides its own values and inherits the shared summary logic from the protocol extension.

#### 🏢 Step 4 – Define `Office`

```swift
struct Office: Building {
    let numberOfRooms: Int
    let cost: Int
    let agentName: String
    let buildingType = "Office"
}
```

This works just like `House`, but represents an office space instead.

#### Step 5 – Use the Structs

```swift
let myHouse = House(numberOfRooms: 3, cost: 450_000, agentName: "Alice Johnson")
let myOffice = Office(numberOfRooms: 10, cost: 1_250_000, agentName: "Bob Smith")

myHouse.printSalesSummary()
myOffice.printSalesSummary()
```

#### 🖨 Output

```
📍 House Summary:
- Rooms: 3
- Cost: $450000
- Agent: Alice Johnson

📍 Office Summary:
- Rooms: 10
- Cost: $1250000
- Agent: Bob Smith
```


#### Takeaways

* **Protocols** let you define shared contracts for multiple types.

* **Protocol extensions** reduce code duplication by providing default behavior.

* This is the core idea behind **protocol-oriented programming** — one of Swift’s most powerful paradigms.

- By combining protocols and extensions, we build scalable and flexible models for real-world entities like buildings.


