# Swift Practice – 100 Days of Swift

This repository contains my personal practice and notes while following the [100 Days of Swift](https://www.hackingwithswift.com/100) curriculum by Paul Hudson. All code is written and tested in `.playground` files, organized by day and topic.

---

## 🚀 Purpose

The goal of this project is to reinforce Swift fundamentals through daily, hands-on coding using Swift Playgrounds. Each day focuses on a specific core concept, with practical exercises and small test cases.

---

## 📚 Topics Covered

### ✅ Days 1–3 Completed

- **Day 1** – Variables, constants, strings, and numbers  [Swift Fundamental 1](https://github.com/BAAPPS/Playgrounds/blob/main/Basics.playground/Contents.swift)
- **Day 2** – Booleans, string interpolation, and checkpoint 1  [Swift Fundamental 2](https://github.com/BAAPPS/Playgrounds/blob/main/Basics.playground/Contents.swift)
- **Day 3** – Arrays, dictionaries, sets, and enums   [Swift Fundamental 3](https://github.com/BAAPPS/Playgrounds/blob/main/complexDataTypes.playground/Contents.swift)

---

## 🛠 Requirements

- Xcode (tested with version compatible with Swift 5+)
- macOS (Playgrounds are designed to run in Xcode)

---

## 📌 Notes

- These files are **not production-ready code** — they're for learning and experimentation.
- Feel free to fork this repo or use the examples for your own learning.

---

## 🙏 Credits

Thanks to [Paul Hudson](https://www.hackingwithswift.com) for the incredible **100 Days of Swift** course and the Swift community for their resources and support.

---

## 📅 Progress

### Day 1 – Variables, Constants, and Strings

- Learned how to declare variables (`var`) and constants (`let`), and understood the difference between mutable and immutable values.
- Created and manipulated strings, including:
  - Using escape characters for quotes inside strings.
  - Writing multi-line strings with triple quotes.
  - Using string properties and methods such as `.count`, `.uppercased()`, `.hasPrefix()`, and `.hasSuffix()`.
- Practiced basic printing to the console with `print()`.

### Day 2 – Numbers and Booleans

- Explored whole numbers (integers) and decimal numbers (floating-point, `Double`), including:
  - Numeric literals with underscores for readability.
  - Arithmetic operators (`+`, `-`, `*`, `/`) and compound assignment operators (`+=`, `*=`, etc.).
  - Type safety in Swift and explicit type conversion between `Int` and `Double`.
- Worked with Booleans (`true`/`false`), including:
  - Using logical NOT operator `!` and `.toggle()` method.
- Applied string interpolation to embed variables and expressions inside strings.
- Completed a checkpoint exercise converting Celsius to Fahrenheit.

  Here’s a concise **progress summary for Day 3** based on the provided Swift code and explanations:

---

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

This hands-on practice strengthened foundational Swift concepts critical for progressing through the 100 Days of Swift curriculum.
