import Cocoa

// MARK: - Closures & Function Types Summary

/*
 A closure is a self-contained block of code that you can assign to a variable or constant, pass into a function, or return from a function.
 It captures and stores references to variables and constants from the surrounding context, hence the name closure.
 */


/*
 Swift functions can be:
 - Assigned to variables/constants
 - Passed into other functions
 - Returned from functions
 */

// Example:
func greetUser() {
    print("Hi there!")
}

var greetCopy = greetUser  // Copying the function (no parentheses!)
greetCopy()                // Calls greetUser

// Closures: Anonymous chunks of code stored in variables/constants
let sayHello = {
    print("Hi there from closure!")
}
sayHello()

/*
 Closures can take parameters and return values
 - Use `(params) -> ReturnType in` inside the closure
 */
let personalizedGreeting = { (name: String) -> String in
    "Hello, \(name)!"
}
print(personalizedGreeting("Taylor"))  // "Hello, Taylor!"

/*
 Functions and closures have types, e.g.:
 - () -> Void (takes nothing, returns nothing)
 - (Int) -> String (takes Int, returns String)
 */
func getUserData(for id: Int) -> String {
    return id == 1989 ? "Taylor Swift" : "Anonymous"
}

// Type annotation
let data: (Int) -> String = getUserData
print(data(1989))  // "Taylor Swift" — notice no external label

/*
 Functions as arguments — example using `sorted(by:)`
 - `sorted()` takes a closure to define custom sorting
 
 As long as that function:
 - accepts two strings
 - returns a Boolean
 */
let team = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]

// Named function version
func captainFirstSorted(name1: String, name2: String) -> Bool {
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }
    return name1 < name2
}
let sortedTeam1 = team.sorted(by: captainFirstSorted)
print(sortedTeam1)

// Closure version (no separate function needed)
let sortedTeam2 = team.sorted(by: { (name1: String, name2: String) -> Bool in
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }
    return name1 < name2
})
print(sortedTeam2)


// MARK: - Trailing Closures and Shorthand Syntax


// MARK: 1. Full closure syntax

// You can pass a full closure to the `sorted(by:)` method.
// This closure takes two Strings and returns a Bool.
let captainFirstTeam1 = team.sorted(by: { (name1: String, name2: String) -> Bool in
    if name1 == "Suzanne" {
        return true // Suzanne comes first
    } else if name2 == "Suzanne" {
        return false
    }
    return name1 < name2 // fallback to alphabetical order
})

print("Full syntax:", captainFirstTeam1)


// MARK: 2. Type Inference

// Swift already knows we're working with [String], so we can remove types:
let captainFirstTeam2 = team.sorted(by: { name1, name2 in
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }
    return name1 < name2
})

print("Type inference:", captainFirstTeam2)


// MARK: 3. Trailing Closure Syntax

// If the closure is the last (or only) argument, you can move it outside:
let captainFirstTeam3 = team.sorted {
    if $0 == "Suzanne" {
        return true
    } else if $1 == "Suzanne" {
        return false
    }
    return $0 < $1
}

print("Trailing syntax:", captainFirstTeam3)


// MARK: 4. Shorthand Argument Names

// When your closure is short, use $0, $1 instead of naming parameters.
let reverseTeam = team.sorted { $0 > $1 }
print("Reverse sorted team:", reverseTeam)


// MARK: Guidelines for Using Shorthand Syntax

//: ### Good when:
/// - Closure is small
/// - You use each parameter only once
/// - There are 2 or fewer parameters

//:  ### Not ideal when:
/// - Closure is long
/// - You reuse parameters multiple times
/// - You have 3+ parameters (e.g., $2, $3… gets messy)


// MARK: 5. Other useful methods using closures

/// filter: keeps only elements that match a condition
let tOnly = team.filter { $0.hasPrefix("T") }
print("Names starting with T:", tOnly)

/// map: transforms each item into a new value
let uppercaseTeam = team.map { $0.uppercased() }
print("Uppercased team:", uppercaseTeam)


// MARK: 6. Reminder: `in` separates parameters from body

//: ### The `in` keyword is used in closures to separate:
/// - the input parameters
/// - from the actual logic (the body)

/// Example:
let example = team.sorted { name1, name2 in
    return name1.count < name2.count // sort by length of name
}
print("Sorted by name length:", example)


// MARK: 7. Why Closures Matter
//: ### You'll use closures all the time in SwiftUI:
/// - to build lists from data
/// - to define button actions
/// - to configure UI layout

// Example
/*
 (imaginary SwiftUI):
 Button("Tap Me") {
 print("Button was tapped")
 }
 */

// MARK: - Functions as Parameters in Swift

// A simple function to greet the user
func greetUsers() {
    print("Hi there!")
}

// Assigning function to a variable (Type Annotation)
var greetCopies: () -> Void = greetUsers
greetCopies()

// MARK: - Accepting a Function as a Parameter

// This function takes another function as a parameter to generate Ints
func makeArray(size: Int, using generator: () -> Int) -> [Int] {
    var numbers = [Int]()
    
    for _ in 0..<size {
        let newNumber = generator()
        numbers.append(newNumber)
    }
    
    return numbers
}

// Using a trailing closure to pass a generator function
let rolls = makeArray(size: 10) {
    Int.random(in: 1...20)
}

print("Random Rolls:", rolls)

// MARK: - Using a Named Function Instead of a Closure

func generateNumber() -> Int {
    Int.random(in: 1...20)
}

let newRolls = makeArray(size: 10, using: generateNumber)
print("Generated Rolls:", newRolls)

// MARK: - Multiple Function Parameters with Trailing Closures

// A function accepting three closure parameters
func doImportantWork(first: () -> Void, second: () -> Void, third: () -> Void) {
    print("Starting important work...")
    
    print("Step 1:")
    first()
    
    print("Step 2:")
    second()
    
    print("Step 3:")
    third()
    
    print("All work done!")
}

// Using multiple trailing closures
doImportantWork {
    print("Doing first task")
} second: {
    print("Doing second task")
} third: {
    print("Doing third task")
}

// MARK: - Checkpoint 5

/*
 In this challenge, we take an array of numbers and perform a chain of operations using closures:
 
 1. Filter out all even numbers, keeping only the odd ones.
 2. Sort the remaining numbers in ascending order.
 3. Map each number to a formatted string saying "<number> is a lucky number".
 4. Finally, print each formatted string on its own line.
 
 This demonstrates how to combine filter(), sorted(), and map() into a clean, readable pipeline without using temporary variables. The forEach() method is used separately to print the results because it returns Void, not an array.
 
 This approach leverages the power and expressiveness of Swift closures to manipulate collections concisely and clearly.
 */


let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 31, 49]

let oddLuckyNumbers = luckyNumbers
    .filter { $0 % 2 != 0 }     // Keep only odd numbers
    .sorted()                   // Sort ascending
    .map { "\($0) is a lucky number" }  // Convert to formatted string


oddLuckyNumbers.forEach { print($0) }     // Print each string on its own line

/*
 7 is a lucky number
 15 is a lucky number
 21 is a lucky number
 31 is a lucky number
 33 is a lucky number
 49 is a lucky number
 */
