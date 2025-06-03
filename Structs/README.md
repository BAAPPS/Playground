# Summary

## Day 10 – Structs, Computed Properties, and property Observers

---

### Structs

- Swift’s `struct` keyword allows you to create custom, complex data types that group related values and behavior together. 

- Structs can contain properties (data) and methods (functions), and are value types—meaning each instance is independent.

#### 🧱 Defining a Struct

```swift
struct Album {
    let title: String
    let artist: String
    let year: Int

    func printSummary() {
        print("\(title) (\(year)) by \(artist)")
    }
}
```

Structs use **UpperCamelCase** by convention, while properties and methods use **lowerCamelCase**. 

You create instances using auto-generated initializers:

```swift
let red = Album(title: "Red", artist: "Taylor Swift", year: 2012)
red.printSummary()
```

#### 🔄 Mutable Properties & `mutating` Methods

To allow changes to a struct’s internal properties, declare the instance with `var` and mark any modifying methods with `mutating`:

```swift
struct Employee {
    let name: String
    var vacationRemaining: Int

    mutating func takeVacation(days: Int) {
        if vacationRemaining >= days {
            vacationRemaining -= days
            print("Days left: \(vacationRemaining)")
        } else {
            print("Not enough vacation days.")
        }
    }
}

var archer = Employee(name: "Sterling Archer", vacationRemaining: 14)
archer.takeVacation(days: 5)
```

> ⚠️ `mutating` methods can’t be called on `let` instances because their data is constant.

#### 🛠 Struct Essentials

* **Properties**: Stored values inside a struct.
* **Methods**: Functions that belong to a struct.
* **Instance**: A unique variable created from a struct.
* **Initializer**: The function (`init(...)`) used to create instances. Swift generates this automatically, even supporting default values.

```swift
struct Employee {
    let name: String
    var vacationRemaining = 14
}

let kane = Employee(name: "Lana Kane") // uses default value
let pam = Employee(name: "Pam Poovey", vacationRemaining: 35)
```

#### 💡Native Types Are Structs Too

Even types like `Double` are structs under the hood, and use initializers like `Double(1)` to convert values.

---

###  Stored vs Computed Properties 

Swift structs can have **two kinds of properties**:

* 🗃️ **Stored properties**: These hold data directly inside an instance.
* 🔄 **Computed properties**: These calculate their value every time they are accessed. They behave like properties but work like functions.


#### 🧪 Example: Employee Vacation Tracker

```swift
struct Employee {
    let name: String
    var vacationAllocated = 14
    var vacationTaken = 0

    // Computed read-only property
    var vacationRemaining: Int {
        vacationAllocated - vacationTaken
    }

    // Computed read-write property
    var adjustableVacationRemaining: Int {
        get {
            vacationAllocated - vacationTaken
        }
        set {
            vacationAllocated = vacationTaken + newValue
        }
    }
}
```

#### 🧩 Usage

```swift
var archer = Employee(name: "Sterling Archer")

// Reading from a computed property
archer.vacationTaken += 4
print(archer.vacationRemaining) // 10

// Writing to a computed property (triggers setter)
archer.adjustableVacationRemaining = 5
print(archer.vacationAllocated) // 9
```


#### ✅ Key Takeaways

* Use **stored properties** for fixed values.
* Use **computed properties** to derive values dynamically.
* Computed properties can be made **read-only** or **read-write** using `get` and `set`.
* The keyword `newValue` is automatically provided inside the `set` block.

---


### 📌 Swift Property Observers

Swift provides **property observers** to let you respond to changes in property values. These are useful when you need to trigger side effects like logging, validation, or UI updates when a variable changes.

---

#### 🔍 Types of Property Observers

* `willSet`: Called **just before** the value changes. Use `newValue` to access the upcoming value.
* `didSet`: Called **immediately after** the value changes. Use `oldValue` to access the previous value.

---

#### 🧪 Example

```swift
struct Game {
    var score = 0 {
        didSet {
            print("Score is now \(score)")
        }
    }
}

var game = Game()
game.score += 10  // "Score is now 10"
game.score -= 3   // "Score is now 7"
game.score += 1   // "Score is now 8"
```

```swift
struct App {
    var contacts = [String]() {
        willSet {
            print("Current contacts: \(contacts)")
            print("Adding: \(newValue.last ?? "")")
        }
        didSet {
            print("Now have \(contacts.count) contacts.")
            print("Previously had: \(oldValue.count) contacts.\n")
        }
    }
}

var app = App()
app.contacts.append("Adrian E")
app.contacts.append("Allen W")
app.contacts.append("Ish S")
```

####💡 Key Points

* Use `'didSet` when you want to act after a value changes (e.g. logging, UI updates).

* Use `willSet` when you want to react before the change (e.g. validation, rollback logic).

* `oldValue` and `newValue` are automatically provided inside `didSet` and `willSet`.

#### ⚠️ Performance Tip

Avoid putting **heavy logic** in property observers. Simple tasks like printing or updating a label are fine, but avoid anything that can slow your app down or trigger multiple times unexpectedly like 
network calls or expensive loops.

---

### Swift Struct Initializers

- In Swift, **initializers** are special methods used to prepare a new instance of a struct. 

- While Swift automatically provides a *memberwise initializer*, you can define your own to add custom logic.


#### Default Memberwise Initializer

Swift automatically creates an initializer when all properties are declared with default types:

```swift
struct Player {
    let name: String
    let number: Int
}

let player = Player(name: "Megan R", number: 15)
````

This is called a **memberwise initializer** — it accepts each property in the order it was defined.

---

#### Custom Initializer

You can define your own initializer using `init`:

```swift
struct Player {
    let name: String
    let number: Int

    init(name: String, number: Int) {
        self.name = name
        self.number = number
    }
}
```

* Use `self.property` to disambiguate between parameter and property names.
* There is **no `func` keyword**, and you **do not return a value** explicitly.

---

#### Adding Custom Logic

Custom initializers allow computed setup, such as random values:

```swift
struct Player {
    let name: String
    let number: Int

    init(name: String) {
        self.name = name
        number = Int.random(in: 1...99)
    }
}

let player = Player(name: "Megan R")
print(player.number)
```

#### 📌 The Golden Rule

> **All properties must have a value before the initializer ends.**

If even one property is left uninitialized, Swift will throw a compile-time error.


#### 🧠 Key Notes

* You can define **multiple initializers** with different parameters.
* As soon as you create a custom initializer, **Swift disables the auto-generated one**.
* You can **call methods** inside an initializer *after* all properties are assigned.
* You can also use **external parameter labels** and **default values** in your custom inits.

```swift
struct Player {
    let name: String
    let number: Int

    init(name: String, number: Int = 10) {
        self.name = name
        self.number = number
    }
}
```

- Initializers give you full control over how your structs are created — use them wisely and always remember the golden rule!

---

## Day 11 – Access control, Static Properties and Methods, and Checkpoint 6

--- 

### Access Control in Swift Structs

By default, all properties and methods in Swift structs are publicly accessible. But sometimes you want to **hide** or **restrict** access to protect your data and enforce rules.

#### Why Access Control?

Without access control, you can accidentally bypass important logic. For example, directly modifying a bank account’s balance without going through its deposit or withdraw methods:

```swift
account.funds -= 1000  // Dangerous! Bypasses validation logic.
```

#### How to Fix This?

Swift offers **access control modifiers** to restrict access:

* `private`: property or method accessible **only inside the struct**.
* `fileprivate`: accessible anywhere **within the same file**.
* `public`: accessible **anywhere**.
* `private(set)`: property is **readable everywhere** but **writable only inside** the struct.

For example, using `private(set)` on `funds` lets anyone read the balance, but only the struct’s methods can change it:

```swift
private(set) var funds = 0
```

#### Important Notes

* When properties are private or private(set), you often need to write your **own initializer**, because Swift won’t generate one automatically.
* Access control helps prevent bugs and enforces safe usage patterns.
* Think of it as letting Swift guard your data and logic from accidental misuse by you or other developers.

---

### Static Properties and Methods in Swift

* In Swift, structs typically have their own unique properties and methods per instance.
* But **sometimes** you want to attach data or functionality directly to the type itself — not an instance. This is where `static` comes in.

---

#### What is `static`?

Adding `static` before a property or method means it **belongs to the struct**, not to each instance.

```swift
struct School {
    // ❗️This will throw:
    // Error: "Static property 'studentCount' is not concurrency-safe because it is nonisolated global shared mutable state"
    static var studentCount = 0 

    static func add(student: String) {
        print("\(student) joined the school.")
        studentCount += 1
    }
}
```

You can use:

```swift
School.add(student: "Taylor Swift")
print(School.studentCount)
```

But if you’re using **Swift Concurrency**, this pattern is unsafe. You’ll get a warning because `static var` is a shared mutable state accessed without protection.

---

#### 🛡 Fixing Concurrency Issues with `static` Properties

If you plan to access shared static data from `async` code or across threads, use an `actor` for safety:

```swift
actor School {
    static var studentCount = 0

    static func add(student: String) async {
        print("\(student) joined the school.")
        studentCount += 1
    }
}
```

Usage:

```swift
Task {
    await School.add(student: "Taylor Swift")
    print(await School.studentCount)
}
```

Or if not using `async/await`, use a `DispatchQueue` to manually sync access:

```swift
struct School {
    private static var _studentCount = 0
    private static let queue = DispatchQueue(label: "school.studentCount.queue")

    static var studentCount: Int {
        queue.sync { _studentCount }
    }

    static func add(student: String) {
        queue.sync {
            print("\(student) joined the school.")
            _studentCount += 1
        }
    }
}
```

---

#### Why Use `static`?

**1. Shared Data**

When you need to store app-wide values in one place:

```swift
struct AppData {
    static let version = "1.3 beta 2"
    static let saveFilename = "settings.json"
    static let homeURL = "https://www.hackingwithswift.com"
}
```

Use:

```swift
print(AppData.version)
```

---

**2. Example / Preview Data**

In SwiftUI, this helps provide previews with mock data:

```swift
struct Employee {
    let username: String
    let password: String

    static let example = Employee(username: "cfederighi", password: "hairforceone")
}
```

Usage:

```swift
let previewUser = Employee.example
```

---

#### Mixing Static and Non-Static

```swift
struct Team {
    static var teamCount = 0
    var name: String

    init(name: String) {
        self.name = name
        Team.teamCount += 1 // Accessing static from non-static
    }

    func announce() {
        print("\(name) is ready to play!")
        print("Total teams: \(Self.teamCount)") // 'Self' refers to the type
    }
}
```

---

#### ⚠️ Rules to Remember

* ❌ Static methods **cannot access instance properties**
* ✅ Instance methods **can access static properties** using `Self` or the type name
* `self` = current **instance**
* `Self` = current **type**

---

#### ✅ When to Use Static?

Use it for:

* Configuration constants (`AppData.version`)
* Shared counters (`School.studentCount`)
* Preview/sample data (`Employee.example`)
* Utility functions (e.g., formatting helpers)

---

### Checkpoint 6: Car Gear Logic in Swift

This checkpoint explores how to model a car with gears in Swift. You'll create a struct that tracks the model, number of seats, and current gear, and provides a method to shift gears.

---

#### 🚗 Basic Version (No Enums)

This version uses a `String` to track gear state, and toggles between "up" and "down".

```swift
struct Car {
    let model: String
    let numberOfSeats: Int
    private(set) var currentGear: Int

    mutating func changeGear(up: Bool) {
        if up {
            if currentGear < 6 {
                currentGear += 1
            } else {
                print("Already in highest gear.")
            }
        } else {
            if currentGear > 1 {
                currentGear -= 1
            } else {
                print("Already in lowest gear.")
            }
        }
    }
}

```

#### Refactored Version: Using `enum` for Gears

This version uses an `enum` with `Int` raw values and `Comparable` conformance to make gear logic cleaner and type-safe.

```swift
enum Gear: Int, CaseIterable, Comparable {
    case reverse = 0
    case one, two, three, four, five, six
    
    // Need to conform to Comparable
    static func < (lhs: Gear, rhs: Gear) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var displayName: String {
        switch self {
        case .reverse: return "R"
        default: return "\(self.rawValue)"
        }
    }
    
    static var minForwardGear: Gear { .one }
    static var maxForwardGear: Gear { .six }
}
```

```swift
struct Car {
    
    let model: String
    let numberOfSeats: Int
    private(set) var currentGear: Gear = .one
    
    
    init(model: String, numberOfSeats: Int, startingGear: Gear = .one) {
        self.model = model
        self.numberOfSeats = numberOfSeats
        self.currentGear = startingGear
    }
    
    
    mutating func changeGear(up: Bool) {
        switch (up, currentGear) {
        case (true, Gear.one ..< Gear.maxForwardGear):
            currentGear = Gear(rawValue: currentGear.rawValue + 1)!
        case (false, Gear.minForwardGear ... Gear.maxForwardGear):
            currentGear = Gear(rawValue: currentGear.rawValue - 1)!
        default:
            print("Cannot shift gear further in this direction.")
        }
    }
    
    func printStatus() {
        print("Model: \(model), Seats: \(numberOfSeats), Current Gear: \(currentGear.displayName)")
    }
    
}
```

#### Benefits of `enum`-based approach:

* Type safety (no invalid gear values)
* Easier to extend (e.g., add reverse)
* Cleaner logic with `Comparable` ranges

---

#### Bonus: Car with Reverse Gear (`R`)

- In this version, we extend the Gear enum to include .reverse, and wrap the original Car struct to reuse its logic. 

- This approach improves encapsulation and avoids duplicating code.

```swift
struct CarWithR {
    var baseCar: Car
    
    init(model: String, numberOfSeats: Int){
        self.baseCar = Car(model: model, numberOfSeats: numberOfSeats, startingGear: .reverse)
    }
    
    mutating func changeGear(up: Bool){
        switch(up, baseCar.currentGear){
        case(true, .reverse):
            baseCar = Car(model: baseCar.model, numberOfSeats: baseCar.numberOfSeats, startingGear: .one)
        case(false, .one):
            baseCar = Car(model: baseCar.model, numberOfSeats: baseCar.numberOfSeats, startingGear: .reverse)
        default:
            baseCar.changeGear(up: up)
        }
    }
    
    func printStatus() {
         baseCar.printStatus()
     }
}

```
