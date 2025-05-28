# Summary

### Day 3 — Swift Collections & Enums

* **Arrays:**

  * Created arrays holding strings (`beatles`), integers (`numbers`), and doubles (`temperatures`).
  * Demonstrated how to append new elements to mutable arrays.
  * Explored Swift’s strict type safety: arrays hold only one type; mixing types causes errors.
  * Showed different syntaxes for array creation, including empty arrays and arrays initialized with values.
  * Covered useful array methods:

    * `.count` to get item count,
    * `.remove(at:)` and `.removeAll()` to delete items,
    * `.contains()` to check existence,
    * `.sorted()` for sorted copies,
    * `.reversed()` which creates a reversed view without changing the original.
  * Discussed the dangers of accessing arrays by index without safety checks.

* **Dictionaries:**

  * Created dictionaries with string keys and string or integer values.
  * Showed how to safely access values with optional handling and default values.
  * Created empty dictionaries and added/modified key-value pairs.
  * Demonstrated dictionary methods:

    * `.count` for number of entries,
    * `.removeAll()` to clear all entries.

* **Sets:**

  * Introduced sets as unordered, unique collections optimized for fast lookup.
  * Created sets with initial values and by inserting items individually.
  * Explored set methods:

    * `.count`,
    * `.sorted()` (returns sorted array),
    * `.contains()` to check membership,
    * `.insert()` to add items.

* **Enums (Enumerations):**

  * Explained the problem with using strings for fixed categories like days of the week (prone to typos and inconsistencies).
  * Introduced enums as a type-safe, efficient way to represent a fixed set of named values.
  * Showed enum declaration with multiple cases.
  * Demonstrated assigning and reassigning enum values with and without repeating the enum name.
  * Highlighted efficiency of enums compared to strings (stored internally as integers).

---

### Day 4 – Type Annotations & Checkpoint 2

* **Type Safety & Type Annotations**

  * Swift infers types automatically but you can explicitly specify them.
  * Prevents invalid operations (e.g., adding strings to integers).
  * Use annotations to clarify and enforce data types.

```swift
var albums: [String] = []
let score: Int = 100
```

* **Invalid Type Annotation Example**

```swift
let scoreInvalid: Int = "Zero"
```

This will throw an error of **Cannot convert value of type 'String' to specified type 'Int'**


* **Type Inference**
```swift
let surnameStr = "Lasso"
var scoreInt = 0
var clues = [String]()
```

* **Example: Working with Arrays and Sets**

```swift
let faveGames = ["Monster Hunter", "Elden Ring", "Dark Souls", "Dark Souls"]

print("Total items: \(faveGames.count)")

let uniqueGames = Set(faveGames)

print("Unique items: \(uniqueGames.count)")
```


* **Golden Rule**

Whether you use type inference or type annotation, one rule always applies: 
    
- Swift must always know the exact data type of every constant and variable.
 
This is a fundamental part of Swift being a type-safe language as it prevents
invalid code like '5 + true', where the types don’t make sense together.


### ✅ Checkpoint 2 – Practice Task

Here’s a small challenge using what I’ve learned about arrays and sets:

 - Create an array of strings (faveGames).
 
 ```swift
    let faveGames = ["Monster Hunters", "Elden Ring", "Dark Souls: Remastered", "Dark Souls: Remastered"]
 ```

 - Print the total number of items with faveGames.count.
 
  
 ```swift
    print("Total items: \(faveGames.count)")
 ```

 - Convert the array to a Set to get unique items.
 
   
 ```swift
    let uniqueItems = Set(faveGames)
 ```

 - Get the count of unique items with uniqueItems.count.

 ```swift
    print("Unique items: \(uniqueItems.count)")
 ```

