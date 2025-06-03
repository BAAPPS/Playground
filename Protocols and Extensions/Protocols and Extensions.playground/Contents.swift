import Cocoa

// MARK: - Protocols Creation and Usage


// MARK:  Defining the Protocol

// A blueprint for any kind of vehicle.
// It declares required methods and properties but doesn't implement them.
protocol Vehicle {
    var name: String { get }              // Must be readable
    var currentPassengers: Int { get set } // Must be readable and writeable

    func estimateTime(for distance: Int) -> Int
    func travel(distance: Int)
}

// MARK: Conforming Structs

// Car conforms to Vehicle protocol by implementing all required methods and properties.
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

// Bicycle also conforms to Vehicle protocol.
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


// MARK:  Commuting Function

// Accepts any Vehicle type – not just Car or Bicycle.
func commute(distance: Int, using vehicle: Vehicle) {
    if vehicle.estimateTime(for: distance) > 100 {
        print("❌ That's too slow! I'll try a different vehicle.")
    } else {
        vehicle.travel(distance: distance)
    }
}

// Try commuting using different vehicles
let car = Car()
let bike = Bicycle()

commute(distance: 100, using: car)  // ✅ Should drive
commute(distance: 100, using: bike) // ✅ Should cycle

// MARK:  Getting Estimates for Multiple Vehicles

// Function that takes an array of any Vehicle types
func getTravelEstimates(using vehicles: [Vehicle], distance: Int) {
    for vehicle in vehicles {
        let estimate = vehicle.estimateTime(for: distance)
        print("🧾 \(vehicle.name): \(estimate) hours to travel \(distance)km")
    }
}

// Compare multiple options
getTravelEstimates(using: [car, bike], distance: 150)

// MARK: Recap

/*
 ✅ Protocols define required methods and properties.
 ✅ Any struct/class/enum can adopt a protocol and provide their own implementations.
 ✅ We used a Vehicle protocol to create a flexible commuting system.
 ✅ Functions can accept or return protocol types for maximum flexibility.
 ✅ We can easily expand the system by adding more Vehicle types – like Bus, Train, or Scooter – without changing existing logic.
*/

// MARK: - Opaque Return Types

//: Swift provides a powerful but subtle feature called **opaque return types**.
//: They allow you to hide the exact return type while still preserving its capabilities.
//: This feature is used heavily in SwiftUI with `some View`.
//:
//: Let's explore how it works with some simple examples.

//: ### Step 1: Basic functions returning concrete types

func getRandomNumber() -> Int {
    Int.random(in: 1...6)
}

func getRandomBool() -> Bool {
    Bool.random()
}

print("Random Number:", getRandomNumber())
print("Random Bool:", getRandomBool())

//: ### Step 2: Both Int and Bool conform to Equatable

print("Are numbers equal? ", getRandomNumber() == getRandomNumber())
print("Are bools equal? ", getRandomBool() == getRandomBool())

//: ### Step 3: Trying to return protocol `Equatable` directly (this **does not compile**)
//:
/*
func invalidRandomNumber() -> Equatable {
    Int.random(in: 1...6)
}
*/
//: Uncommenting above code produces error:
//: `protocol 'Equatable' can only be used as a generic constraint because it has Self or associated type requirements`
//:
//: This happens because Swift cannot guarantee you will always get the same concrete type behind Equatable,
//: which is required to compare values correctly.

//: ### Step 4: Using opaque return type with `some Equatable`

func getOpaqueRandomNumber() -> some Equatable {
    Int.random(in: 1...6)
}

func getOpaqueRandomBool() -> some Equatable {
    Bool.random()
}

print("Opaque Ints equal? ", getOpaqueRandomNumber() == getOpaqueRandomNumber())

//: ### Real-world analogy with Vehicles

protocol VehicleOP {
    var name: String { get }
    func travel()
}

struct Compact: VehicleOP {
    let name = "Compact"
    func travel() {
        print("🚗 Zipping through the city.")
    }
}

struct SUV: VehicleOP {
    let name = "SUV"
    func travel() {
        print("🚙 Handling rough terrain.")
    }
}

//: Function returning an opaque Vehicle type
func getVehicle(for terrain: String) -> some VehicleOP {
    return Compact()
}

let carOp = getVehicle(for: "city")
carOp.travel()

//: ### SwiftUI analogy

import SwiftUI

struct ExampleView: View {
    var body: some View {
        VStack {
            Text("Hello")
            Text("World").bold()
        }
    }
}

// MARK: - Extensions


// MARK: Basic trimmingCharacters(in:) usage

// Here is a string with whitespace on both sides:
var quote = "   The truth is rarely pure and never simple   "

// Using Foundation's trimmingCharacters(in:) to trim whitespace and newlines:
let trimmed = quote.trimmingCharacters(in: .whitespacesAndNewlines)
print("Trimmed quote: '\(trimmed)'")

// MARK: Extension to String for convenience

extension String {
    // Returns a new string trimmed of whitespace and newlines
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

let trimmed2 = quote.trimmed()
print("Trimmed using extension: '\(trimmed2)'")

// MARK: Global function alternative (for comparison)

func trim(_ string: String) -> String {
    string.trimmingCharacters(in: .whitespacesAndNewlines)
}

let trimmed3 = trim(quote)
print("Trimmed using global function: '\(trimmed3)'")

// MARK: Why use extensions over global functions?

// Extensions group functionality by type, offer autocompletion,
// access to private members, and keep code clean and organized.

// MARK: Mutating extension method to trim in place

extension String {
    // Mutates the string itself to trim whitespace and newlines
    mutating func trim() {
        self = self.trimmed()
    }
}

// Since `quote` is a variable (var), we can modify it in place:
quote.trim()
print("Quote after in-place trim: '\(quote)'")

// MARK: Computed properties in extensions

extension String {
    // Computed property that returns the string broken into lines
    var lines: [String] {
        self.components(separatedBy: .newlines)
    }
}

let lyrics = """
But I keep cruising
Can't stop, won't stop moving
It's like I got this music in my mind
Saying it's gonna be alright
"""

print("Number of lines in lyrics: \(lyrics.lines.count)")

// MARK: Extensions and initializers in structs

struct Book {
    let title: String
    let pageCount: Int
    let readingHours: Int
}

// Using Swift's automatic memberwise initializer:
let lotr = Book(title: "Lord of the Rings", pageCount: 1178, readingHours: 24)

// If we want to add a custom initializer with logic:

// This disables the automatic memberwise initializer:
// struct Book {
//     let title: String
//     let pageCount: Int
//     let readingHours: Int
//
//     init(title: String, pageCount: Int) {
//         self.title = title
//         self.pageCount = pageCount
//         self.readingHours = pageCount / 50
//     }
// }

// To keep both initializers, put the custom initializer inside an extension:

extension Book {
    init(title: String, pageCount: Int) {
        self.title = title
        self.pageCount = pageCount
        self.readingHours = pageCount / 50
    }
}

let swiftBook = Book(title: "Swift Programming", pageCount: 500)
print("SwiftBook reading hours: \(swiftBook.readingHours)")


// MARK: - Protocol Extensions in Swift

// Protocols define contracts that types must follow,
// and extensions add functionality to existing types.
// Protocol extensions combine both: adding methods to protocols
// so all conforming types get default behavior.

// Example: Checking if an Array is not empty
let guests = ["Mario", "Luigi", "Peach"]

// Typical ways to check if array is not empty:
if guests.isEmpty == false {
    print("Guest count: \(guests.count)")
}

if !guests.isEmpty {
    print("Guest count: \(guests.count)")
}

// These work but can read awkwardly, like "if not empty".

// Let's improve readability by adding an extension on Array:
extension Array {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

// Now we can write:
if guests.isNotEmpty {
    print("Guest count: \(guests.count)")
}

// This is better, but what about Set or Dictionary?

// They also have isEmpty because they conform to Collection.
// Instead of repeating for each type, extend Collection protocol:

extension Collection {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

// Now isNotEmpty works on Array, Set, Dictionary, and any Collection:

let fruits: Set = ["Apple", "Banana"]
if fruits.isNotEmpty {
    print("Fruit count: \(fruits.count)")
}

let scores: [String: Int] = ["Alice": 90, "Bob": 85]
if scores.isNotEmpty {
    print("Scores count: \(scores.count)")
}

// This is powerful: adding behavior for all conforming types at once.

// MARK: Protocol-Oriented Programming

// Define a protocol with required properties/methods:
protocol Person {
    var name: String { get }
    func sayHello()
}

// Add a default implementation of sayHello in a protocol extension:
extension Person {
    func sayHello() {
        print("Hi, I'm \(name)")
    }
}

// Now conforming types can rely on the default sayHello, or override it if needed.

// Create a struct that conforms but does NOT implement sayHello:
struct Employee: Person {
    let name: String
}

// Using the default implementation from the protocol extension:
let taylor = Employee(name: "Taylor Swift")
taylor.sayHello()  // Prints: Hi, I'm Taylor Swift

// If you want, you can provide a custom sayHello:
struct Manager: Person {
    let name: String
    func sayHello() {
        print("Hello, my name is \(name), and I manage the team.")
    }
}

let alex = Manager(name: "Alex")
alex.sayHello()  // Prints: Hello, my name is Alex, and I manage the team.

// MARK: - Protocol Extensions (Advanced Swift Concepts)

//: This section explores protocol extensions, using `Self`, and protocol inheritance like `Equatable` and `Comparable`.

//: ## 1. Extending a Concrete Type

//: Let’s start simple: a squared() function for integers
extension Int {
    func squared() -> Int {
        self * self
    }
}

let wholeNumber = 5
print("5 squared is:", wholeNumber.squared()) // → 25

//: ## 2. Generalizing with Protocol Extensions
//: `Int` and `Double` both conform to the `Numeric` protocol.

extension Double {
    func squared() -> Double {
        self * self
    }
}

let decimal = 3.14
print("3.14 squared is:", decimal.squared()) // → 9.8596

//: Can we avoid repeating ourselves? Try extending the protocol:
/// ⚠️ This version fails! Return type is hardcoded as Int
/*
extension Numeric {
    func squared() -> Int {
        self * self // ❌ Error
    }
}
*/

//: ✅ Fix: Use `Self` as the return type to match the type calling the method

extension Numeric {
    func squared() -> Self {
        self * self
    }
}

let intVal: Int = 6
let doubleVal: Double = 2.5

print("6 squared is:", intVal.squared())        // → 36
print("2.5 squared is:", doubleVal.squared())   // → 6.25

//: Tip: `self` means the *value* (`2.5`), while `Self` refers to the *type* (`Double`).
//: ---
//:
//: ## 3. Exploring Equatable
//: `Equatable` allows comparison using `==` and `!=`

struct User: Equatable {
    let name: String
}

let user1 = User(name: "Link")
let user2 = User(name: "Zelda")

print("Are users equal?", user1 == user2) // false
print("Are users unequal?", user1 != user2) // true

//: You didn’t have to write any extra code — Swift auto-synthesizes `==` for `Equatable` structs!

//: ## 4. Making Types Comparable
//: `Comparable` lets us sort and compare order using `<`, `<=`, `>` etc.
//: You must implement `<`, then Swift gives you the rest.

struct Persons: Comparable {
    let name: String
}

// Required: Define how to compare two people
func <(lhs: Persons, rhs: Persons) -> Bool {
    lhs.name < rhs.name
}

let p1 = Persons(name: "Taylor")
let p2 = Persons(name: "Adele")

print("Is Taylor < Adele?", p1 < p2)     // false
print("Is Taylor >= Adele?", p1 >= p2)   // true

//: Why does `==` work? Because Comparable *inherits* from Equatable!
//: This means Comparable structs automatically support `==` even if not explicitly declared `Equatable`.
let people = [p1, p2].sorted()
for p in people {
    print("Sorted name:", p.name)
}

// MARK: - Checkpoint 8

//: Build a protocol for buildings, and have House and Office conform to it using protocol extensions

//: ### Step 1: Define the protocol

protocol Building {
    var numberOfRooms: Int { get }
    var cost: Int { get }
    var agentName: String { get }
    var buildingType: String { get }
    
    func printSalesSummary()
}

//: ### 🔷 Step 2: Add default implementation with a protocol extension
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

//: ### 🏡 Step 3: Define a House that conforms to Building
struct House: Building {
    let numberOfRooms: Int
    let cost: Int
    let agentName: String
    let buildingType = "House"
}

//: ### 🏢 Step 4: Define an Office that conforms to Building
struct Office: Building {
    let numberOfRooms: Int
    let cost: Int
    let agentName: String
    let buildingType = "Office"
}

//: ### Step 5: Create instances and print summaries

let myHouse = House(numberOfRooms: 3, cost: 450_000, agentName: "Alice Johnson")
let myOffice = Office(numberOfRooms: 10, cost: 1_250_000, agentName: "Bob Smith")

myHouse.printSalesSummary()
myOffice.printSalesSummary()
