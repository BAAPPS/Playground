import Cocoa

// MARK: - Handle Missing Data With Optionals

// MARK:  1. Optional Basics

// A dictionary of opposites
let opposites = [
    "Mario": "Wario",
    "Luigi": "Waluigi"
]

// Accessing a key that doesn’t exist returns an Optional
let peachOpposite = opposites["Peach"]
print("Peach's opposite: \(String(describing: peachOpposite))") // nil

// This means the value is a String? — could be a String or could be nil
// Optionals allow Swift to represent the *absence* of data safely

// MARK: 2. Unwrapping Optionals with `if let`

if let marioOpposite = opposites["Mario"] {
    print("Mario's opposite is \(marioOpposite)")
}

// MARK: 3. Unwrapping Optionals with `else`

var username: String? = nil

if let unwrappedName = username {
    print("We got a user: \(unwrappedName)")
} else {
    print("The optional was empty.")
}

// MARK: 4. Optional vs Non-Optional

let definiteInt: Int = 0             // Non-optional: always contains a value
let optionalInt: Int? = nil          // Optional: may contain nothing (nil)

let emptyString: String = ""         // Valid string, just empty
let optionalString: String? = nil    // Optional: nothing at all

let emptyArray: [Int] = []           // Valid, just contains no elements
let optionalArray: [Int]? = nil      // Optional: may not even exist

// MARK: 5. Function with Non-Optional Parameter

func square(number: Int) -> Int {
    number * number
}

var optionalNumber: Int? = nil
// print(square(number: optionalNumber)) ❌ Compile Error

// MARK: 6. Safe Unwrapping for Function Use

optionalNumber = 4

if let unwrapped = optionalNumber {
    print("Squared value is \(square(number: unwrapped))")
}

// MARK: 7. Shadowing: using same name inside `if let`

if let optionalNumber = optionalNumber {
    print("Squared value using shadowing: \(square(number: optionalNumber))")
}

// Outside the if-let, it’s still optional
print("Outside scope: optionalNumber is \(String(describing: optionalNumber))")

// MARK: - Understanding guard let

// MARK: Example 1: Basic if let vs guard let

var myVar: Int? = 3

// if let: runs the block only if there's a value
if let unwrapped = myVar {
    print("✅ if let: myVar has a value: \(unwrapped)")
} else {
    print("❌ if let: myVar is nil")
}

// guard let: runs the else block only if there is NO value
func checkValueWithGuard(_ value: Int?) {
    guard let unwrapped = value else {
        print("❌ guard let: myVar is nil")
        return
    }

    print("✅ guard let: myVar has a value: \(unwrapped)")
}

checkValueWithGuard(myVar)


// MARK: Example 2: Using guard let in a function to exit early

func printSquare(of number: Int?) {
    guard let number = number else {
        print("❌ Missing input")
        return  // ❗️Swift requires this early exit if unwrapping fails
    }

    // ✅ `number` is non-optional here
    print("📐 \(number) × \(number) = \(number * number)")
}

var validInput: Int? = 5
var invalidInput: Int? = nil

print("\n-- Valid input --")
printSquare(of: validInput)

print("\n-- Invalid input --")
printSquare(of: invalidInput)


// MARK: Example 3: Using guard with other conditions (not just optionals)

func validateArray(_ array: [String]) {
    guard !array.isEmpty else {
        print("❌ Array is empty.")
        return
    }

    print("✅ Array has elements: \(array)")
}

validateArray(["Swift", "Optionals"])
validateArray([])

// MARK: - Nil Coalescing Operator (??)

//: Welcome to the third way of unwrapping optionals in Swift – the nil coalescing operator!
//: It’s simple, powerful, and keeps your code clean by providing default values.

//MARK: Example 1: Dictionary Lookup with a Missing Key

let captains = [
    "Enterprise": "Picard",
    "Voyager": "Janeway",
    "Defiant": "Sisko"
]

//: 🚫 This will be nil because "Serenity" isn’t in the dictionary
let serenityCaptain = captains["Serenity"]

//: ✅ Use nil coalescing to provide a default value
let newCaptain = captains["Serenity"] ?? "N/A"
print("Captain of Serenity: \(newCaptain)") // Output: N/A

//: ⚠️ Equivalent shorthand using dictionary default:
let shorthand = captains["Serenity", default: "N/A"]
print("Shorthand: \(shorthand)")

// MARK: Example 2: Array with randomElement()

let tvShows = ["Archer", "Babylon 5", "Ted Lasso"]
let favorite = tvShows.randomElement() ?? "None"
print("Favorite show: \(favorite)")

//: What if the array is empty?
let emptyShows: [String] = []
let fallbackFavorite = emptyShows.randomElement() ?? "No shows available"
print("Fallback: \(fallbackFavorite)")

// MARK: Example 3: Struct with Optional Property

struct Book {
    let title: String
    let author: String?
}

let book = Book(title: "Beowulf", author: nil)
let authorName = book.author ?? "Anonymous"
print("Author: \(authorName)")

//MARK: Example 4: Converting String to Int

let input = "" // User might enter this from a text field
let number = Int(input) ?? 0
print("Converted number: \(number)") // Output: 0

//MARK: Experiment Zone
// Try changing input = "42" or input = "Hello" and see the difference!

// MARK: - Optional Chaining

// MARK: Basic Example

let names = ["Arya", "Bran", "Robb", "Sansa"]

// `randomElement()` returns an optional because the array might be empty.
let chosen = names.randomElement()?.uppercased() ?? "No one"
print("Next in line: \(chosen)")

//: Explanation:
//: - `randomElement()` might return nil if `names` is empty
//: - `?.uppercased()` means: "If not nil, uppercase it"
//: - `?? "No one"` means: "If the entire thing is nil, use this default"
//: Result: A safe way to read, transform, and fallback — all in one line.

//: ---
//: ## Behind the Scenes (Equivalent Expanded Code)

if let name = names.randomElement() {
    print("Next in line: \(name.uppercased())")
} else {
    print("Next in line: No one")
}

//: Optional chaining saved us from having to write this if-let block manually.


//MARK: Deep Chaining with Structs

struct BookOp {
    let title: String
    var author: String?
}

var bookOp: BookOp? = nil

// Optional chaining across multiple levels
let authorInitial = bookOp?.author?.first?.uppercased() ?? "A"
print("Author initial: \(authorInitial)")

//: Reads as:
//: - "If `book` exists, and it has an `author`,
//: - and that author string has a first letter,
//: - then uppercase it.
//: - Otherwise, return 'A'."

//: ---
//: ## 🧪 More Examples

// 1. Optional chaining with method call
let message: String? = "   Hello Swift   "
let trimmedLength = message?.trimmingCharacters(in: .whitespaces).count ?? 0
print("Trimmed length: \(trimmedLength)")

// 2. Optional chaining with arrays
let tvShowsOp: [String]? = ["Breaking Bad", "Severance", "Loki"]
let firstShow = tvShowsOp?.first?.lowercased() ?? "none"
print("First show: \(firstShow)")

// 3. Optional chaining with computed values
struct User {
    var name: String?
}
let user: User? = User(name: "Taylor Swift")
let firstLetter = user?.name?.first?.uppercased() ?? "?"
print("User initial: \(firstLetter)")


// MARK:  Optional Assignment (Safe)

// This will only assign if `book` is non-nil
bookOp?.author = "Homer"


// MARK: - Failure Functions

//: # ⚠️ Optional Try (`try?`) in Swift
//: When calling functions that might throw errors, Swift gives us a few options:
//:
//: 1. Use `try` + `do/catch` to handle errors properly.
//: 2. Use `try!` if you're **sure** it won't throw (risky!).
//: 3. Use `try?` to convert the result into an optional — nice and clean.


//MARK: Traditional Throwing Example

enum UserError: Error {
    case badID, networkFailed
}

func getUser(id: Int) throws -> String {
    throw UserError.networkFailed
}

//: This would normally require full error handling:
/*
do {
    let user = try getUser(id: 23)
    print("User: \(user)")
} catch {
    print("Error: \(error)")
}
*/

//MARK: `try?` Simplifies It

if let user = try? getUser(id: 23) {
    print("User: \(user)")
} else {
    print("Failed to load user.")
}

//: Explanation:
//: - `try?` attempts to call `getUser()`.
//: - If it succeeds, we get the return value as an optional.
//: - If it throws, we get `nil` — silently, without needing catch blocks.

//MARK: Using `try?` with `??`

let fallbackUser = (try? getUser(id: 23)) ?? "Anonymous"
print("User: \(fallbackUser)")

//: ⚠️ Important: Wrap the `try?` in parentheses when using `??`
//: to ensure Swift applies the nil coalescing correctly.


//MARK: Avoiding `try!`

// let riskyUser = try! getUser(id: 23) // ❌ Will crash if an error is thrown
// print("This line will never run.")

//: Use `try!` **only** when you're absolutely sure an error won't happen (rare!).

//: ---
//: ## 🧪 Useful Use Cases

//: 1️⃣ When you only care if the call succeeded
func logMessage(_ text: String) throws {
    // Imagine writing to disk or remote analytics
    print("Logging: \(text)")
}

try? logMessage("User signed in") // Fire and forget

//: 2️⃣ With guard let
func loadUserSafely() {
    guard let user = try? getUser(id: 42) else {
        print("Could not load user.")
        return
    }

    print("Found user: \(user)")
}

loadUserSafely()

// MARK: With optional conversion (e.g. converting string to Int)
let inputs = "123a"
let numbers = Int(inputs) ?? 0
print("Converted: \(numbers)")

// Equivalent error-throwing scenario
enum ConversionError: Error {
    case invalidFormat
}

func toInt(_ string: String) throws -> Int {
    guard let value = Int(string) else {
        throw ConversionError.invalidFormat
    }
    return value
}

let safeInt = (try? toInt("456")) ?? -1
print("Safely converted: \(safeInt)")


// MARK: - Checkpoint 9

// Write a single-line function that returns a random Int from an optional array.
// If the array is nil or empty, return a random Int between 1 and 100.
func randomInt(from array:[Int]?) -> Int{
    array?.randomElement() ?? Int.random(in: 1...100)
}

print(randomInt(from: [10, 20, 30]))  // Might print 10, 20, or 30
print(randomInt(from: []))             // Prints a random number between 1 and 100
print(randomInt(from: nil))            // Prints a random number between 1 and 100
