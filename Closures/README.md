# Summary

## Day 9 – Closures, passing functions into functions, and checkpoint 5

### Closures & Function Types in Swift

Swift functions are powerful tools — they can be:

* Assigned to variables or constants
* Passed into other functions
* Returned from functions

#### Function Copying

```swift
func greetUser() {
    print("Hi there!")
}

var greetCopy = greetUser // No parentheses — copying the function
greetCopy() // "Hi there!"
```
---

#### **What is a Closure in Swift?**

A **closure** is a self-contained block of code that you can **assign to a variable or constant**, **pass into a function**, or **return from a function**. It **captures and stores references to variables and constants from the surrounding context**, hence the name *closure*.

#### In short:

> **A closure is a function without a name that can be treated like a variable.**

---

Why closures matter:

* You can write **inline logic** (without declaring separate functions).

* They are used **everywhere** in Swift, especially in **SwiftUI, animations, networking, and sorting**.

* They enable **functional programming patterns** like `.map`, `.filter`, `.sorted`, etc.

---

You can recognize **closures** in Swift by:

#### 1. **Seeing `->` in type declarations**

These indicate the **function or closure type signature**:

* `() -> Void` — takes nothing, returns nothing.
* `(Int) -> Bool` — takes an `Int`, returns a `Bool`.
* `(String, String) -> Bool` — takes two `String`s, returns a `Bool`.

This tells you the variable or parameter is expected to be a **function or closure**.

```swift
let add: (Int, Int) -> Int = { a, b in
    return a + b
}
```
**Explanation:**
(Int, Int) -> Int is the closure type.

add is a constant holding a closure that takes two Ints and returns an Int.

The { a, b in return a + b } is the closure expression.

#### 2. **Seeing braces `{ ... }` used without a function name**

When you see:

```swift
{ a, b in
    return a + b
}
```

That’s a **closure expression**. No `func` keyword, no name — just `{}` with parameters and code.

> If it has a `func` and a name, it’s a regular function, not a closure.

#### 3. **Being passed as arguments to functions**

Especially common in **higher-order functions**:

```swift
[1, 2, 3].map { $0 * 2 }       // closure passed to `map`
names.sorted { $0 < $1 }       // closure passed to `sorted`
numbers.filter { $0 > 5 }      // closure passed to `filter`
```

These closures are often:

* Inline
* Anonymous
* Passed directly into functions expecting them

---

### Bonus tip

You can also assign closures to variables/constants:

```swift
let greeting: () -> Void = {
    print("Hello!")
}
```

Then use:

```swift
greeting()
```

---

#### Closures (Anonymous Functions)

You can define a closure directly without using `func`:

```swift
let sayHello = {
    print("Hi there!")
}
sayHello()
```

#### Closures with Parameters and Return Values

Closures define parameters and return type inside the braces:

```swift
let greet = { (name: String) -> String in
    "Hello, \(name)!"
}
greet("Taylor") // "Hello, Taylor!"
```

#### Function Types

Functions have types like `(Int) -> String`, just like `Int` or `Double`.

```swift
func getUserData(for id: Int) -> String {
    return id == 1989 ? "Taylor Swift" : "Anonymous"
}
let data: (Int) -> String = getUserData
data(1989) // "Taylor Swift"
```

#### Passing Functions as Arguments

You can pass functions (or closures) into other functions like `sorted()`:

```swift
let team = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]

func captainFirst(name1: String, name2: String) -> Bool {
    if name1 == "Suzanne" { return true }
    else if name2 == "Suzanne" { return false }
    return name1 < name2
}

let sortedTeam = team.sorted(by: captainFirst)
```

#### Or, Use a Closure Instead

```swift
let sortedTeam = team.sorted(by: { (name1, name2) -> Bool in
    if name1 == "Suzanne" { return true }
    else if name2 == "Suzanne" { return false }
    return name1 < name2
})
```
---

### Trailing Closures and Shorthand Syntax

#### 1. **Full Closure Syntax**

Start with the verbose form: defining parameter types and return type explicitly in a closure passed to `sorted(by:)`.

```swift
team.sorted(by: { (name1: String, name2: String) -> Bool in ... })
```

#### 2. **Type Inference**

Swift can infer types, so you can remove explicit parameter and return type declarations.

```swift
team.sorted(by: { name1, name2 in ... })
```

#### 3. **Trailing Closure Syntax**

If the closure is the final argument, you can move it outside the parentheses for cleaner syntax.

```swift
team.sorted { name1, name2 in ... }
```

#### 4. **Shorthand Argument Names**

Swift automatically provides `$0`, `$1`, etc., which makes short closures even more concise.

```swift
team.sorted { $0 > $1 }
```

#### 5. **Useful Built-in Methods**

** `filter {}` ** – Keeps only the elements that match a condition

  ```swift
  team.filter { $0.hasPrefix("T") }
  ```
** `map {}` ** – Transforms each element into a new value

  ```swift
  team.map { $0.uppercased() }
  ```

#### 6. **The `in` Keyword**

Used to separate the closure’s parameters from its body:

```swift
team.sorted { name1, name2 in return name1.count < name2.count }
```

#### 7. **Closures in SwiftUI**

Closures are everywhere in SwiftUI:

* Passing logic to `Button` taps
* Mapping data into `List` views
* Structuring layout via builder-style syntax

```swift
Button("Tap Me") {
    print("Button was tapped")
}
```

---

#### Best Practices for Shorthand Closures

Use `$0`, `$1` only when:

* The closure is short
* Each parameter is used once
* There are two or fewer parameters

Avoid when:

* The logic is long or complex
* Parameters are reused
* There are 3+ parameters (e.g., `$2`, `$3`, etc.)

---

### Functions as Parameters & Trailing Closures

This section demonstrates how Swift allows **functions to accept other functions as parameters**, which is especially useful when working with closures and SwiftUI.

#### Function Types as Parameters

You can pass functions (or closures) as parameters by declaring their type in the function signature:

```swift
func makeArray(size: Int, using generator: () -> Int) -> [Int]
```

* `size`: Number of times to call the function.
* `generator`: A function that takes no parameters and returns an `Int`.
* Returns: An array of integers generated by repeatedly calling `generator`.

#### Example with a closure:

```swift
let rolls = makeArray(size: 50) {
    Int.random(in: 1...20)
}
```

#### Example with a named function:

```swift
func generateNumber() -> Int {
    Int.random(in: 1...20)
}

let newRolls = makeArray(size: 50, using: generateNumber)
```

---

#### Multiple Function Parameters

Swift supports multiple function parameters and multiple **trailing closures**, which is heavily used in SwiftUI.

```swift
func doImportantWork(
    first: () -> Void,
    second: () -> Void,
    third: () -> Void
)
```

#### Called using multiple trailing closures:

```swift
doImportantWork {
    print("This is the first work")
} second: {
    print("This is the second work")
} third: {
    print("This is the third work")
}
```

#### Summary

* Swift functions can accept closures as parameters, making code reusable and expressive.
* Trailing closures simplify syntax and are idiomatic in SwiftUI.
* Multiple trailing closures allow clean separation of logic, such as UI layout sections.



### Checkpoint 5: Using Closures to Process Arrays

In this challenge, we practice chaining Swift’s array methods with closures to transform data cleanly and efficiently:

- **Input:** An array of integers.

- **Goal:**  
  1. Filter out even numbers, keeping only odds.  
  2. Sort the remaining numbers in ascending order.  
  3. Map each number to a string formatted as "`<number> is a lucky number`".  
  4. Print each resulting string on a separate line.

This demonstrates the power of closures combined with `filter()`, `sorted()`, and `map()` for concise and readable code without temporary variables.

#### Example code snippet:

```swift
let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 31, 49]

let oddLuckyNumbers = luckyNumbers
                        .filter { $0 % 2 != 0 }
                        .sorted()
                        .map { "\($0) is a lucky number" }

oddLuckyNumbers.forEach { print($0) }
````

#### Output:

```
7 is a lucky number
15 is a lucky number
21 is a lucky number
31 is a lucky number
33 is a lucky number
49 is a lucky number
```
