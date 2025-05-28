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

