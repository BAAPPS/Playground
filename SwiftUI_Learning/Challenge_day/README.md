# 🧮 Unit Converter — A SwiftUI App

This project is a **self-directed challenge** designed to test and reinforce your knowledge of **SwiftUI**, state management, and real-time user input handling by building a unit conversion tool from scratch.

---

## What You’ll Build

An interactive **unit conversion app** that lets users:

* Select an **input unit** (e.g. meters, Celsius, seconds)
.
* Select an **output unit** (e.g. miles, Fahrenheit, minutes).

* Enter a **numeric value**.

* See the **converted result** immediately update on screen.

The app can be customized to convert any of the following:

*  **Temperature** — Celsius, Fahrenheit, Kelvin

* **Length** — meters, kilometers, feet, yards, miles

* **Time** — seconds, minutes, hours, days

* **Volume** — milliliters, liters, cups, pints, gallons

You choose which category you want to support.

---

## What You’ll Learn

This challenge helps solidify SwiftUI fundamentals:

* Creating **Forms**, **TextFields**, and **Pickers**

* Managing input using `@State`

* Building **computed properties** to perform live calculations

* Formatting numerical results with `.formatted()`

* Structuring your layout for clarity and usability

---

## Project Structure

### 1. Input Controls

* A **TextField** for user input (`.keyboardType(.decimalPad)`, format: `.number`)

* Two **Picker** views:

  * One for selecting the **input unit**
  
  * One for selecting the **output unit**

Use a simple `units` array and `ForEach(units, id: \.self)` to create options dynamically.

---

### 2. Conversion Logic

Rather than converting directly between every possible unit pair, use a **base unit** approach:

```swift
// Example for Length
// Convert input to meters first (base unit), then convert to output
let baseValue = convertToMeters(inputValue, from: inputUnit)
let result = convertFromMeters(baseValue, to: outputUnit)
```

This strategy keeps your logic simple and avoids exponential complexity.

---

### 3. Output

Use a `Text` view to display the result:

```swift
Text(convertedValue.formatted())
```

Swift’s `.formatted()` gives users clean, locale-aware number formatting.

---

## Implementation Notes

* Track these as `@State` properties:

  * `inputValue: Double`
  
  * `inputUnit: String`
  
  * `outputUnit: String`
  
* Define an array of supported units:

  ```swift
  let units = ["Meters", "Kilometers", "Feet", "Miles", "Yards"]
  ```
* Split your layout into `Form` sections for better organization.

---

## Tips for Success

* **Start simple** — prioritize clarity over cleverness.

* Revisit **WeSplit** for guidance — especially for `@State`, `TextField`, and formatting.

* Don’t overthink the math — basic multiplication/division is enough.

* Want to explore more? Check out Apple’s [`Measurement`](https://developer.apple.com/documentation/foundation/measurement) and `Unit` API for robust unit conversions (optional).


