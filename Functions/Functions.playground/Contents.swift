import Cocoa
// MARK: - Code Reusability With Functions

// Functions let you reuse code by giving it a name and calling it whenever you want.
func showWelcome() {
    print("Welcome to my app!")
    print("By default this prints out a conversion")
    print("chart from centimeters to inches, but you")
    print("can also set a custom range if you want.")
}

// Calling the function
showWelcome()

// MARK: Why Use Functions?

// Reusability: If you want to print the same welcome message in multiple places,
// defining it once in a function avoids duplication and makes maintenance easier.

// MARK: Passing Data Into Functions (Parameters)

// We can make our functions accept values, so they're more flexible.
func printTimesTables(number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}

// Calling it with an argument
printTimesTables(number: 5)

// MARK: Multiple Parameters

// Functions can accept multiple parameters for even more customization.
func timesTablesPrint(number: Int, end: Int) {
    for i in 1...end {
        print("\(i) x \(number) is \(i * number)")
    }
}

timesTablesPrint(number: 5, end: 20)

// MARK: Parameters vs Arguments

// In this function:
func printTimesTables(number: Int, end: Int) {
    // `number` and `end` are called parameters – placeholders for values the function will receive
}

// When calling it like this:
printTimesTables(number: 8, end: 12)
// 8 and 12 are arguments – the actual values being passed in


// MARK: Parameters vs Arguments in Swift

//: ## Do the terms *parameter* and *argument* actually matter?
//: Not really — at least, not in everyday coding

//: ### The official definitions:
/// - A **parameter** is the *placeholder* in a function definition.
/// - An **argument** is the *actual value* you pass into the function when calling it.

func greet(name: String) { // ← 'name' is a **parameter**
    print("Hello, \(name)!")
}

greet(name: "Turing") // ← "Turing" is an **argument**

//: ### In practice:
/// - Most developers use these terms *interchangeably*.
/// - Swift’s named arguments make things so clear that the distinction rarely matters.
/// - Even Apple’s documentation is relaxed about it.

//: ### Rule of thumb:
/// - Parameter = Placeholder
/// - Argument = Actual value
/// - Just remember: **Parameter/Placeholder**, **Argument/Actual**


//: ### Final word:
/// Use “parameter” for both if that’s easiest.
/// No one will be confused, and Swift won’t complain!


// MARK:  Parameter Order Matters

// This is invalid and causes a compile error:
// printTimesTables(end: 20, number: 5)

// Swift requires arguments to be passed in the exact order they are defined in the function signature.

// MARK: Extra: Built-in Function Examples

let roll = Int.random(in: 1...20) // random(in:) is a function with a parameter
print("You rolled a \(roll)")

let number = 139
if number.isMultiple(of: 2) {
    print("Even")
} else {
    print("Odd")
}

// MARK: Tip

// Variables created inside a function (including parameters) are destroyed as soon as the function ends.

// MARK: - Functions Return Values

/// Swift has many built-in functions that return values. For example:
let root = sqrt(169)
print(root)
//: `sqrt()` accepts a number and returns its square root.

//: ### Creating Your Own Return Functions

/// To return a value from a function:
/// 1. Add `-> Type` to the function signature.
/// 2. Use the `return` keyword to send the result back.

func rollDice() -> Int {
    Int.random(in: 1...6)
}

let result = rollDice()
print(result)

//: By centralizing dice logic, we can easily update behavior across your app by changing just one place.

/// - Important: Swift requires that a function **must** return a value if its signature says it will.

//: ### A More Complex Example: Letter Comparison

/// This function checks whether two strings contain the same letters, regardless of order, by sorting and comparing them.
/// - Note: The `return` keyword can be omitted for single-expression functions.
func areLettersIdentical(string1: String, string2: String) -> Bool {
    string1.sorted() == string2.sorted()
}

areLettersIdentical(string1: "abc", string2: "cab")  // true
areLettersIdentical(string1: "abc", string2: "def")  // false

/// This function uses a hash table (dictionary) to check whether two strings contain the same letters, regardless of order.
/// - Note: The `return` keyword cannot be omitted here due to the function's structure.
func areLettersIdenticalHashed(string1: String, string2: String) -> Bool {
    // Early exit if lengths differ
    guard string1.count == string2.count else { return false }
    
    func charFrequency(_ str: String) -> [Character: Int] {
        var freq: [Character: Int] = [:]
        for char in str {
            freq[char, default: 0] += 1
        }
        return freq
    }
    
    return charFrequency(string1) == charFrequency(string2)
}

areLettersIdenticalHashed(string1: "abc", string2: "cab")  // true
areLettersIdenticalHashed(string1: "abc", string2: "def")  // false


//: ### Pythagorean Theorem Example

/// This function calculates the hypotenuse of a right triangle.
func pythagoras(a: Double, b: Double) -> Double {
    sqrt(a * a + b * b)
}

let hypotenuse = pythagoras(a: 3, b: 4)
print(hypotenuse)  // 5.0


//: ## Returning Early

/// If a function returns `Void`, you can still use `return` by itself to exit early.
func checkPassword(_ input: String) {
    if input != "OpenSesame" {
        print("Access denied.")
        return
    }
    
    print("Welcome!")
}

checkPassword("1234")
checkPassword("OpenSesame")

// MARK: - Returning Multiple Values from Functions

//: When returning a **single value**, write an arrow and the data type before the function’s brace:

func isUppercase(string: String) -> Bool {
    string == string.uppercased()
}

isUppercase(string: "HELLO")  // true
isUppercase(string: "Hello")  // false

//: This compares the input string to its uppercase version and returns true if they are the same.

//: ### Returning Multiple Values — The Challenge

//: You can return multiple values as an **array**:

func getUser() -> [String] {
    ["Taylor", "Swift"]
}

let user = getUser()
print("Name: \(user[0]) \(user[1])")
//: But `user[0]` and `user[1]` are hard to remember and error-prone.

//: Using a **dictionary** might help by naming values:

func getUserDict() -> [String: String] {
    [
        "firstName": "Taylor",
        "lastName": "Swift"
    ]
}

let userDict = getUserDict()
print("Name: \(userDict["firstName", default: "Anonymous"]) \(userDict["lastName", default: "Anonymous"])")
//: However, dictionaries require default values because Swift can't guarantee keys exist.

//: ### The Swift Solution: Tuples

//: Tuples store multiple values with fixed size and can have different types:

func getUserTuple() -> (firstName: String, lastName: String) {
    (firstName: "Taylor", lastName: "Swift")
}

let userTuple = getUserTuple()
print("Name: \(userTuple.firstName) \(userTuple.lastName)")

//: Breakdown:
//: - The return type is a tuple with named elements `(firstName: String, lastName: String)`
//: - The function returns values assigned to those names.
//: - Access tuple values using dot syntax: `userTuple.firstName`

//: Tuples are safer than dictionaries because:
//: - Swift guarantees tuple elements exist and have fixed types.
//: - Dot syntax avoids typos unlike dictionary keys.
//: - Tuples have fixed size and can't have missing or extra values.


//: ### More Tuple Tips

//: 1. You can omit names when returning if they're already declared in the function signature:

func getUserTupleShort() -> (firstName: String, lastName: String) {
    ("Taylor", "Swift")
}

//: 2. Sometimes tuples don't have names; you can access by index:

func getUserUnnamed() -> (String, String) {
    ("Taylor", "Swift")
}

let unnamedUser = getUserUnnamed()
print("Name: \(unnamedUser.0) \(unnamedUser.1)")

//: 3. You can destructure tuples into separate constants:

let (firstName, lastName) = getUserTuple()
print("Name: \(firstName) \(lastName)")

//: 4. If you only need some values, ignore others with `_`:

let (justFirstName, _) = getUserTuple()
print("Name: \(justFirstName)")

// MARK: - Customizing Parameter Names

//: Swift encourages naming parameters for clarity when calling functions.

func rollDice(sides: Int, count: Int) -> [Int] {
    var rolls = [Int]()
    for _ in 1...count {
        rolls.append(Int.random(in: 1...sides))
    }
    return rolls
}

let rolls = rollDice(sides: 6, count: 4)
//: Easy to understand: we're rolling a 6-sided dice 4 times.


//: ### Overloaded Functions

//: Swift uses parameter names to distinguish between overloaded functions:

func hireEmployee(name: String) { }
func hireEmployee(title: String) { }
func hireEmployee(location: String) { }

//: These are all valid — Swift matches them by external parameter name.
//: For clarity, docs refer to them like `hireEmployee(name:)`, `hireEmployee(title:)`, etc.


//: ## Omitting External Parameter Names

//: Some functions don’t need external names for clarity. For example:

func isUppercase(_ string: String) -> Bool {
    string == string.uppercased()
}

let results = isUppercase("HELLO, WORLD")  // Clean and clear

//: Using `_` removes the external label. Many Swift functions do this:
//: - `array.append("value")`
//: - `array.contains("value")`


//: ## Using Custom External Names

//: Sometimes we want to improve readability at the call site.
//: Consider this function:

func printTimesTabless(number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTabless(number: 5)  // Clunky to read aloud

//: A better version for readability:

func printTimesTables(for number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(for: 5)  // "print times tables for 5" — very natural

//: Explanation:
//: - `for` is the external name used at the call site.
//: - `number` is the internal name used inside the function.

//: MARK: Summary

//: Swift gives you **two key tools** to improve function clarity:
//: 1. Use `_` to omit external parameter names.
//: 2. Use `externalName internalName:` to separate call-site and internal usage.

// MARK: - Provide Default Values to Parameters

//: ## Default Parameter Values

//: Functions can have parameters with default values, so you don’t have to provide them every time you call the function.

//: This keeps the function calls simple when defaults work, but still allows customization when needed.

func printTimesTables(for number: Int, end: Int = 12) {
    for i in 1...end {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(for: 5, end: 20)  //  Prints times table up to 20
printTimesTables(for: 8)            // Uses default end = 12


//: ### Example: Array's removeAll(keepingCapacity:)

//: Swift standard library uses default parameters too:

var characters = ["Lana", "Pam", "Ray", "Sterling"]
print(characters.count)  // 4

characters.removeAll()   // Removes all and frees memory
print(characters.count)  // 0

//: But sometimes you want to keep the capacity to add new items efficiently:

characters = ["Lana", "Pam", "Ray", "Sterling"]
characters.removeAll(keepingCapacity: true)  // Keeps capacity
print(characters.count)  // 0

//: Default parameters give you flexibility without complicating the common use cases.

// MARK: - Error Handling

//: ## Error Handling in Swift

//: Things can go wrong, so Swift makes us handle errors explicitly to avoid crashes.

//: ## A three step guide on how to handle errors

//: ### Step 1: Define possible errors using an enum conforming to Error

enum PasswordError: Error {
    case short, obvious
}

//: ### Step 2: Write a throwing function

func checkPasswordStr(_ password: String) throws -> String {
    if password.count < 5 {
        throw PasswordError.short
    }
    if password == "12345" {
        throw PasswordError.obvious
    }
    if password.count < 8 {
        return "OK"
    } else if password.count < 10 {
        return "Good"
    } else {
        return "Excellent"
    }
}

//: ### Step 3: Call the function and handle errors

let testPassword = "12345"

do {
    let rating = try checkPasswordStr(testPassword)
    print("Password rating: \(rating)")
} catch PasswordError.short {
    print("Password is too short. Please use a longer one.")
} catch PasswordError.obvious {
    print("That password is too obvious!")
} catch {
    print("An unknown error occurred: \(error.localizedDescription)")
}

//: ## Understanding error.localizedDescription

//: When you catch an error in Swift, you get an error constant representing what went wrong.

//: error.localizedDescription provides a human-readable, user-friendly message describing the error.

//: This message is usually created by the system or framework that threw the error, making it helpful for debugging or showing to users.

//: It’s “localized” because it can be translated to different languages depending on the user’s settings.

//: Here’s how it’s used:

do {
    throw NSError(domain: "ExampleError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Something bad happened!"])
} catch {
    print("An unknown error occurred: (error.localizedDescription)")
}

//: This prints a clear message instead of just a generic error.

//: ## Key Points:
//: - Mark functions with `throws` to indicate they can throw errors.
//: - Use `throw` to signal an error and exit the function.
//: - Call throwing functions with `try` inside a `do` block.
//: - Use `catch` blocks to handle errors, either generally or specifically.
//: - `try!` can be used to skip error handling but will crash if an error is thrown — must be used very carefully.

// MARK: - Checkpoint 4

/*
 Write a function that accepts an integer from 1 through 10,000, and returns the integer square root of that number.
 - Accept an integer between 1 and 10,000.
 - Return the **integer square root** (e.g., √25 = 5).
 - Throw errors for:
   - Numbers out of bounds.
   - Numbers that don’t have an integer square root.
 */


enum squareRootBoundaryError: Error {
    case outOfBound, noRoot
}


func checkSquareRootBoundary(_ number:Int) throws{
    guard number >= 1 && number <= 10_000 else{
        throw squareRootBoundaryError.outOfBound
    }
}


func findSquareRoot(of number: Int = 1) throws -> Int{
    try checkSquareRootBoundary(number)
    var i = 1
    while (i * i <= number){
        if i * i == number{
            return i
        }
        
        i += 1
    }
    throw squareRootBoundaryError.noRoot
}

// MARK: Testing
let testNumbers = [0, 1001, 25, 3, 10_001]

for num in testNumbers {
    do {
        let result = try findSquareRoot(of: num)
        print("Square root of \(num): \(result)")
        
    } catch squareRootBoundaryError.outOfBound {
        print("\(num) is out of bounds")
        
    } catch squareRootBoundaryError.noRoot {
        print("\(num) does not have an integer square root")
        
    } catch {
        print("Unknown error for \(num): \(error)")
    }
}
