import Cocoa

/* MARK: - String Conditionals */

/*
Swift can compare strings lexicographically (i.e., in alphabetical order) using relational operators like `<`, `>`, `<=`, and `>=`.

When we write: ourName < friendName

Swift compares the Unicode values of each character, starting from the first, to determine which string comes first alphabetically.

No manual sorting or extra logic is needed — it works just like comparing numbers. (SO FREAKING COOL! 🥹)
*/

let ourName = "Dave Lister"
let friendName = "Arnold Rimmer"

// If `ourName` comes before `friendName` alphabetically, it prints: "It's Dave Lister vs Arnold Rimmer"
// Otherwise, it prints: "It's Arnold Rimmer vs Dave Lister"
if ourName < friendName {
    print("It's \(ourName) vs \(friendName)")
} else {
    print("It's \(friendName) vs \(ourName)")
}

/* MARK: - Array Conditionals */

/*
If adding a new item to an array makes it exceed a certain size, we can conditionally remove elements.

In this example, we append a number to an array and check if the count exceeds 3. If it does, we remove the oldest item (at index 0).

This uses three familiar tools:
- `append()` to add a value
- `count` to check the array's size
- `remove(at:)` to remove the first item
*/

var numbers = [1, 2, 3]

// Add a 4th number
numbers.append(4)

// If we now have more than 3 items, remove the first
if numbers.count > 3 {
    numbers.remove(at: 0)
}

// Display the result
print(numbers) // Output: [2, 3, 4]

/* MARK: - Empty String Conditionals */

/*
Swift provides multiple ways to check if a string is empty, which is useful when validating user input.

We want to assign a default value ("Anonymous") if the user enters nothing.

Ways to check if a string is empty:
1. Compare directly with an empty string: `username == ""`
2. Use `.count == 0` — not ideal in Swift due to performance costs.
3. Use `.isEmpty` — the most efficient and readable option.

`.isEmpty` is preferred because it returns a Boolean directly and avoids unnecessary processing.
*/

var username = "taylorswift13"

// If the string is empty, assign a default name
if username.isEmpty {
    username = "Anonymous"
}

// Print the result
print("Welcome, \(username)!")

/* MARK: - Conditional Logic with `if`, `else if`, `else`, &&, || */

/*
Swift evaluates conditions as Booleans — `true` or `false` — using comparison (`==`, `!=`, `>=`, etc.) and logical operators (`&&`, `||`).

- `if`: runs code if the condition is true.
- `else`: runs code if the `if` condition is false.
- `else if`: lets you check additional conditions when the first fails.
- `&&`: "and" — all conditions must be true.
- `||`: "or" — at least one condition must be true.
*/

// Basic if/else
let age = 16

if age >= 18 {
    print("You can vote in the next election.")
} else {
    print("Sorry, you're too young to vote.")
}

// Using `else if` to check multiple values
let a = false
let b = true

if a {
    print("Code to run if a is true")
} else if b {
    print("Code to run if a is false but b is true")
} else {
    print("Code to run if both a and b are false")
}

// Using `&&` to check multiple conditions together
let temp = 25

if temp > 20 && temp < 30 {
    print("It's a nice day.")
}

// Using `||` to allow either of two conditions to pass
let userAge = 14
let hasParentalConsent = true

if userAge >= 18 || hasParentalConsent {
    print("You can buy the game")
}

// Complex example using enum, ||, else if, and else
enum TransportOption {
    case airplane, helicopter, bicycle, car, scooter
}

// We explicitly specify TransportOption.airplane once here to tell Swift the type.
// After this, Swift knows `transport` is a TransportOption,
// so we can use the shorthand `.airplane` instead of writing the full enum name every time.
let transport = TransportOption.airplane

if transport == .airplane || transport == .helicopter {
    print("Let's fly!")
} else if transport == .bicycle {
    print("I hope there's a bike path…")
} else if transport == .car {
    print("Time to get stuck in traffic.")
} else {
    print("I'm going to hire a scooter now!")
}

/* MARK: - Switch Statements*/

// Using if and else if repeatedly can get hard to read and error-prone,
// especially when checking the same variable multiple times.

enum Weather {
    case sun, rain, wind, snow, unknown
}

let forecast = Weather.sun

// This works, but has problems:
// - Repeating `forecast` in every condition is redundant.
// - Accidentally checking the same case twice (like `.rain` here).
// - Missing some cases (like `.snow`).

if forecast == .sun {
    print("It should be a nice day.")
} else if forecast == .rain {
    print("Pack an umbrella.")
} else if forecast == .wind {
    print("Wear something warm")
} else if forecast == .rain {  // Mistake: repeated condition
    print("School is cancelled.")
} else {
    print("Our forecast generator is broken!")
}

// Switch statement solves these problems:
// - You only mention `forecast` once.
// - Swift requires exhaustive handling of all enum cases, so you can’t miss one.
// - Swift checks each case once and stops, so no accidental duplicates.

switch forecast {
case .sun:
    print("It should be a nice day.")
case .rain:
    print("Pack an umbrella.")
case .wind:
    print("Wear something warm")
case .snow:
    print("School is cancelled.")
case .unknown:
    print("Our forecast generator is broken!")
}

// Explanation:
// 1. `switch forecast` tells Swift what value we’re checking.
// 2. Each `case` is a possible value of `Weather`.
// 3. We don’t need to write `Weather.sun` because Swift infers the enum type from `forecast`.
// 4. Each case has a colon `:` followed by the code to run if matched.
// 5. The switch ends with a closing brace `}`.
// 6. Swift requires all cases covered (exhaustive), helping catch mistakes.

// For non-enum types like String, which have infinite values,
// you must include a `default` case to handle all others:

let place = "Metropolis"

switch place {
case "Gotham":
    print("You're Batman!")
case "Mega-City One":
    print("You're Judge Dredd!")
case "Wakanda":
    print("You're Black Panther!")
default:
    print("Who are you?")
}

// Notes on switch behavior:
// - Swift runs only the first matching case and then exits (no fall-through by default).
// - If you want to continue to the next case(s), use `fallthrough` explicitly.
//   This is rare but can be useful, like for printing cumulative lines:

let day = 5
print("My true love gave to me…")

switch day {
case 5:
    print("5 golden rings")
    fallthrough
case 4:
    print("4 calling birds")
    fallthrough
case 3:
    print("3 French hens")
    fallthrough
case 2:
    print("2 turtle doves")
    fallthrough
default:
    print("A partridge in a pear tree")
}

/* MARK: - Ternary Operators */

// The last way to check conditions in Swift is with the ternary conditional operator.
// It’s a compact way to choose between two values based on a condition.
// You might wonder why it’s useful, but it’s especially important in SwiftUI.

// Binary operators like + or == work with two inputs (e.g., 2 + 5).
// The ternary operator works with three inputs: a condition, a value if true, and a value if false.

// Syntax:
// condition ? valueIfTrue : valueIfFalse

let ageTern = 18

// Here we check if age is at least 18.
// If true, canVote is set to "Yes", otherwise "No".
let canVote = ageTern >= 18 ? "Yes" : "No"
print(canVote)  // Prints: Yes

// Breakdown (Scott Michaud’s helpful mnemonic: WTF = What, True, False):
// What? age >= 18  — the condition to check
// True: "Yes"      — value if condition is true
// False: "No"      — value if condition is false

// Another example printing a message based on the hour of the day:
let hour = 23
print(hour < 12 ? "It's before noon" : "It's after noon")
// Prints: "It's after noon"

// Example checking if an array is empty, then returning a string accordingly:
let names = ["Jayne", "Kaylee", "Mal"]
let crewCount = names.isEmpty ? "No one" : "\(names.count) people"
print(crewCount)  // Prints: "3 people"

// Using the ternary with enums can look a bit confusing at first:
enum Theme {
    case light, dark
}

let theme = Theme.dark
let background = theme == .dark ? "black" : "white"
print(background)  // Prints: black

// Breaking it down:
// What? theme == .dark
// True: "black"
// False: "white"

// Why use the ternary operator instead of if/else?

// With if/else, you’d have to write either this invalid code:
print(
    // This is invalid syntax in Swift:
    // if hour < 12 {
    //    "It's before noon"
    // } else {
    //    "It's after noon"
    // }
)

// Or call print twice:
if hour < 12 {
    print("It's before noon")
} else {
    print("It's after noon")
}

// That’s fine for simple cases, but in SwiftUI you often must return values directly
// inside expressions, so the ternary operator is essential.

// In summary:
// - The ternary operator is a compact if-else that returns values based on a condition.
// - Syntax is: condition ? valueIfTrue : valueIfFalse
// - It’s especially useful where you must return values inline (e.g., SwiftUI views).
// - It can look a bit confusing at first but gets clearer with practice.


/* MARK: - Summary */

/*
Swift provides several ways to handle conditions — here’s a quick guide with examples and tips:

1. if / else
- Use for basic branching: run code if condition is true, else run alternative code.
- Add else if to check multiple exclusive conditions.
- Tip: Avoid redundant checks by structuring mutually exclusive conditions.

Example:
let age = 16
if age >= 18 {
    print("You can vote")
} else if age >= 16 {
    print("Almost old enough")
} else {
    print("Too young to vote")
}
 
---

2. Combining Conditions (&& and ||)
- Use && (AND) to require multiple conditions all be true.
- Use || (OR) to allow any one condition to be true.
- Tip: Drop `== true` when checking Booleans; just use the Boolean directly.

Example:
let temp = 25
if temp > 20 && temp < 30 {
    print("Nice weather")
}

let hasParentalConsent = true
if age >= 18 || hasParentalConsent {
    print("Can buy the game")
}
 
---

3. Enums with if / else if
- Enums represent fixed sets of values.
- When comparing enum values repeatedly, write the enum name once then use shorthand `.case`.
- Tip: Improves readability and reduces repetition.

Example:
enum TransportOption { case airplane, helicopter, bicycle, car, scooter }
let transport = TransportOption.airplane

if transport == .airplane || transport == .helicopter {
    print("Let's fly!")
} else if transport == .bicycle {
    print("Hope there's a bike path")
} else {
    print("Time for a scooter")
}

---
 
4. switch Statement
- Cleaner and safer for multiple discrete cases, especially enums.
- Must be exhaustive: handle all cases or use default.
- Executes only the first matched case.
- Tip: Use switch to catch missing enum cases — Swift warns you.
- Use `fallthrough` if you intentionally want to execute the next case (rare).

Example:
switch transport {
case .airplane, .helicopter:
    print("Let's fly!")
case .bicycle:
    print("Bike path please")
case .car:
    print("Traffic time")
case .scooter:
    print("Scooting along")
}

let place = "Gotham"
switch place {
case "Gotham":
    print("You're Batman!")
case "Metropolis":
    print("You're Superman!")
default:
    print("Unknown city")
}
---

5. Ternary Conditional Operator
- Compact inline if/else that returns one of two values.
- Syntax: `condition ? valueIfTrue : valueIfFalse`
- Perfect for quick decisions, especially in expressions and SwiftUI.
- Tip: Use only for simple conditions to keep code readable.

Example:
let canVote = age >= 18 ? "Yes" : "No"
print(canVote)

let hour = 23
print(hour < 12 ? "It's before noon" : "It's after noon")

enum Theme {
    case light, dark
}

let theme = Theme.dark
let background = theme == .dark ? "black" : "white"
print(background)

---

Summary:
- Use if/else for simple conditional branching.
- Combine multiple checks efficiently with '&&' (and) and '||' (or).
- Use enums to represent fixed states and compare with shorthand `.case`.
- Prefer 'switch' for clean, exhaustive handling of multiple discrete values.
- Use the 'ternary operator' for concise inline value selection, especially in UI code.

Swift’s strictness with switch helps avoid bugs by forcing all cases to be handled, and the ternary operator makes simple conditionals compact and expressive.
*/
