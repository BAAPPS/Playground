# Better Rest Summary

## Day 26 – Project 4, part one

---

## App Introduction

**BetterRest** is a forms-based SwiftUI app designed to help coffee drinkers optimize their sleep using the power of **Core ML**, Apple’s built-in machine learning framework.

### What the App Does

The app asks users three simple questions:
1. When do you want to wake up?
2. How many hours of sleep do you want?
3. How many cups of coffee do you drink per day?

With this data, the app uses a trained machine learning model to predict the ideal time for the user to go to bed, helping them get a better night's rest.

### Why Machine Learning?

Although this project might feel like another basic form-based app at first, its real purpose is to introduce you to one of iOS development’s most powerful tools: **machine learning**.

Using **Core ML**, we:
- Start with raw sleep-related data.
- Train a machine learning model on a Mac.
- Use the trained model in a SwiftUI app to make predictions — all **on device** and with **full user privacy**.

This project uses **regression analysis** to model complex relationships between input data (wake time, desired sleep, and coffee intake) and the output (optimal bedtime). With billions of possible combinations, Core ML 
allows the app to generalize and make accurate predictions from new input.

### Key Technologies & Concepts

- SwiftUI Forms
- `DatePicker`, `Stepper`, `Alert`
- Core ML Integration
- Regression analysis in ML
- Privacy-conscious, on-device prediction

---

## Using Stepper for Numeric Input

SwiftUI offers two main controls for numeric input: `Stepper` and `Slider`. 

### Why Stepper?

* Provides `-` and `+` buttons to adjust numbers precisely.
* Supports multiple number types: `Int`, `Double`, etc.
* Can be customized with a **range** and a **step size**.

### Example Usage

```swift
@State private var sleepAmount = 8.0

Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
```

### Features Demonstrated

* Binds to a `Double` value.
* Restricts input between **4 and 12 hours**.
* Uses **0.25** (15-minute) increments.
* Formats the value for cleaner UI (e.g., `8.0` instead of `8.000000`).

This makes it easy for users to select a valid and reasonable sleep duration — clean, accurate, and user-friendly.

---

## `DatePicker` Deep Dive

SwiftUI provides a built-in `DatePicker` control that allows users to select dates and times in a user-friendly way. 

This component is tightly integrated with Swift's native `Date` type and is highly customizable in both appearance and functionality.

### Basics: Binding a `Date` to `DatePicker`

To begin using a `DatePicker`, you need a state property to hold the selected date. Swift offers a `Date` type that represents points in time.

```swift
@State private var wakeUp = Date.now
```

This `@State` property can be bound directly to a `DatePicker`:

```swift
DatePicker("Please enter a date", selection: $wakeUp)
```

When run, this displays an interface to select a date and time, with the prompt “Please enter a date” displayed to the left.

### UI Considerations: Labels and Accessibility

While it's tempting to hide the label using an empty string like this:

```swift
DatePicker("", selection: $wakeUp)
```

That creates two issues:

1. It still reserves space for the (now empty) label.
2. It breaks accessibility by removing helpful context for screen readers.

**Best practice:**

Use the `.labelsHidden()` modifier to keep the label available for VoiceOver while hiding it visually:

```swift
DatePicker("Please enter a date", selection: $wakeUp)
    .labelsHidden()
```

This keeps your UI clean **and** accessible.


### Configuration Options

#### `displayedComponents`

This parameter customizes the type of picker shown:

* `.date` → Shows month, day, and year.
* `.hourAndMinute` → Shows just the time.
* *Default* (if omitted) → Shows full date and time.

Example showing time only:

```swift
DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
```

#### `in` Parameter: Limiting Date Range

You can constrain the selectable date range using the `in` parameter, just like with `Stepper`. Swift lets you define both full and **one-sided ranges**:

```swift
let tomorrow = Date.now.addingTimeInterval(86400) // 1 day ahead
let range = Date.now...tomorrow
```

Used in a `DatePicker`:

```swift
DatePicker("Please enter a date", selection: $wakeUp, in: Date.now...tomorrow)
```

For allowing only future dates:

```swift
DatePicker("Please enter a date", selection: $wakeUp, in: Date.now...)
```

This reads as “any date from now onward.”


### Summary

* SwiftUI’s `DatePicker` binds to a `Date` property using `$` syntax.
* Use `.labelsHidden()` instead of removing labels to preserve accessibility.
* Configure the picker using `displayedComponents` for date, time, or both.
* Limit selectable values with the `in:` range parameter, including one-sided ranges.

SwiftUI’s `DatePicker` is a flexible and accessible way to let users pick dates and times in your apps.

---

## Working with Dates in SwiftUI

Handling dates may seem straightforward—just bind a `Date` to a `DatePicker`—but it quickly gets complex: daylight savings, leap seconds, and historical calendar transitions all complicate things. 

Don’t worry though—Apple’s frameworks have you covered!


### 1. Bind Dates to `DatePicker`

To let users select a date:

```swift
@State private var wakeUp = Date.now

DatePicker("Enter wake-up time", selection: $wakeUp)
```

This gives you a full `Date` (including year, month, day, hour, minute, second, timezone), but any real-world use needs extra handling.


### 2. Why Dates Are Tricky

* **Daylight Saving:** 23‑hour or 25‑hour days.
* **Leap Seconds:** Occasional 61-second minutes.
* **Calendar Switches:** E.g. Julian → Gregorian in September 1752 missing 12 days if you run `cal 9 1752`.

All these complexities mean you should avoid manual date math and rely on Apple's `Calendar`, `DateFormatter`, `DateComponents`, and `Date` APIs.


### 3. Use Cases in Our App

We need to handle dates in three ways:

1. **Choose a sensible default wake-up time.**
2. **Extract hour & minute from the user's selection.**
3. **Display the suggested bedtime in a neat, localized format.**

Apple’s APIs help with all of them.


### 4. Default Wake-Up Time with `DateComponents`

To create a date like "8:00 AM today":

```swift
var components = DateComponents()
components.hour = 8
components.minute = 0

let defaultWake = Calendar.current.date(from: components) ?? .now
```

Using `Calendar.date(from:)` handles timezone, DST, and missing dates safely. The result is optional, so use `??` to fall back to a sensible default.

### 5. Extracting Hour & Minute

After users select a date:

```swift
let comps = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
let hour = comps.hour ?? 0
let minute = comps.minute ?? 0
```

Even though you asked only for `.hour` and `.minute`, the returned components are optional—so unwrap or default them.

### 6. Formatting Dates & Times

#### a) Using SwiftUI’s date formatting:

```swift
Text(Date.now, format: .dateTime.hour().minute())
```

Here, ordering adapts automatically to the user's locale (e.g. “8:00 AM” vs “08:00”).

For full dates:

```swift
Text(Date.now, format: .dateTime.day().month().year())
```

SwiftUI handles locale formatting for you.

#### b) Using `formatted()` API:

```swift
Text(Date.now.formatted(date: .long, time: .shortened))
```

This works well for custom length formats (e.g., “June 1, 2025 at 8:00 AM”).

### 7. Summary

* **Binding**: `@State var date = Date()` + `DatePicker(...)`
* **Defaults**: Use `DateComponents` + `Calendar` for structured defaults
* **Parsing**: Extract hour/minute via `Calendar.dateComponents(...)`
* **Formatting**: Use SwiftUI’s `.dateTime` formatting or `.formatted()` for locale-aware output

### Final Thoughts

Working with dates is deceptively tricky—don’t reinvent the wheel. Leverage Apple’s robust tools to:

* Respect time zones and daylight savings,
* Support user locale formatting,
* Save yourself from edge-case bugs.

SwiftUI and Foundation provide everything you need for **correct**, **concise**, and **user-friendly** date handling.

---

##  On-Device Machine Learning with Core ML & Create ML



### Tools and Technologies

### Core ML
Apple's on-device framework for integrating trained models into your apps. Core ML runs locally, offering privacy, speed, and no need for a network connection.

### Create ML
A macOS app for training machine learning models without code. It offers drag-and-drop simplicity for tasks like:

- Importing CSV data
- Choosing prediction targets
- Selecting training features
- Evaluating model performance
- Exporting `.mlmodel` files


###  How the Model Was Trained

1. **Open Create ML**

   Launch from Xcode via:  
   `Xcode > Open Developer Tool > Create ML`

2. **Start a New Project**

   - Select **Tabular Regression**
   - Name the project: `BetterRest`
   - Save it to your Desktop

3. **Import Training Data**

   - Use the provided `BetterRest.csv` file
   - This CSV contains columns for:
     - `wake` (desired wake-up time)
     - `estimatedSleep` (user's sleep goal)
     - `coffee` (cups of coffee per day)
     - `actualSleep` (how much sleep they truly need)

4. **Define Prediction Parameters**

   - **Target**: `actualSleep`
   - **Features**: `wake`, `estimatedSleep`, `coffee`

5. **Select an Algorithm**

   - Use **Automatic** (default)
   - Alternatives include:
     - Random Forest
     - Boosted Tree
     - Decision Tree
     - Linear Regression

6. **Train the Model**

   - Click **Train**
   - With a small dataset (~180KB), training completes in seconds

7. **Evaluate the Results**

   - Open the **Evaluation** tab
   - Look for the **Validation > Root Mean Squared Error (RMSE)**
     - RMSE ≈ 170 seconds (about 3 minutes average error)

8. **Export the Model**

   - Go to the **Output** tab
   - Click **Get** to export the trained `.mlmodel` (≈545 bytes)


### Important Notes

- **Not for Medical Use**: The dataset is for demo purposes only. Do **not** use it for real health-related decisions.
- **Re-Training Tips**: Duplicate the model in Create ML to test other algorithms or datasets.

---

#### File Details

| File              | Description                          |
|-------------------|--------------------------------------|
| `BetterRest.csv`  | Sample data used to train the model  |
| `BetterRest.mlmodel` | Exported model for use in Swift apps |



### Why Use This Approach?

- **Simple**: Drag and drop interface
- **Fast**: Training completes in seconds for small datasets
- **Private**: Predictions are made locally, with no network dependency
- **Lightweight**: Final model file size is under 1KB, most of which is metadata

### Using Core ML for Text Classification with Custom CSV Data

Core ML, Apple's powerful on-device machine learning framework, supports training and deploying various types of models — including text classifiers.

 This enables developers to create apps that can analyze and categorize short pieces of text, such as user inputs, messages, or commands, directly on the device without needing a server.

#### Preparing Your Training Data

Training a text classification model in Core ML typically requires a CSV (comma-separated values) file containing two essential columns:

- **Text input column**: This column holds the raw text data your model will analyze (e.g., sentences, phrases, or questions).
- **Label/output column**: This column contains the categories or classes the model should predict based on the text.

While the default or common column names might be `text` for input and `label` for output, **you can customize these column names** freely. For example, columns could be named `sentence` and `category`, or `message` and 
`intent`.

When importing the CSV into the Create ML app, you specify which column is the input and which is the label, making Core ML flexible for various data structures.

#### Example CSV Structure

```csv
sentence,category
"Walking while texting",Unsafe
"Looking both ways before crossing",Safe
"Running into traffic",Unsafe
"Waiting for the signal",Safe
````

Or, with alternate column names:

```csv
message,intent
"Play on phone while walking?",Distracted
"Look both ways",SafeBehavior
```

#### Training the Model

1. Open the **Create ML** app on your Mac.
2. Select the **Text Classifier** template.
3. Import your CSV file.
4. Assign the appropriate columns as text input and label output.
5. Train the model. Create ML will process your text data, learn patterns and relationships, and create a compact `.mlmodel` file.
6. Evaluate training performance using provided metrics, such as accuracy and validation results.

#### Using the Model in Your App

After training, you export the `.mlmodel` file and integrate it into your iOS/macOS app. 

At runtime, you can input new text phrases to the model, and it will classify them into your predefined categories, enabling features like:

* Content moderation (e.g., safe vs. unsafe messages)
* Intent recognition (e.g., commands or questions)
* Simple natural language understanding tailored to your app

#### How Much Data Do You Need to Train?

The amount of data required to train an effective Core ML model varies based on several factors:

* **Task complexity**: Simple binary classification may need only a few hundred to a couple thousand examples, while more complex tasks require more data.
* **Data diversity**: Your dataset should cover the range of variations expected in real input to ensure good generalization.
* **Model type**: Different algorithms (Random Forest, Boosted Trees, Neural Networks) have different data requirements.
* **Data quality**: Clean, well-labeled data is more important than sheer volume.

| Scenario                          | Approximate Data Size       |
| --------------------------------- | --------------------------- |
| Simple binary text classification | 500 - 2,000 examples        |
| Multi-class classification        | 2,000 - 10,000+ examples    |
| Regression on tabular data        | 1,000 - 10,000+ samples     |
| Complex models or nuanced text    | 10,000+ samples recommended |

Tips for working with smaller datasets:

* Use data augmentation (e.g., paraphrasing text).
* Choose the Automatic algorithm in Create ML to find the best model.
* Monitor validation accuracy to avoid overfitting.
* Gradually collect more data as your app is used.

#### Important Notes

* Core ML text classification models **do not generate text** or perform complex reasoning like GPT-style language models.
* The model’s accuracy depends heavily on your training data quality and quantity.
* Use consistent and meaningful labels to improve classification clarity.
* You can retrain or refine your model by updating your CSV dataset and repeating the process.

---

## Day 27 – Project 4, part two

---

## BetterRest – SwiftUI Sleep Calculator


### Implementation Overview

The app uses SwiftUI's `@State` properties to store user inputs:

```swift
@State private var wakeUp = Date.now
@State private var sleepAmount = 8.0
@State private var coffeeAmount = 1
```

The UI is structured with a `NavigationStack` and `VStack`, containing:

1. A **wake-up time picker**:

   ```swift
   DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
       .labelsHidden()
   ```

2. A **sleep amount stepper**:

   ```swift
   Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
   ```

3. A **coffee intake stepper**:

   ```swift
   Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in: 1...20)
   ```

4. A **navigation bar button**:

   ```swift
   .toolbar {
       Button("Calculate", action: calculateBedtime)
   }
   ```

> The `calculateBedtime()` function is currently a placeholder and will be implemented to calculate and display the ideal bedtime based on the user’s input.

---

## Core ML Integration – Sleep Prediction

This section describes how to connect your `SleepCalculator.mlmodel` to your SwiftUI app, enabling bedtime predictions with just a few lines of code.

### 1. Add Your Core ML Model

* Drag the trained `.mlmodel` file into your Xcode project navigator.
* Check **"Copy items if needed"** to ensure it’s bundled with your app.
* Rename the file to ** `SleepCalculator.mlmodel` ** to generate a Swift class of the same name.

### 2. Import Core ML

At the top of `ContentView.swift`, add:

```swift
import CoreML
import SwiftUI
```

(Imports are kept in alphabetical order.)

### 3. Initialize the Model

Inside your `calculateBedtime()` method, create an instance of the model within a `do/catch` block:

```swift
do {
    let config = MLModelConfiguration()
    let model = try SleepCalculator(configuration: config)
    // next: model usage
} catch {
    // handle loading errors
}
```

### 4. Prepare Input Data

Convert your user inputs into the model's expected types:

* **Wake time**: extract hours & minutes, convert to seconds:

  ```swift
  let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
  let hour = (components.hour ?? 0) * 3600
  let minute = (components.minute ?? 0) * 60
  ```

* **Desired sleep**: use `sleepAmount` (Double).

* **Coffee intake**: convert `coffeeAmount` to Double.

### 5. Request a Prediction

Feed inputs into the model:

```swift
let prediction = try model.prediction(
    wake: Double(hour + minute),
    estimatedSleep: sleepAmount,
    coffee: Double(coffeeAmount)
)
```

This returns `prediction.actualSleep` (in seconds): how long the user *should* sleep.

### 6. Calculate Bedtime

Subtract the predicted sleep duration from the wake-up time:

```swift
let sleepTime = wakeUp - prediction.actualSleep
```

### 7. Display the Result via Alert

Add `@State` properties in your view:

```swift
@State private var alertTitle = ""
@State private var alertMessage = ""
@State private var showingAlert = false
```

Within `calculateBedtime()`:

```swift
alertTitle = "Your ideal bedtime is…"
alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
showingAlert = true
```

In the view’s `VStack`, attach an alert modifier:

```swift
.alert(alertTitle, isPresented: $showingAlert) {
    Button("OK") { }
} message: {
    Text(alertMessage)
}
```

---


## Sleep Calculator App – Dev Notes & Improvements

This app is functional, but not yet polished enough for public release. 

Below are key usability and design improvements that were implemented to make it more user-friendly and professional.

###  **Usability Fixes**

#### Problem: Poor Default Wake Time

The initial version set the wake-up time to the current system time (`Date.now`), which is unintuitive for most users.

#### Solution: Static Default Wake Time at 7:00 AM

We added a `defaultWakeTime` property to provide a more sensible default:

```swift
static var defaultWakeTime: Date {
    var components = DateComponents()
    components.hour = 7
    components.minute = 0
    return Calendar.current.date(from: components) ?? .now
}
```

This fixes the issue by setting a common default for the majority of users (e.g., 7:00 AM), without excluding night shift users.

### **UI/UX Improvements**

#### From `VStack` to `Form`

We replaced the basic `VStack` layout with a `Form` inside the `NavigationStack`, providing:

* A more native iOS look.
* Better input segmentation.

```swift
NavigationStack {
    Form {
        // Inputs here
    }
}
```

#### Better Layout with `VStack` Wrapping

Each pair of label and input is now wrapped in a `VStack` with leading alignment and zero spacing, e.g.:

```swift
VStack(alignment: .leading, spacing: 0) {
    Text("Desired amount of sleep")
        .font(.headline)

    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
}
```

This improves row grouping and form structure.

#### **Smart Pluralization with Markdown**

Instead of using a ternary operator to handle plurals:

```swift
Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
```

We used SwiftUI’s built-in inflection syntax:

```swift
Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
```

This ensures correct pluralization automatically.

---

## Day 28 – Project 4, part three

### Challenge Enhancements Completed

This version of the project includes the following UI/UX improvements:

**VStacks Replaced with Sections:**

Some input areas were refactored using Section instead of VStack, improving layout clarity and aligning with native iOS form conventions.

**Coffee Stepper Replaced with Picker:**

Replaced the numeric stepper for coffee intake with a Picker that allows selection from 0 to 20 cups. This offers a clearer and more scalable input method.

```swift
Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount){
    ForEach(0..<21){
        Text($0, format: .number)
    }
}
```

**Live Bedtime Calculation (No Button Required):**

Removed the “Calculate” button and now display the recommended bedtime instantly and continuously in a large, readable font below the form inputs.


```swift
    var idealBedTime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )

            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Error calculating bedtime"
        }
    }
```

```swift
    VStack {
        Text("Your ideal bedtime is… \(idealBedTime)")
    }
```

---

## Final Thoughts

Through building **BetterRest**, I learned how to integrate **Core ML** into a SwiftUI app and use a trained model to make real-time predictions based on user input. 

I also explored **Create ML**, which gave me insight into how custom machine learning models are created, trained, and exported for use on-device. 

This project helped me understand not just how to *use* machine learning in iOS apps, but also how to *train and test* my own models using real-world data. 

It's a powerful toolset that brings intelligent features directly to users — all while preserving privacy and performance.
