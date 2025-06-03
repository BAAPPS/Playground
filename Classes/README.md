# Summary

## Day 12 – Classes, Inheritance, and Checkpoint 7

---

### 🧠 Classes vs Structs in Swift

Swift uses `struct`s for most core data types like `String`, `Int`, `Double`, and `Array`, but you can also define your own data types using `class`. This section explores the key differences between structs and classes in Swift.

#### ✅ What structs and classes have in common:

* You can define properties and methods.
* You can use access control and property observers.
* You can write custom initializers.

#### 🔍 Key differences with classes:

1. **Inheritance:** Classes can inherit from other classes.
2. **No memberwise initializer:** You must write your own initializers or provide default values.
3. **Reference types:** Copies of a class share the same instance.
4. **Deinitializers:** Classes can define a `deinit` to run when the last reference is destroyed.
5. **Mutability:** A `let` class instance can still have its `var` properties changed.

### 🛠 Why classes matter:

* In **SwiftUI**, classes are often used to model shared state.
* Reference semantics are useful when multiple views or components need to access and update the same data.

---

#### ✅ Class Example

```swift
class Game {
    var score = 0 {
        didSet {
            print("Score is now \(score)")
        }
    }
}

var gameA = Game()
var gameB = gameA

gameB.score += 10 // Affects both gameA and gameB
print("Game A Score: \(gameA.score)") // 10
print("Game B Score: \(gameB.score)") // 10
```

---

#### 🔁 Equivalent Struct Example

```swift
struct GameStruct {
    var score = 0 {
        didSet {
            print("Score is now \(score)")
        }
    }
}

var gameX = GameStruct()
var gameY = gameX

gameY.score += 10 // Only affects gameY
print("Game X Score: \(gameX.score)") // 0
print("Game Y Score: \(gameY.score)") // 10
```

- This demonstrates the key difference: **structs are value types** (copied), while **classes are reference types** (shared).

---

### Class Inheritance 

- Swift supports **inheritance**, allowing you to create a new class (called a *subclass* or *child*) that builds on an existing class (the *superclass* or *parent*).

- The subclass inherits properties and methods from its parent, so you can reuse code and customize behavior without repetition.

#### How to Inherit

Use a colon (`:`) after the subclass name followed by the parent class name:

```swift
class ChildClass: ParentClass { }
````

#### Example

```swift
class Employee {
    let hours: Int

    init(hours: Int) {
        self.hours = hours
    }

    func printSummary() {
        print("I work \(hours) hours a day.")
    }
}

class Developer: Employee {
    func work() {
        print("I'm writing code for \(hours) hours.")
    }

    override func printSummary() {
        print("I'm a developer who sometimes works \(hours) hours but often debates tabs vs. spaces.")
    }
}

class Manager: Employee {
    func work() {
        print("I'm going to meetings for \(hours) hours.")
    }
}
```

#### Key Points

* **Subclasses inherit** all properties and methods from their superclass.

* To **customize or change inherited methods**, use the `override` keyword.

* Swift enforces override rules:

  * You **must** use `override` when changing a parent method.
  
  * If you use `override` incorrectly, the compiler will generate an error.
  
* Adding methods with different parameters does **not** require `override`.

* Mark a class as `final` to **prevent other classes from inheriting it**.

#### Usage Example

```swift
let robert = Developer(hours: 8)
let joseph = Manager(hours: 10)

robert.work()          // I'm writing code for 8 hours.
joseph.work()          // I'm going to meetings for 10 hours.

robert.printSummary()  // Custom summary from Developer class
joseph.printSummary()  // Default summary from Employee class
```

---

### Swift Class Initializers and Inheritance

- Class initializers in Swift are more complex than struct initializers, especially when inheritance is involved. 

- Understanding how to properly initialize classes and subclasses is essential to writing correct and safe Swift code.

#### Key Concepts

- Swift **does not** automatically generate memberwise initializers for classes, unlike structs.

- If a subclass defines its own initializer, it **must** call its parent class’s initializer using `super.init` **after** initializing its own properties.

- If a subclass does **not** define any initializers, it automatically inherits all of its parent’s initializers.


#### Parent Class Initialization

- A class must initialize all of its stored properties before completing initialization. 

- Here is an example of a simple `Vehicle` class with one property and an initializer:

```swift
class Vehicle {
    let isElectric: Bool

    init(isElectric: Bool) {
        self.isElectric = isElectric
    }
}
````

* The initializer takes a parameter `isElectric` and assigns it to the property.

* Using `self.isElectric` clarifies that you are setting the property, not the parameter.


#### Subclass Initialization and Inheritance

Suppose you want to create a subclass `Car` that inherits from `Vehicle` and adds a new property `isConvertible`:

```swift
class Car: Vehicle {
    let isConvertible: Bool

    init(isConvertible: Bool) {
        self.isConvertible = isConvertible
    }
}
```

This will cause a **compile-time error** because the parent class `Vehicle` requires its `isElectric` property to be initialized, but `Car`’s initializer does not call `super.init(isElectric:)` to satisfy that requirement.


#### Correct Subclass Initializer

To fix this, you need to:

1. Accept parameters for **both** the parent and subclass properties.
2. Initialize subclass properties first.
3. Call the superclass initializer with the appropriate parameters using `super.init(...)`.

Here’s the correct way:

```swift
class Car: Vehicle {
    let isConvertible: Bool

    init(isElectric: Bool, isConvertible: Bool) {
        self.isConvertible = isConvertible       // Initialize own property first
        super.init(isElectric: isElectric)       // Then call parent initializer
    }
}
```

* `super` is a special keyword that refers to the parent class.

* Calling `super.init(...)` ensures the parent class initializes its properties correctly.


#### Creating Instances

Now you can create instances of `Car` like this:

```swift
let teslaX = Car(isElectric: true, isConvertible: false)
```

* The initializer sets both `isElectric` and `isConvertible` properly.

---

#### Important Notes

* If a **subclass does not declare any custom initializers**, it **inherits all initializers** from its parent class automatically.

* If you add any initializer to a subclass, you must ensure that all properties (both inherited and new) are initialized correctly.

* Failing to call the superclass initializer in a subclass initializer will cause a build error.

* You can also call other methods on `super` to invoke behavior defined in the parent class.

---

### Understanding Reference Types and Value Types in Swift

- In Swift, **classes** and **structs** behave differently when you create copies of them. 

- This difference is fundamental and affects how data is shared or duplicated in your programs.

#### Classes Are **Reference** Types

- When you copy a class instance, **all copies share the same underlying data**. 

- This means that if you modify one instance, the change is visible in all other references to that same instance.

#### Example:

```swift
class User {
    var username = "Anonymous"
}

var user1 = User()
var user2 = user1         // user2 references the same instance as user1
user2.username = "Taylor" // Change username via user2

print(user1.username)     // Prints "Taylor"
print(user2.username)     // Prints "Taylor"
````

- Even though we only changed the `username` via `user2`, `user1` shows the updated value because **both variables point to the same object** in memory.

- This shared behavior is called **reference semantics**. 

- It allows different parts of your program to access and modify the same shared data, which is essential for many programming tasks, such as managing shared state in apps.


#### Structs Are **Value** Types

- In contrast, **structs are value types** in Swift. 

- When you assign or pass a struct, Swift **copies the data** instead of sharing it. This means each copy is completely independent.

#### Example:

```swift
struct UserStruct {
    var username = "Anonymous"
}

var structUser1 = UserStruct()
var structUser2 = structUser1 // This creates a new, independent copy
structUser2.username = "Taylor"

print(structUser1.username) // Prints "Anonymous"
print(structUser2.username) // Prints "Taylor"
```

Because `structUser2` is a separate copy, changing it doesn’t affect `structUser1`.


#### Creating Independent Copies of Class Instances (Deep Copy)

- Sometimes, you want to create a new instance of a class that has the same data as the original but doesn’t share the same reference — a **deep copy**.

- Swift doesn’t provide automatic deep copying for classes, so you need to implement it manually:

```swift
class User {
    var username = "Anonymous"

    func copy() -> User {
        let newUser = User()
        newUser.username = username
        return newUser
    }
}
```

Now you can create an independent copy:

```swift
var user1 = User()
var user3 = user1.copy()
user3.username = "Alex"

print(user1.username) // Prints "Anonymous" — original is unchanged
print(user3.username) // Prints "Alex" — copy is independent
```


#### Why It Matters

* Reference types enable **shared mutable state** across your app.

* Value types provide **safe copies** that prevent unintended side effects.

* Knowing when to use classes vs structs — and how to manage copying — is key to writing safe, predictable Swift code.


- This understanding is especially important in SwiftUI and other frameworks, where data flow and state management rely heavily on how types are copied and shared.

---


### Understanding Deinitializers and Object Lifecycle in Swift Classes

- In Swift, classes can define a special method called a **deinitializer** (`deinit`) that is called automatically just before an instance of the class is destroyed. 

- Deinitializers are essentially the opposite of initializers — while initializers set up an object when it is created, deinitializers clean up just before the object’s memory is reclaimed.


#### What Is a Deinitializer?

- A **deinitializer** is a special method in a Swift class that runs when the last reference to an instance is removed and the instance is about to be deallocated.

- Unlike initializers, deinitializers:

  - Do **not** use the `func` keyword.
  
  - Do **not** take parameters or return values.
  
  - Are written without parentheses.
  
- You **never call a deinitializer manually**; Swift automatically calls it at the appropriate time.

#### Syntax Example

```swift
class User {
    let id: Int

    init(id: Int) {
        self.id = id
        print("User \(id): I'm alive!")
    }

    deinit {
        print("User \(id): I'm dead!")
    }
}
````

#### When Are Deinitializers Called?

- Deinitializers run when the **final strong reference** to a class instance disappears. 

- This can depend on the **scope** where the instance was created:

* **Scope** is the context or region in your code where a variable or constant is valid and accessible.

* Examples of scope include:

  * Inside a function
  
  * Inside a loop or conditional block
  
  * Inside a class or struct
  
* When a variable or constant goes out of scope, if it was the last strong reference to a class instance, Swift will destroy that instance and call its deinitializer.

#### Demonstration of Scope Impact on Deinitialization

```swift
for i in 1...3 {
    let user = User(id: i)
    print("User \(user.id): I'm in control!")
}
// Each 'user' instance is destroyed as soon as its loop iteration finishes
```

In the above example, each `User` instance is created inside the loop and destroyed when the loop iteration ends — because `user` goes out of scope, triggering `deinit`.


#### Keeping Instances Alive: Strong References

Sometimes, class instances are kept alive longer because there are still strong references pointing to them elsewhere, such as in arrays or other collections.

#### Example:

```swift
var users = [User]()

for i in 1...3 {
    let user = User(id: i)
    print("User \(user.id): I'm in control!")
    users.append(user)  // Store strong reference in array
}

print("Loop is finished!")

// User instances are NOT destroyed here because 'users' still holds references

users.removeAll()  // Removing all references triggers deinitialization

print("Array is clear!")
```

In this example:

* The `User` instances live beyond the loop because the `users` array holds strong references to them.

* The `deinit` method is called only after we remove all references by clearing the array.

* This shows how reference counting works in Swift — an instance lives as long as there is at least one strong reference to it.

#### Important Notes

* **Structs and enums do not have deinitializers** because they are value types and copied, not reference counted.

* Deinitializers are useful for:

  * Cleaning up resources like closing files or network connections.
  
  * Logging or debugging lifecycle events.
  
* Proper understanding of scope and strong references is crucial to managing memory and avoiding leaks or unexpected behavior in Swift apps.

---

### 📘 Understanding Class References and Property Mutability in Swift

Swift’s `class` types behave like **signposts**: every variable or constant holding a class instance is actually a *reference* to the same underlying object in memory. This has major implications for how data is shared and mutated across your codebase.

---

#### # 🔁 Class References Are Shared

```swift
class User {
    var name = "Paul"
}

let user1 = User()
user1.name = "Taylor"
```

Although `user1` is declared with `let`, we are able to change the `name` property. This is because `user1` is a **constant reference** to the `User` instance. The instance itself hasn’t changed – we’ve just modified the data **it points to**.

#### 🧠 Think of it like this:

* The `let` makes the *reference* (signpost) constant.
* The object it points to can still be modified – *unless* its internal properties are declared `let`.


#### 🧪 Four Combinations of Mutability

| Instance (`let`/`var`) | Property (`let`/`var`) | Can Reassign Instance? | Can Modify Property? |
| ---------------------- | ---------------------- | ---------------------- | -------------------- |
| `let`                  | `let`                  | ❌                     | ❌                   |
| `let`                  | `var`                  | ❌                     | ✅                   |
| `var`                  | `let`                  | ✅                     | ❌                   |
| `var`                  | `var`                  | ✅                     | ✅                   |

#### Examples:

```swift
class User {
    var name = "Paul"
}

let user1 = User()      // Case 2: const instance, var property ✅
user1.name = "Taylor"   // Valid

var user2 = User()      // Case 4: var instance, var property ✅
user2.name = "Steve"
user2 = User()          // Also valid: reassigning instance
```


#### Shared Reference: One Change Affects All

```swift
var original = User()
var copy = original

copy.name = "Updated"

print(original.name) // Output: "Updated"
print(copy.name)     // Output: "Updated"
```

- Both `original` and `copy` point to the same memory. Changing one updates the other.

- This can be useful (e.g. shared model data), but also risky if you expect values to stay independent.


#### Structs Work Differently

Unlike classes, structs are **value types**. This means:

* Each copy is **independent**.

* A constant struct instance cannot have its properties changed, even if they’re declared with `var`.

```swift
struct StructUser {
    var name = "Paul"
}

let structUser = StructUser()
// structUser.name = "Taylor" ❌ Compile error
```

This is because modifying a property of a struct implies modifying the entire instance, which isn’t allowed when the instance is a constant.


#### Class Methods Don’t Need `mutating`

Because class instances can always mutate their variable properties (as long as the property is `var`), you don’t need to use the `mutating` keyword:

```swift
class Account {
    var balance = 100
    
    func deposit(amount: Int) {
        balance += amount
    }
}

let account = Account()
account.deposit(amount: 50)
```

In contrast, struct methods **must** be marked `mutating` if they change any properties:

```swift
struct Wallet {
    var balance = 0

    mutating func addCash(_ amount: Int) {
        balance += amount
    }
}
```

#### 🚧 Why All This Matters

* Swift’s class mutability rules enable **flexibility**, but also introduce **shared mutable state**.

* Knowing whether an object is a **class (reference type)** or a **struct (value type)** helps prevent unintended side effects.

* Use `let` for both references and properties wherever possible to **protect against unintentional changes**.


### ✅ Best Practices

* Use `struct` when your data is simple and doesn’t need to be shared.

* Use `class` when you need shared state, inheritance, or identity semantics.

* Default to immutable (`let`) references and properties unless you explicitly need mutation.

---

### 🧠 Checkpoint 7: Class Hierarchies, Initializers, and Method Overriding in Swift

#### ✅ Objective

Build a class hierarchy for animals that demonstrates:

* Inheritance
* Initializers (including with default values)
* Method overriding
* Access to superclass properties
* Use of reference types and default values for streamlined object creation

---

#### Class Structure

We’re creating a structured class hierarchy:

```
Animal
├── Dog
│   ├── Corgi
│   └── Poodle
└── Cat
    ├── Persian
    └── Lion
```

#### 1. `Animal`: The Base Class

The `Animal` class contains a single property:

```swift
class Animal {
    var legs: Int

    init(legs: Int = 4) {
        self.legs = legs
    }
}
```

* `legs` has a **default value of 4**, since most animals in our hierarchy will have 4 legs.

* This lets subclasses inherit 4 legs by default unless otherwise specified.

---

#### 2. `Dog` and Subclasses

All dogs inherit from `Animal` and override a `speak()` method:

```swift
class Dog: Animal {
    func speak() {
        print("The dog barks.")
    }
}
```

###### 🐾 `Corgi`

```swift
class Corgi: Dog {
    override func speak() {
        print("The corgi yaps excitedly!")
    }
}
```

##### 🐾 `Poodle`

```swift
class Poodle: Dog {
    override func speak() {
        print("The poodle yips with elegance!")
    }
}
```

---

#### 3. `Cat` and Subclasses

Cats include a new property, `isTame`, and also override the `speak()` method.

```swift
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
```

###### 🐾 `Persian`

```swift
class Persian: Cat {
    override func speak() {
        print("The Persian cat purrs gently.")
    }
}
```

###### 🐾 `Lion`

```swift
class Lion: Cat {
    override func speak() {
        print("The lion roars fiercely!")
    }
}
```

#### 🧪 Sample Usage

```swift
let corgi = Corgi()
corgi.speak()  // The corgi yaps excitedly!
print("Corgi legs: \(corgi.legs)") // 4

let poodle = Poodle()
poodle.speak() // The poodle yips with elegance!

let persian = Persian(isTame: true)
persian.speak() // The Persian cat purrs gently.

let lion = Lion(isTame: false)
lion.speak() // The lion roars fiercely!
```

We can also override the number of legs only when needed:

```swift
let injuredLion = Lion(isTame: false, legs: 3)
print("Injured lion legs: \(injuredLion.legs)") // 3
```

### 🧠 Key Concepts Reinforced

* **Class inheritance** lets us define shared behavior in a superclass and customize it in subclasses.

* **Default property values** simplify subclass implementation and object instantiation.

* **Method overriding** allows each subclass to implement specialized behavior (`speak()`).

* **Initializer chaining** ensures each class sets up its own properties before calling `super.init()`.

* **Reference types** mean object data is shared and mutable — you can override just the needed parts (like `legs`).

