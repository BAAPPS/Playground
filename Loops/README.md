# Summary

### Day 6 – Loops, summary, and checkpoint 3

Swift provides powerful and flexible ways to repeat code using loops. 

#### for Loops

- Use `for` loops to iterate over collections like arrays, sets, dictionaries, or ranges.
- The loop variable takes each item in the collection, one at a time.
- You can ignore the loop variable with `_` if you don’t need it.

**Example:**

```swift
let platforms = ["iOS", "macOS", "tvOS"]

for platform in platforms {
    print("Swift works great on \(platform).")
}

for _ in 1...3 {
    print("Repeat this 3 times")
}
````

#### while Loops

* Use `while` loops when you want to repeat code as long as a condition remains true.
* The number of iterations may not be known in advance.

**Example:**

```swift
var countdown = 5

while countdown > 0 {
    print("\(countdown)…")
    countdown -= 1
}

print("Blast off!")
```

#### Skipping Loop Iterations

* Use `continue` to skip the current iteration and move to the next.
* Use `break` to exit the loop immediately, skipping all remaining iterations.

**Example:**

```swift
for i in 1...10 {
    if i % 2 == 0 {
        continue  // Skip even numbers
    }

    print(i)

    if i == 7 {
        break  // Stop loop at 7
    }
}
```

#### Checkpoint 3: FizzBuzz

In this checkpoint, we solved the classic FizzBuzz problem — a common coding exercise used in interviews and assessments.

**Goal:**  
Loop from 1 to 100 and print:
- "Fizz" for numbers divisible by 3  
- "Buzz" for numbers divisible by 5  
- "FizzBuzz" for numbers divisible by both 3 and 5  
- The number itself otherwise

**What I used:**  
- `for` loop to iterate from 1 through 100  
- `switch true` with `.isMultiple(of:)` to handle conditions cleanly  
- An array to store results before printing  
- `joined(separator: "\n")` to output everything at once (ideal for Swift Playgrounds)

This approach ensures readable logic and consistent output across platforms, especially where repeated `print()` statements might be truncated.
