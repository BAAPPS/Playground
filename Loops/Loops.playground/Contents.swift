import Cocoa

/* MARK: - For Loop */

/*
Swift makes it easy to repeat code using `for` loops.
We can loop over arrays, dictionaries, sets, or even fixed ranges of numbers.
This is helpful for repeating actions or processing collections.
*/

// Looping over an array
let platforms = ["iOS", "macOS", "tvOS", "watchOS"]

for os in platforms {
    print("Swift works great on \(os).")
}

/*
- `os` is called the 'loop variable' and exists only inside the loop.
- Each loop cycle is called an 'iteration'.
- The code inside the braces is called the 'loop body'.
*/

// Custom loop variable names
for rubberChicken in platforms {
    print("Swift works great on \(rubberChicken).")
}

/*
Swift loops also support autocompletion in Xcode:
Type `for plat` and it may suggest `for platform in platforms`.
*/

// Looping over a range of numbers
for i in 1...12 {
    print("5 x \(i) is \(5 * i)")
}

/*
- `1...12` creates a closed range: includes both 1 and 12.
- `i` is commonly used as a loop counter.
- Ranges are a unique type in Swift.
*/

/* MARK: Nested loops */

for i in 1...12 {
    print("The \(i) times table:")

    for j in 1...12 {
        print("  \(j) x \(i) is \(j * i)")
    }

    print() // Adds a line break between tables
}

/*
- Nested loops = loop inside another loop.
- `print()` with no arguments adds a blank line.
*/

/* MARK: Half-open ranges using `..<` */

for i in 1...5 {
    print("Counting from 1 through 5: \(i)")
}

print()

for i in 1..<5 {
    print("Counting 1 up to 5: \(i)")
}

/*
- `1..<5` is a half-open range: includes 1 through 4, but not 5.
- Useful for working with arrays when you want to avoid index out of bounds.
*/

// Ignoring the loop variable with `_`
var lyric = "Haters gonna"

for _ in 1...5 {
    lyric += " hate"
}

print(lyric)

/*
- Use `_` when you don’t need the loop variable.
- Great for running code a specific number of times.
*/

/* MARK: - While Loops */

/*
Swift's `while` loop runs code repeatedly while a condition is true.
Use it when you don’t know in advance how many times to loop.
Unlike `for` loops, `while` is condition-based.
*/

// Basic while loop
var countdown = 10

while countdown > 0 {
    print("\(countdown)…")
    countdown -= 1
}

print("Blast off!")

/*
- `countdown` starts at 10.
- Loop runs until `countdown` is no longer greater than 0.
- Useful when you want to keep looping until something changes at runtime.
*/

// Generating random numbers
let id = Int.random(in: 1...1000)
print("Random ID: \(id)")

let amount = Double.random(in: 0...1)
print("Random amount: \(amount)")

/*
- `Int.random(in:)` returns a random integer in a range.
- `Double.random(in:)` returns a random decimal.
- Great for simulations, games, randomness.
*/

// Using while loop with randomness
var roll = 0

while roll != 20 {
    roll = Int.random(in: 1...20)
    print("I rolled a \(roll)")
}

print("Critical hit!")

/*
- Rolls a 20-sided die until we get a 20.
- Each iteration generates a new random number.
- The loop stops as soon as the condition `roll != 20` becomes false.
- Demonstrates a good use case for `while` when end condition is unknown.
*/

/* MARK: - continue and break in Swift loops */

/*
Swift provides two ways to skip parts of loops:
- `continue` skips the current loop iteration and moves to the next.
- `break` exits the loop entirely, skipping all remaining iterations.
*/

// Example: Using continue to skip items
let filenames = ["me.jpg", "work.txt", "sophie.jpg", "logo.psd"]

for filename in filenames {
    if filename.hasSuffix(".jpg") == false {
        continue  // Skip non-jpg files
    }
    
    print("Found picture: \(filename)")
}

/*
- Loops over filenames array.
- If the filename does NOT end with ".jpg", skip to next iteration.
- Otherwise, print the filename.
- Useful for filtering inside loops.
*/

// Example: Using break to exit a loop early
let number1 = 4
let number2 = 14
var multiples = [Int]()

for i in 1...100_000 {
    if i.isMultiple(of: number1) && i.isMultiple(of: number2) {
        multiples.append(i)
        
        if multiples.count == 10 {
            break  // Stop loop once we find 10 common multiples
        }
    }
}

print("First 10 common multiples of \(number1) and \(number2):")
print(multiples)

/*
- Loops from 1 to 100,000.
- Adds numbers that are multiples of both number1 and number2.
- Stops early after finding 10 such multiples.
- Useful when searching and you want to exit early.
*/

/* MARK: - Checkpoint 3: FizzBuzz */

// This classic coding problem asks us to loop from 1 to 100
// and print different messages based on divisibility:
//
// - If a number is a multiple of 3, print "Fizz"
// - If a number is a multiple of 5, print "Buzz"
// - If it's a multiple of both, print "FizzBuzz"
// - Otherwise, print the number itself

// We'll build up results in an array and then print them all at once
// to avoid Playground truncating output.

var results = [String]()

for i in 1...100 {
    switch true {
    case i.isMultiple(of: 3) && i.isMultiple(of: 5):
        results.append("FizzBuzz")
    case i.isMultiple(of: 3):
        results.append("Fizz")
    case i.isMultiple(of: 5):
        results.append("Buzz")
    default:
        results.append("\(i)")
    }
}

// Output everything as a single string, one item per line
print(results.joined(separator: "\n"))

/* MARK: - Summary */


/*
1. for Loops
- Loop over arrays, sets, dictionaries, or ranges.
- Loop variable holds each item in turn.
- Use _ to ignore the loop variable if unused.

Example:
let platforms = ["iOS", "macOS", "tvOS"]
for platform in platforms {
    print("Swift runs on \(platform)")
}

for _ in 1...3 {
    print("Repeat 3 times")
}

---
 
2. while Loops
- Run while a condition is true.
- Useful when the number of iterations is not known upfront.

Example:
var count = 3
while count > 0 {
    print(count)
    count -= 1
}
print("Blast off!")

---
 
3. Skipping Loop Iterations
- continue: Skip the current loop iteration and proceed to the next.
- break: Exit the loop immediately.

Example:
for i in 1...10 {
    if i % 2 == 0 {
        continue  // Skip even numbers
    }
    print(i)
    if i == 7 {
        break  // Stop loop at 7
    }
}
 
---
 
4. Checkpoint 3: FizzBuzz

In this checkpoint, we solved the classic FizzBuzz challenge by looping from 1 to 100 and using conditional logic to print:

 - "Fizz" for numbers divisible by 3
 - "Buzz" for numbers divisible by 5
 - "FizzBuzz" for numbers divisible by both
 - The number itself otherwise

 We used a `switch true` statement with `.isMultiple(of:)` for clean logic, stored results in an array, and printed all output at once using `joined(separator: "\n")` for better display in Playgrounds.

*/
 
 
