import Cocoa

// MARK: - Structs

/*
 Swift structs let us define custom data types with their own properties and methods.
 Struct names use UpperCamelCase (e.g. Album), while properties/methods use lowerCamelCase.
 
 Example Struct:
 */

struct Album {
    let title: String
    let artist: String
    let year: Int
    
    func printSummary() {
        print("\(title) (\(year)) by \(artist)")
    }
}

let red = Album(title: "Red", artist: "Taylor Swift", year: 2012)
let wings = Album(title: "Wings", artist: "BTS", year: 2016)

red.printSummary()
wings.printSummary()

/*
 - Structs are value types: copies are independent.
 - Methods inside structs can access the struct's properties.
 - To allow changing properties, methods must be marked with `mutating`.
 
 Example with mutable properties:
 */

struct Employee {
    let name: String
    var vacationRemaining = 14
    
    mutating func takeVacation(days: Int) {
        if vacationRemaining >= days {
            vacationRemaining -= days
            print("Vacation taken. Days left: \(vacationRemaining)")
        } else {
            print("Not enough vacation days.")
        }
    }
}

var archer = Employee(name: "Sterling Archer")  // vacationRemaining defaults to 14
archer.takeVacation(days: 5)
// archer is `var` so we can call a mutating method

/*
 Terminology:
 - Properties: Variables/constants inside a struct
 - Methods: Functions inside a struct
 - Instance: A specific variable of that struct type
 - Initializer: `init(...)` lets us create new instances
 */

// Swift auto-generates an initializer:
let kane = Employee(name: "Lana Kane") // vacationRemaining defaults to 14
let pam = Employee(name: "Pam Poovey", vacationRemaining: 35)

/*
 Extra Tip:
 If you assign a default to a constant property, Swift removes it from the initializer.
 Use `var` if you want to allow overriding the default.
 
 This is also how native types like Double work:
 */

let a = 1
let b = 2.0
let c = Double(a) + b // Double(a) calls an initializer


// MARK: Stored vs Computed Properties

// A stored property holds data directly
// A computed property calculates data dynamically

struct EmployeeComputed {
    let name: String
    var vacationAllocated = 14
    var vacationTaken = 0
    
    // Computed property: read-only version
    var vacationRemaining: Int {
        vacationAllocated - vacationTaken
    }
    
    // If you want to allow writing too, use get + set
    var adjustableVacationRemaining: Int {
        get {
            vacationAllocated - vacationTaken
        }
        set {
            vacationAllocated = vacationTaken + newValue
        }
    }
}

// MARK: Usage

var archers = EmployeeComputed(name: "Sterling Archers")

// Using the read-only computed property
archers.vacationTaken += 4
print("Vacation remaining: \(archer.vacationRemaining)")

// Using the computed property with getter and setter
archers.adjustableVacationRemaining = 5
print("Vacation allocated adjusted to: \(archers.vacationAllocated)")


// MARK: - Property Observers in Swift

// Property observers let us respond to changes in values.
// - `willSet` runs just BEFORE the value changes.
// - `didSet` runs just AFTER the value changes.

/// 🎮 Simple Example: Game Score Tracker
struct Game {
    var score = 0 {
        didSet {
            print("Score is now \(score)")
        }
    }
}

var game = Game()
game.score += 10  // prints: Score is now 10
game.score -= 3   // prints: Score is now 7
game.score += 1   // prints: Score is now 8


/// 📇 More Advanced Example: Contacts App
struct App {
    var contacts = [String]() {
        willSet {
            print("📋 Current contacts: \(contacts)")
            print("➕ Adding: \(newValue.last ?? "Unknown")")
        }
        didSet {
            print("✅ Total contacts: \(contacts.count)")
            print("🕓 Previous contacts: \(oldValue)\n")
        }
    }
}

var app = App()
app.contacts.append("Adrian E")
app.contacts.append("Allen W")
app.contacts.append("Ish S")

// MARK: - Custom Initializers

// What are Initializers?

/// Initializers are special methods used to create new instances of a struct.
/// Swift automatically gives us a "memberwise initializer" that sets each property.

struct Player {
    let name: String
    let number: Int
}

// ✅ Using the auto-generated initializer
let player1 = Player(name: "Megan R", number: 15)
print("Player 1: \(player1.name), #\(player1.number)")


//  Custom Initializer

/// You can create your own initializer to add custom logic.
/// Rule: All properties must have values before the initializer ends.

struct PlayerWithInit {
    let name: String
    let number: Int
    
    // 🔧 Custom initializer
    init(name: String, number: Int) {
        self.name = name              // `self` refers to the instance's property
        self.number = number
    }
}

let player2 = PlayerWithInit(name: "Megan R", number: 15)
print("Player 2: \(player2.name), #\(player2.number)")


//  Randomized Initializer

/// Custom initializers can do anything, like assign random values.

struct RandomPlayer {
    let name: String
    let number: Int
    
    init(name: String) {
        self.name = name
        number = Int.random(in: 1...99)  // Random shirt number
    }
}

let player3 = RandomPlayer(name: "Megan R")
print("Player 3: \(player3.name), #\(player3.number)")


// Important Notes

/*
 - Initializers don’t use the `func` keyword.
 - They don’t return anything explicitly – they always return an instance.
 - You MUST assign values to all properties before using methods or completing the init.
 - As soon as you write a custom initializer, you lose the auto-generated one.
 */


// Multiple Initializers

/// You can define multiple initializers with different parameters

struct MultiPlayer {
    let name: String
    let number: Int
    
    // Memberwise style
    init(name: String, number: Int) {
        self.name = name
        self.number = number
    }
    
    // Random number style
    init(name: String) {
        self.name = name
        self.number = Int.random(in: 1...99)
    }
}

let player4 = MultiPlayer(name: "Ish S", number: 42)
let player5 = MultiPlayer(name: "Allen W")
print("Player 4: \(player4.name), #\(player4.number)")
print("Player 5: \(player5.name), #\(player5.number)")

// MARK: - Limit Internal Data Access With Access Control

/*
 Swift Access Control for Structs
 
 By default, struct properties and methods are publicly accessible,
 but sometimes you want to hide or restrict access to protect data or logic.
 */

// Example without access control:
struct BankAccount {
    var funds = 0   // Public by default
    
    mutating func deposit(amount: Int) {
        funds += amount
    }
    
    mutating func withdraw(amount: Int) -> Bool {
        if funds >= amount {
            funds -= amount
            return true
        } else {
            return false
        }
    }
}

var account = BankAccount()
account.deposit(amount: 100)
let success = account.withdraw(amount: 200)
print(success ? "Withdrew money successfully" : "Failed to get the money")

// But we can bypass the logic and directly modify funds:
account.funds -= 1000   // This is allowed — VERY DANGEROUS!

// ---- Access Control ----

struct SecureBankAccount {
    // This property is only accessible *inside* the struct
    private(set) var funds = 0
    
    mutating func deposit(amount: Int) {
        funds += amount
    }
    
    mutating func withdraw(amount: Int) -> Bool {
        if funds >= amount {
            funds -= amount
            return true
        } else {
            return false
        }
    }
}

var secureAccount = SecureBankAccount()
secureAccount.deposit(amount: 100)
print("Balance is \(secureAccount.funds)")  // Allowed: funds can be read

// secureAccount.funds -= 1000  // Error: Cannot modify because setter is private

// ---- Summary of Access Levels ----

/*
 - private: accessible only inside the struct.
 - fileprivate: accessible within the current source file.
 - public: accessible anywhere.
 - private(set): readable anywhere, writable only inside the struct.
 */

// Why use access control?
// It prevents accidental misuse of data and enforces rules.
// Often, if you make properties private, you’ll need to write your own initializer.

// Example initializer needed if funds is private:
struct Bank {
    private var funds: Int
    
    init(initialFunds: Int) {
        self.funds = initialFunds
    }
    
    mutating func deposit(amount: Int) {
        funds += amount
    }
    
    mutating func withdraw(amount: Int) -> Bool {
        if funds >= amount {
            funds -= amount
            return true
        } else {
            return false
        }
    }
    
    func currentFunds() -> Int {
        funds
    }
}

var bank = Bank(initialFunds: 50)
print(bank.currentFunds())
bank.deposit(amount: 100)
print(bank.currentFunds())

// MARK: - Static Properties and Methods

// A struct where both the method and property are static
struct School {
    static var studentCount = 0 // Error: Static property 'studentCount' is not concurrency-safe because it is nonisolated global shared mutable state
    
    static func add(student: String) {
        print("\(student) joined the school.")
        studentCount += 1
    }
}

// Using static method and property – no need to create an instance
School.add(student: "Taylor Swift")
School.add(student: "Paul Hudson")
print("Total students: \(School.studentCount)")

//  Mixing Static and Non-Static

struct Team {
    static var teamCount = 0 // ERROR: Static property 'teamCount' is not concurrency-safe because it is nonisolated global shared mutable state
    var name: String
    
    init(name: String) {
        self.name = name
        // Accessing static from non-static code using type name
        Team.teamCount += 1
    }
    
    func announce() {
        print("\(name) is ready to play!")
        // You can also use Self to refer to the type
        print("There are now \(Self.teamCount) teams.")
    }
}

let t1 = Team(name: "Lions")
let t2 = Team(name: "Tigers")
t1.announce()
t2.announce()

// Static Properties for App-Wide Data

struct AppData {
    static let version = "1.3 beta 2"
    static let saveFilename = "settings.json"
    static let homeURL = "https://www.hackingwithswift.com"
}

print("App Version: \(AppData.version)")
print("Saving to: \(AppData.saveFilename)")
print("Home URL: \(AppData.homeURL)")

// Static Property for Sample Data

struct Employees {
    let username: String
    let password: String
    
    // Static sample data for design previews or testing
    static let example = Employees(username: "cfederighi", password: "hairforceone")
}

let exampleEmp = Employees.example
print("Previewing as: \(exampleEmp.username)")

// MARK: - Checkpoint 6

// The challenge:
/// - Create a struct to represent a car, with properties for model, number of seats, and current gear.
/// - Add a method to shift gears up or down, including logic to prevent invalid gear changes.
/// - Consider what should be constants vs. variables, what should be private vs. public,
/// - and optionally use enums to represent gear states cleanly.


// MARK: Basic Version

struct CarBasic {
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

// MARK: -  Refactored Version

// MARK: Shared Gear Enum

// ❗ ERROR EXPLANATION:
// Referencing operator function '..<' on 'Comparable' requires that 'Car.Gear' conform to 'Comparable'
// ❓ WHY?
// We were using a range like Gear.one ..< Gear.six inside a switch,
// which requires Gear to conform to Comparable.
// Enums with raw values (like Int) don't automatically conform to Comparable.

enum Gear: Int, CaseIterable, Comparable {
    case reverse = 0
    case one, two, three, four, five, six
    
    // ✅ Error fixed
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

// MARK: CarWithR: Adds Reverse Gear

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

// Example Usage

var car = CarBasic(model: "Tesla Model 3", numberOfSeats: 5, currentGear: 1)
car.changeGear(up: true)
print(car.currentGear) // 2
car.changeGear(up: false)
print(car.currentGear) // 1


var basic = Car(model: "Model 3", numberOfSeats: 5)
basic.printStatus() // 1
basic.changeGear(up: true)
basic.printStatus() // 2

var withR = CarWithR(model: "Model S", numberOfSeats: 5)
withR.printStatus() // R
withR.changeGear(up: true)
withR.printStatus() // 1
withR.changeGear(up: true)
withR.printStatus() // 2
withR.changeGear(up: false)
withR.printStatus() // 1
withR.changeGear(up: false)
withR.printStatus() // R

