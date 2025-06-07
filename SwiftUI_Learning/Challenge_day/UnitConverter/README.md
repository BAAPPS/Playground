# Unit Converter Project

## Overview

This project is a simple **Temperature Unit Converter** built with SwiftUI. It converts temperature values between **Celsius**, **Fahrenheit**, and **Kelvin**. 

- The app demonstrates how to use state variables, form inputs, pickers, and computed properties for reactive UI updates and conversion logic.

---

## Step 1: Define State Variables

To store user input and selections, we create three `@State` properties:

```swift
@State private var temperatureInput = 0.0
@State private var inputTemperatureUnit = "Celsius"
@State private var outputTemperatureUnit = "Fahrenheit"
```

* `temperatureInput` holds the numeric temperature entered by the user.
* `inputTemperatureUnit` and `outputTemperatureUnit` store the selected units from predefined options.

We also define the available temperature units in an array:

```swift
let temperatures = ["Celsius", "Fahrenheit", "Kelvin"]
```

---

## Step 2: Build the User Interface with a Form

We use a `Form` inside a `NavigationStack` to create a structured UI with sections:

```swift
Form {
    Section("Enter a temperature you want to convert") {
        TextField("Temperature", value: $temperatureInput, format: .number)
            .keyboardType(.decimalPad)
    }

    Section("Convert from") {
        Picker("", selection: $inputTemperatureUnit) {
            ForEach(temperatures, id: \.self) { unit in
                Text(unit)
            }
        }
        .pickerStyle(.segmented)
    }

    Section("Convert to") {
        Picker("", selection: $outputTemperatureUnit) {
            ForEach(temperatures, id: \.self) { unit in
                Text(unit)
            }
        }
        .pickerStyle(.segmented)
    }

    Section("Result") {
        Text(convertUnits.formatted(.number.precision(.fractionLength(2))))
    }
}
.navigationTitle("Unit Converter")
.navigationBarTitleDisplayMode(.inline)
```

* The first section lets users input a temperature number.

* The next two sections have segmented pickers to select input and output units.

* The last section displays the converted temperature result, formatted to show 2 decimal places.

---

## Step 3: Implement the Conversion Logic with a Computed Property

The core logic lives inside the `convertUnits` computed property:

```swift
var convertUnits: Double {
    let celsiusValue: Double

    // First, always convert the input value to the base unit: Celsius
    switch inputTemperatureUnit {
    case "Celsius":
        celsiusValue = temperatureInput
    case "Fahrenheit":
        celsiusValue = (temperatureInput - 32) * 5 / 9
    case "Kelvin":
        celsiusValue = temperatureInput - 273.15
    default:
        celsiusValue = temperatureInput
    }

    // Then convert from Celsius to the desired output unit
    switch outputTemperatureUnit {
    case "Celsius":
        return celsiusValue
    case "Fahrenheit":
        return celsiusValue * 9 / 5 + 32
    case "Kelvin":
        return celsiusValue + 273.15
    default:
        return celsiusValue
    }
}
````

The idea is to **always convert the input value to a base unit first**, and for temperature conversions, that base unit is **Celsius**.

Once you've converted the input to Celsius, you then convert from Celsius to the desired output unit. 

This simplifies your code because instead of writing conversion logic for every possible pair (which would be a lot), you only write:

* Conversion **to** Celsius from each unit

* Conversion **from** Celsius to each unit

That way, for 3 units (Celsius, Fahrenheit, Kelvin), you only need **2 conversions per unit** (to and from Celsius), instead of 6 total direct conversions between every pair.

Since there are three temperature units — `Celsius`, `Fahrenheit`, and `Kelvin` — there are 6 possible conversion paths:

* Celsius → Fahrenheit

* Celsius → Kelvin

* Fahrenheit → Celsius

* Fahrenheit → Kelvin

* Kelvin → Celsius

* Kelvin → Fahrenheit

But by using Celsius as the base, your logic stays clean and concise.

---

## Examples of Temperature Conversion

Here are some example inputs and expected outputs when using the app:

| Input Value | Input Unit | Output Unit | Expected Result |
|-------------|------------|-------------|-----------------|
| 0           | Celsius    | Fahrenheit  | 32.00           |
| 32          | Fahrenheit | Celsius     | 0.00            |
| 100         | Celsius    | Kelvin      | 373.15          |
| 273.15      | Kelvin     | Celsius     | 0.00            |
| 212         | Fahrenheit | Kelvin      | 373.15          |
| 0           | Kelvin     | Fahrenheit  | -459.67         |

### How to read the table:

- Enter the **Input Value** in the text field.

- Choose the **Input Unit** from the first picker.

- Choose the **Output Unit** from the second picker.

- The app calculates and displays the **Expected Result** based on the conversion logic.

This makes it easy to test and verify that your conversions are working correctly.

---

## Refactoring for Safety: From Strings to Enums


Currently, we are using a string array to represent the temperature units:

```swift
let temperatures = ["Celsius", "Fahrenheit", "Kelvin"]
````

While this works, it can lead to potential bugs. For example, if we accidentally write `"Celsiussss"` instead of `"Celsius"` in our switch statements or when setting selections, the compiler won’t catch this mistake. 

This can cause unexpected behavior or runtime errors.

### How can we do better?

Swift’s `enum` type offers a safer and more robust way to represent a fixed set of related values, like temperature units. By using an enum:

* The compiler can enforce valid cases, preventing typos.

* Code becomes more readable and maintainable.

* You can add computed properties or methods related to each case, encapsulating conversion logic better.

### Example Enum for Temperature Units:

```swift
enum TemperatureUnit: String, CaseIterable, Identifiable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    case kelvin = "Kelvin"
    
    var id: String { self.rawValue }
}
```

This way, you replace the string array with `TemperatureUnit.allCases` for iteration, and your `@State` variables can be typed as `TemperatureUnit` instead of `String`. 

The switch statements will be exhaustive, catching any missing cases at compile time.

Thus,

* Enum switch (all cases handled) → No default needed

* String or non-exhaustive switch → Default needed to handle unexpected values

Using enums helps avoid errors and makes your code safer and easier to refactor as the project grows.

### Updated Code

Below is the updated version of our ContentView, fully refactored to use the TemperatureUnit enum. 

This makes our code more type-safe, readable, and maintainable.

```swift
enum TemperatureUnit: String, CaseIterable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    case kelvin = "Kelvin"
}

struct ContentView: View {
    @State private var temperatureInput = 0.0
    @State private var inputTemperatureUnit: TemperatureUnit = .celsius
    @State private var outputTemperatureUnit: TemperatureUnit = .fahrenheit

    var convertUnits: Double {
        let celsiusValue: Double
        switch inputTemperatureUnit {
        case .celsius:
            celsiusValue = temperatureInput
        case .fahrenheit:
            celsiusValue = (temperatureInput - 32) * 5 / 9
        case .kelvin:
            celsiusValue = temperatureInput - 273.15
        }
        switch outputTemperatureUnit {
        case .celsius:
            return celsiusValue
        case .fahrenheit:
            return celsiusValue * 9 / 5 + 32
        case .kelvin:
            return celsiusValue + 273.15
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Enter a temperature you want to convert") {
                    TextField("Temperature", value: $temperatureInput, format: .number)
                        .keyboardType(.decimalPad)
                }
                Section("Convert from") {
                    Picker("", selection: $inputTemperatureUnit) {
                        ForEach(TemperatureUnit.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Convert to") {
                    Picker("", selection: $outputTemperatureUnit) {
                        ForEach(TemperatureUnit.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Result") {
                    Text(convertUnits.formatted(.number.precision(.fractionLength(2))))
                }
            }
            .navigationTitle("Unit Converter")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

```

---

## Recap

This app demonstrates key SwiftUI concepts like:

* Managing user input with `@State`.
* Using `Form`, `Section`, `TextField`, and `Picker` to build interactive UI.
* Applying computed properties for clean, reactive conversion logic.
* Formatting numbers for display.

By breaking down the problem into:

* **Input capture**
* **Unit selection**
* **Conversion through a base unit**
* **Displaying results**

