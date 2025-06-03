import Cocoa

// MARK: - Classes Creation

// MARK:  Classes vs Structs in Swift


// Example using class
class Game {
    var score = 0 {
        didSet {
            print("Score is now \(score)")
        }
    }
}

var gameA = Game()
var gameB = gameA
gameB.score += 10 // Affects both gameA and gameB because they reference the same object
print("Game A Score: \(gameA.score)") // 10
print("Game B Score: \(gameB.score)") // 10


// Equivalent using struct
struct GameStruct {
    var score = 0 {
        didSet {
            print("Score is now \(score)")
        }
    }
}

var gameX = GameStruct()
var gameY = gameX
gameY.score += 10 // Only affects gameY — structs are copied
print("Game X Score: \(gameX.score)") // 0
print("Game Y Score: \(gameY.score)") // 10

// MARK: - Class Inheritance

// Swift lets us build new classes from existing ones using inheritance.
// The new class (child) gets the properties and methods of the parent.

// MARK:  Base Class

class Employee {
    let hours: Int
    
    init(hours: Int) {
        self.hours = hours
    }
    
    func printSummary() {
        print("I work \(hours) hours a day.")
    }
}

// MARK: Subclasses

class Developer: Employee {
    func work() {
        print("I'm writing code for \(hours) hours.")
    }
    
    // Child class overrides parent method
    override func printSummary() {
        print("I'm a developer who sometimes works \(hours) hours a day, but other times argue about tabs vs spaces.")
    }
}

class Manager: Employee {
    func work() {
        print("I'm going to meetings for \(hours) hours.")
    }
}

// MARK: Instances and Method Calls

let robert = Developer(hours: 8)
let joseph = Manager(hours: 10)

robert.work()            // Output: I'm writing code for 8 hours.
joseph.work()            // Output: I'm going to meetings for 10 hours.

robert.printSummary()    // Custom summary
joseph.printSummary()    // Inherited summary

// MARK:  Final Class Example

// Use 'final' to prevent this class from being subclassed.
final class Intern: Employee {
    func learn() {
        print("I'm learning for \(hours) hours.")
    }
}

// Uncommenting the line below will cause an error:
// class JuniorIntern: Intern {}  // ❌ Cannot inherit from 'final' class 'Intern'

// MARK: - Class Initializer

// Class initializers are more complex than struct initializers.
// If a subclass has its own initializer, it *must* call the parent's initializer
// after setting up its own properties.

// Swift does NOT generate memberwise initializers for classes,
// so you must write your own or provide default values.

// MARK: Parent Class

class Vehicle {
    let isElectric: Bool
    
    init(isElectric: Bool) {
        self.isElectric = isElectric
    }
}

// MARK: Subclass with Incorrect Initializer

/*
 class Car: Vehicle {
 let isConvertible: Bool
 
 // ❌ This will cause a build error because
 // we didn't call super.init(isElectric:)
 init(isConvertible: Bool) {
 self.isConvertible = isConvertible
 }
 }
 */

// MARK: Correct Subclass Initializer

class Car: Vehicle {
    let isConvertible: Bool
    
    init(isElectric: Bool, isConvertible: Bool) {
        self.isConvertible = isConvertible       // Setup own property first
        super.init(isElectric: isElectric)       // Then call parent initializer
    }
}

// MARK: Using the Class

let teslaX = Car(isElectric: true, isConvertible: false)

// MARK: Important Tip

// If the subclass does NOT define any custom initializers,
// it automatically inherits all initializers from the parent.

// MARK: - Reference Types: Classes share data between copies

class User {
    var username = "Anonymous"
    
    // A method to create a deep copy of this instance
    func copy() -> User {
        let userCopy = User()
        userCopy.username = username
        return userCopy
    }
}

// Create an instance of User
var user1 = User()

// Copy user1 reference into user2 (both point to the same object)
var user2 = user1

// Change username on user2
user2.username = "Taylor"

// Both user1 and user2 share the same data (reference type)
print(user1.username)  // Prints: Taylor
print(user2.username)  // Prints: Taylor

// MARK: Contrast with Structs (Value Types)

struct UserStruct {
    var username = "Anonymous"
}

var structUser1 = UserStruct()
var structUser2 = structUser1

// Changing structUser2 doesn't affect structUser1 (value types are copied)
structUser2.username = "Taylor"

print(structUser1.username) // Prints: Anonymous
print(structUser2.username) // Prints: Taylor

// MARK: Deep Copy Example with Classes

// Using the copy() method to create an independent copy
var user3 = user1.copy()
user3.username = "Alex"

// user1 remains unchanged after modifying user3
print(user1.username) // Prints: Taylor
print(user3.username) // Prints: Alex


// MARK: - Deinitializers in Swift Classes

/*
 Deinitializers are special methods that run when an instance of a class is about to be destroyed.
 They are like the opposite of initializers — instead of setting up, they clean up.
 */

// Example class demonstrating init and deinit
class Users {
    let id: Int
    
    init(id: Int) {
        self.id = id
        print("User \(id): I'm alive!")
    }
    
    // deinit has no parameters and no parentheses
    deinit {
        print("User \(id): I'm dead!")
    }
}

// Create and destroy instances in a loop
for i in 1...3 {
    let user = Users(id: i)
    print("User \(user.id): I'm in control!")
    // 'user' goes out of scope here at end of iteration,
    // so deinit is called before next iteration starts
}

// MARK: Scope and Deinitializer Behavior

/*
 Scope defines where a variable or constant is accessible.
 When a value goes out of scope, if it’s a class instance and no other references exist,
 the instance is destroyed and deinit is called.
 */

// If we keep references alive, deinit waits until those references are gone

var users = [Users]()

for i in 1...3 {
    let user = Users(id: i)
    print("User \(user.id): I'm in control!")
    users.append(user) // keep strong references in array
}

print("Loop is finished!")

// At this point, no User instances are destroyed because 'users' array still holds them

users.removeAll() // removing references triggers deinit for all

print("Array is clear!")

// MARK: - Understanding Class References and Property Mutability

// This class has one variable property
class UserSignPost {
    var name = "Paul"
}

// MARK: Case 1: Constant Instance, Variable Property

// We create a constant instance of the class
let user_1 = UserSignPost()

// We CAN change the variable property even though 'user1' is a constant
user_1.name = "Taylor"
print("Case 1 - user1 name: \(user_1.name)") // Prints "Taylor"

// Why? Because 'user1' is a constant reference (signpost), but it still points
// to the same underlying object, and that object’s internal data (variable property) can be changed.


// MARK: Case 2: Constant Instance, Constant Property

class UserFixed {
    let name = "Paul"
}

let user_2 = UserFixed()
// The line below would trigger a compile-time error:
// user2.name = "Taylor" ❌

// MARK: Case 3: Variable Instance, Variable Property

var user_3 = UserSignPost()
user_3.name = "Taylor"   // ✅ Change property
user_3 = UserSignPost()          // ✅ Change entire instance
print("Case 3 - user3 name: \(user_3.name)") // Prints "Paul"


// MARK: Case 4: Variable Instance, Constant Property

class ImmutableNameUser {
    let name = "Paul"
}

var user4 = ImmutableNameUser()
// Changing name directly is NOT allowed:
// user4.name = "Taylor" ❌

// But changing the instance is fine:
user4 = ImmutableNameUser()
print("Case 4 - user4 name: \(user4.name)") // Prints "Paul"


// MARK: Demonstrating Shared Reference

var original = UserSignPost()
var copy = original

copy.name = "Updated"

// Both references reflect the change, since they point to the same object
print("Original name: \(original.name)") // Prints "Updated"
print("Copy name: \(copy.name)")         // Prints "Updated"


// MARK: Why It Matters

// The fact that changes in one reference affect the others is powerful,
// but it also means you need to be careful with shared mutable state.

let sharedUser = UserSignPost()
sharedUser.name = "Admin"
// Somewhere else in the code, this might happen:
func resetUserName(_ user: UserSignPost) {
    user.name = "Guest"
}

resetUserName(sharedUser)
print("Shared user name: \(sharedUser.name)") // Might unexpectedly print "Guest"


// MARK: Contrast with Struct

struct StructUser {
    var name = "Paul"
}

let structUser = StructUser()
// structUser.name = "Taylor" ❌ Error: Cannot assign to property: 'structUser' is a 'let' constant

// In structs, even variable properties can't be changed if the instance is constant.
// Why? Because the value is stored directly, not as a reference (signpost).


// MARK: mutating Keyword Is Not Needed for Classes

class Account {
    var balance = 100
    
    func deposit(amount: Int) {
        balance += amount
    }
}

let account = Account()
account.deposit(amount: 50) // ✅ no need for `mutating`
print("New balance: \(account.balance)") // 150


// MARK: - Checkpoint 7

/*
 CHALLENGE:
 Create a class hierarchy for animals using Swift classes.
 
 REQUIREMENTS:
 - A base class `Animal` with an `Int` property `legs`
 - A `Dog` subclass of `Animal` with a `speak()` method
 - Subclasses of `Dog`: `Corgi`, `Poodle`, each overriding `speak()`
 - A `Cat` subclass of `Animal` with:
     - a `Bool` property `isTame`, set via initializer
     - a `speak()` method
 - Subclasses of `Cat`: `Persian`, `Lion`, each overriding `speak()`

 GOAL:
 Demonstrate inheritance, initializers, and method overriding with class instances.
*/

// MARK: Class Hierarchy

class Animal {
    var legs: Int

    init(legs: Int = 4) {
        self.legs = legs
    }
}

class Dog: Animal {
    func speak() {
        print("The dog barks.")
    }
}

class Corgi: Dog {
    override func speak() {
        print("The corgi yaps excitedly!")
    }
}

class Poodle: Dog {
    override func speak() {
        print("The poodle woofs elegantly!")
    }
}

class Cat: Animal {
    var isTame: Bool

    init(isTame: Bool, legs: Int = 4) {
        self.isTame = isTame
        super.init(legs: legs)
    }

    func speak() {
        print("The cat meows.")
    }
}

class Persian: Cat {
    override func speak() {
        print("The Persian purrs gently.")
    }
}

class Lion: Cat {
    override func speak() {
        print("The lion roars fiercely!")
    }
}

// MARK: - Test Cases

let corgi = Corgi()
corgi.speak() // "The corgi yaps excitedly!"

let poodle = Poodle()
poodle.speak() // "The poodle woofs elegantly!"

let persian = Persian(isTame: true, legs: 3)
persian.speak() // "The Persian purrs gently."

let lion = Lion(isTame: false, legs: 2)
lion.speak() // "The lion roars fiercely!"
