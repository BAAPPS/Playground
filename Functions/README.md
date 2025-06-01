# Summary

## Day 7 – Functions, parameters, and return values

### What Are Functions?

- Functions let you **reuse code** by giving it a name and calling it whenever you want.
- This helps avoid duplication and makes maintenance easier.

**Example:**
```swift
func showWelcome() {
    print("Welcome to my app!")
    print("By default this prints a conversion chart.")
}
showWelcome()
````

### Why Use Functions?

* To avoid repeating the same code in multiple places.
* To organize your code better by encapsulating logic.
* To make your code flexible with input parameters.

---

### Passing Data Into Functions (Parameters)

* Functions can accept **parameters** to make them flexible.
* Parameters act as placeholders for the data the function needs.

**Example:**

```swift
func printTimesTables(number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}
printTimesTables(number: 5)
```

#### Multiple Parameters

* Functions can accept more than one parameter.

```swift
func printTimesTables(number: Int, end: Int) {
    for i in 1...end {
        print("\(i) x \(number) is \(i * number)")
    }
}
printTimesTables(number: 5, end: 20)
```

#### Parameters vs Arguments

* **Parameters** are the placeholders defined in a function.
* **Arguments** are the actual values passed to a function when called.

```swift
// Parameters:
func greet(name: String) { ... }
// Arguments:
greet(name: "Taylor")
```

#### Parameter Order Matters

* Arguments must be passed in the order parameters are defined.
* Swapping the order causes a compile error.

```swift
// Valid
printTimesTables(number: 5, end: 20)

// Invalid - causes error
// printTimesTables(end: 20, number: 5)
```

---

### Returning Values from Functions

* Use `-> Type` after parameters to specify a return type.
* Return a value with the `return` keyword.
* For single-expression functions, `return` can be omitted.

**Example:**

```swift
func rollDice() -> Int {
    Int.random(in: 1...6)
}
let result = rollDice()
print(result)
```

### Returning Early in `Void` Functions

* Functions returning `Void` (nothing) can exit early using `return` without a value.

```swift
func checkPassword(_ input: String) {
    if input != "OpenSesame" {
        print("Access denied.")
        return
    }
    print("Welcome!")
}
```

---

### Function Parameters and Argument Labels

* Swift uses **external parameter names** at call sites for clarity.
* You can omit the external name by prefixing the parameter with `_`.
* You can specify **separate external and internal names**.

**Example:**

```swift
func isUppercase(_ string: String) -> Bool {
    string == string.uppercased()
}
let result = isUppercase("HELLO")
```

**With external/internal names:**

```swift
func printTimesTables(for number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}
printTimesTables(for: 5)
```

* Swift supports function overloading by external parameter names.

```swift
func hireEmployee(name: String) { }
func hireEmployee(title: String) { }
func hireEmployee(location: String) { }
```

---

### Returning Multiple Values: Tuples

* Tuples allow returning multiple values with fixed size and types.
* Unlike arrays or dictionaries, tuples guarantee presence and type safety.

```swift
func getUser() -> (firstName: String, lastName: String) {
    ("Taylor", "Swift")
}
let user = getUser()
print("Name: \(user.firstName) \(user.lastName)")
```

* Tuples can be destructured into separate variables.

```swift
let (firstName, lastName) = getUser()
print("Name: \(firstName) \(lastName)")
```

* Use `_` to ignore tuple elements you don’t need.

```swift
let (firstName, _) = getUser()
print("Name: \(firstName)")
```

---

### Additional Tips

* Variables created inside functions (including parameters) exist only during function execution and are destroyed afterward.
* Use built-in functions like `Int.random(in:)` and methods like `.isMultiple(of:)` for common tasks.

```swift
let roll = Int.random(in: 1...20)
print("You rolled a \(roll)")

let number = 139
if number.isMultiple(of: 2) {
    print("Even")
} else {
    print("Odd")
}
```

---

### Customizing Parameter Names in Swift Functions

Swift lets you control how function parameters are named and used, which improves code readability and clarity at both the call site and inside the function.


#### Why Name Parameters?

Clear parameter names help anyone reading your code understand what each argument represents, making function calls self-explanatory.

**Example:**
```swift
func rollDice(sides: Int, count: Int) -> [Int] {
    var rolls = [Int]()
    for _ in 1...count {
        rolls.append(Int.random(in: 1...sides))
    }
    return rolls
}

let rolls = rollDice(sides: 6, count: 4)
// Easy to understand what’s being rolled and how many times
````

#### Function Overloading by Parameter Names

Swift uses external parameter names to distinguish between functions with the same name but different parameters.

```swift
func hireEmployee(name: String) { }
func hireEmployee(title: String) { }
func hireEmployee(location: String) { }

// Swift knows which function to call based on argument labels:
hireEmployee(name: "Taylor")
hireEmployee(title: "Manager")
hireEmployee(location: "New York")
```

#### Omitting External Parameter Names

Sometimes parameter names clutter your function calls when the meaning is obvious.

Use `_` before a parameter name to omit its external label:

```swift
func isUppercase(_ string: String) -> Bool {
    string == string.uppercased()
}

let result = isUppercase("HELLO, WORLD") // Clean, no label needed
```

This style is common in Swift standard functions like `append()` and `contains()`.

#### Using Different External and Internal Names

You can specify one name for use **outside** the function (the call site), and a different one **inside** the function body.

```swift
func printTimesTables(for number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(for: 5) // Reads naturally: "print times tables for 5"
```

* `for` is the external parameter name used when calling the function.
* `number` is the internal parameter name used inside the function.

---

#### Summary

* Use clear external parameter names to make function calls readable.
* Use `_` to omit external labels when they add no clarity.
* Provide separate external/internal names to improve call-site readability while keeping clear internal code.
* Swift’s function overloading can differentiate functions based on external parameter names.

---

## Day 8 – Default values, throwing functions, and checkpoint 4

### Default Parameters in Functions

Adding parameters to functions lets us customize behavior by passing different values. 

However, many times you want the same default behavior without specifying every parameter each time.

Swift lets us **provide default values** for parameters, so callers can omit them when the default is sufficient.

**Example:**
```swift
func printTimesTables(for number: Int, end: Int = 12) {
    for i in 1...end {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(for: 5, end: 20)  // Custom end value
printTimesTables(for: 8)            // Uses default end = 12
````

This means:

* The parameter `end` has a default value of `12`.
* You can call `printTimesTables` with or without specifying `end`.
* If you omit `end`, the function uses the default.

---

#### Real-world example: `removeAll()` on arrays

Swift’s `removeAll(keepingCapacity:)` uses a default parameter:

* By default, it frees up memory (`keepingCapacity = false`).
* You can pass `true` if you want to keep capacity for efficiency.

This shows how default parameters keep your functions flexible but simple to call in common cases.

---

### Error Handling in Swift

Swift requires explicit error handling to avoid runtime crashes. The process involves:

1. **Defining Errors**  
   Create an `enum` conforming to `Error` listing possible errors:
   ```swift
   enum PasswordError: Error {
       case short, obvious
   }
````

2. **Throwing Errors**
   Write functions marked with `throws` that can throw errors using `throw`:

   ```swift
   func checkPassword(_ password: String) throws -> String {
       if password.count < 5 {
           throw PasswordError.short
       }
       if password == "12345" {
           throw PasswordError.obvious
       }
       // Return password strength otherwise
   }
   ```

3. **Handling Errors**
   Call throwing functions with `try` inside a `do` block, and handle errors using `catch`:

   ```swift
   do {
       let result = try checkPassword("12345")
       print("Password rating: \(result)")
   } catch PasswordError.short {
       print("Please use a longer password.")
   } catch PasswordError.obvious {
       print("That password is too obvious!")
   } catch {
       print("Unexpected error: \(error.localizedDescription)")
   }
   ```

**Notes:**

* `try!` can be used to call a throwing function without error handling but will crash if an error is thrown—use with caution.
* Errors provide detailed messages in human-readable, user-friendly message describing the error, and it's accessible via `error.localizedDescription` .


### Checkpoint 4: Finding Integer Square Roots with Error Handling

This challenge implements a custom Swift function to calculate the **integer square root** of a number from **1 to 10,000**, using manual logic (not `sqrt()`), with robust error handling.

#### Requirements:
- Accept an integer between **1 and 10,000**.
- Return the **integer square root** (e.g., √25 = 5).
- Throw errors for:
  - ❌ Numbers **out of bounds**.
  - ❌ Numbers that **don’t have an integer square root**.

#### Error Types:
```swift
enum squareRootBoundaryError: Error {
    case outOfBound, noRoot
}
````

#### Main Function:

```swift
func findSquareRoot(of number: Int = 1) throws -> Int {
    // Checks bounds and searches for an exact square
}
```

#### Example Usage:

```swift
let result = try findSquareRoot(of: 25)
// ✅ Returns 5

let result = try findSquareRoot(of: 3)
// ❌ Throws .noRoot

let result = try findSquareRoot(of: 10_001)
// ❌ Throws .outOfBound
```

#### Summary

This demonstrates:

* How to write **custom validation logic**.
* How to use `throws`, `do`, `try`, and `catch` to **gracefully handle errors**.
* How to **enforce input constraints** without using built-in math functions.


