# Word Scramble Summary

---

## Day 29 – Project 5, part one

---

##  Understanding `List` in SwiftUI

In SwiftUI, `List` is one of the most frequently used view types when working with dynamic or structured data. Although views like `Text` or `VStack` might be used more often, `List` is a true workhorse – the SwiftUI equivalent of `UITableView` in UIKit.

### What `List` Does

`List` creates a **scrollable table of data**, ideal for displaying rows of information. It’s similar to `Form`, but geared toward **presenting data** rather than collecting input.

### Static and Dynamic Content

You can populate a `List` with static views:

```swift
List {
    Text("Hello World")
    Text("Hello World")
}
```

Or use `ForEach` for dynamic content:

```swift
List {
    ForEach(0..<5) {
        Text("Dynamic row \($0)")
    }
}
```

Better yet, **mix static and dynamic content**:

```swift
List {
    Text("Static row 1")
    ForEach(0..<5) {
        Text("Dynamic row \($0)")
    }
    Text("Static row 2")
}
```

### Using Sections

`List` supports `Section` to group content and improve readability:

```swift
List {
    Section("Static Rows") {
        Text("Row 1")
        Text("Row 2")
    }
    Section("Dynamic Rows") {
        ForEach(0..<5) {
            Text("Dynamic row \($0)")
        }
    }
}
```

> Tip: If your section header is just text, you can use a simple string label.

### Unique Row Identification

When rendering data from arrays, SwiftUI must distinguish each item uniquely. For simple data types like strings or integers, use `id: \.self`:

```swift
struct ContentView: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]

    var body: some View {
        List(people, id: \.self) {
            Text($0)
        }
    }
}
```

You can still combine this with static rows using `ForEach`:

```swift
List {
    Text("Static Row")
    ForEach(people, id: \.self) {
        Text($0)
    }
}
```

### Customizing Appearance

Modify list appearance using `.listStyle()`, such as:

```swift
.listStyle(.grouped)
```

This allows for flexible and familiar designs, like replicating settings menus or grouped content.

---

##  Working with Bundles and External Files in SwiftUI

When working with assets in SwiftUI, such as images, SwiftUI automatically checks your **asset catalog** and loads the correct resolution for the current device (`@2x`, `@3x`, etc.). 

But when it comes to **non-image files** like `.txt`, `.json`, or `.xml`, you’ll need to do a bit more manual work.

### What Is a Bundle?

When Xcode builds your app, it packages everything into a **bundle** – a self-contained directory that includes:

* Compiled Swift code
* Image assets
* Custom resources (like `.txt` or `.json` files)

This structure is consistent across all Apple platforms and enables organized, sandboxed storage for your app.

> As your skills grow, you’ll encounter **multiple bundles** inside an app (e.g., for Siri, widgets, or iMessage extensions), but your primary code and assets always live in the **main app bundle**.

---

### Accessing Files in the Bundle

To access a file from your app bundle, you’ll work with Swift’s `URL` type and `Bundle.main`.

#### Step 1: Get the File URL

Use `Bundle.main.url(forResource:withExtension:)` to look for your file:

```swift
if let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
    // File found in bundle
}
```

* This returns an **optional URL** (`URL?`) – meaning the file may or may not be found.
* iOS sandbox paths are not predictable or user-accessible, so don’t worry about what the path looks like.

#### Step 2: Load File Contents as String

Once you have the file URL, use `String(contentsOf:)` to read it into memory:

```swift
if let fileContents = try? String(contentsOf: fileURL) {
    // File successfully loaded into a String
}
```

* The initializer **throws an error** if the file can’t be loaded, so it must be used with `try`, `try?`, or a `do-catch` block.
* After this step, the file contents are just a regular `String`, ready to parse or use however you need.

---

### Recap

Using external data files in your SwiftUI apps involves:

1. **Storing the file** in your app’s bundle.
2. **Accessing the file** using `Bundle.main.url(...)`.
3. **Reading the file** using `String(contentsOf:)`.

This method works across all file types (e.g., `.txt`, `.json`, `.xml`) and provides a clean way to manage and load data that isn't part of your asset catalog.

---

## Working with Strings in Swift

Swift provides a rich set of APIs for working with strings, including splitting, trimming, randomizing, and even spellchecking. These are especially useful when processing file-based word data in games like **Word Scramble**.

---

### Splitting Strings into Arrays

In this app, we load a file from the bundle that contains 10,000+ eight-letter words – one per line. To work with them effectively, we convert the single text blob into an array of strings using `components(separatedBy:)`.

#### 🧪 Example:

```swift
let input = """
a
b
c
"""
let letters = input.components(separatedBy: "\n")
```

* This will split the string into: `["a", "b", "c"]`.

You can then pick a random word from the array using:

```swift
let letter = letters.randomElement()
```

> ⚠️ `randomElement()` returns an **optional**, so you'll need to unwrap it safely.


### Trimming Whitespace and Newlines

Sometimes, words may have leading/trailing spaces or line breaks. Swift has a built-in way to clean these up:

```swift
let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
```

This removes:

* Spaces
* Tabs
* Newline characters (`\n`, `\r\n`)

### Spellchecking with `UITextChecker`

Swift lets you check the spelling of a word using the UIKit class `UITextChecker`. This works fine in SwiftUI too.

#### 1. **Create the spell checker and word to check:**

```swift
let word = "swift"
let checker = UITextChecker()
```

#### 2. **Define the range to check using UTF-16:**

```swift
let range = NSRange(location: 0, length: word.utf16.count)
```

#### 3. **Run the spell check:**

```swift
let misspelledRange = checker.rangeOfMisspelledWord(
    in: word,
    range: range,
    startingAt: 0,
    wrap: false,
    language: "en"
)
```

#### 4. **Evaluate the result:**

```swift
let isCorrect = misspelledRange.location == NSNotFound
```

* `NSNotFound` means no misspelling was found.
* If a spelling mistake **was** found, `misspelledRange.location` will indicate its position.

> Note: `UITextChecker` uses **Objective-C APIs**, which is why we need `NSRange` and `utf16.count` for compatibility.

---

### Recap

Swift makes string processing powerful and expressive with:

* `components(separatedBy:)` – splitting strings
* `trimmingCharacters(in:)` – cleaning up whitespace/newlines
* `randomElement()` – selecting random items from arrays
* `UITextChecker` – built-in spellchecking via Objective-C

Together, these form the core of how the **Word Scramble** app processes and verifies user input efficiently.

---

## Day 30 – Project 5, part two

---

## Building the UI & Handling Text Input in Word Scramble

This project introduces key concepts in SwiftUI including state management, navigation, text input, lists, and handling keyboard submissions.


###  Basic UI Layout

We’ll build our interface using three main components:

1. **`NavigationStack`** – Displays the current root word as the navigation title.
2. **`TextField`** – Allows the user to enter a new word.
3. **`List`** – Shows all previously entered words.

#### Required State Properties

```swift
@State private var usedWords = [String]()
@State private var rootWord = ""
@State private var newWord = ""
```

---

### Submitting Words

To let users submit a word by pressing **Return**:

1. We define an `addNewWord()` function.
2. Use `.onSubmit(addNewWord)` to trigger the method when the user presses Return.

#### 🧠 Logic for `addNewWord()`

```swift
func addNewWord() {
    let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    guard answer.count > 0 else { return }

    withAnimation {
        usedWords.insert(answer, at: 0)
    }
    newWord = ""
}
```

* Lowercases and trims the text to avoid duplicate-like entries such as `" Car "` and `"car"`.
* Uses `insert(..., at: 0)` to show new words at the **top** of the list.
* Wrapped in `withAnimation {}` for a smooth slide-in effect.

---

### Disabling Automatic Capitalization

By default, the iOS simulator keyboard capitalizes the first letter of user input. Since we convert all input to lowercase internally, this creates a **visual mismatch** (e.g., user sees `Car`, but the list shows `car`).

#### ✅ Fix:

Add this modifier to your `TextField`:

```swift
.textInputAutocapitalization(.never)
```

---

### ⚠️ Important Simulator Note

> 🧪 **Use a real iOS Simulator (or physical iPhone) for testing!**

The **default Xcode preview** or text input inside Xcode canvas **does not** behave the same as an actual iOS keyboard. Specifically:

* It may not respect `.textInputAutocapitalization(.never)`
* It can give misleading results for text field behavior and keyboard return actions

✅ Always test your input fields on:

* An iPhone **simulator** running inside the iOS Simulator app
* A real iPhone device, if available

### Final View Layout

```swift
var body: some View {
    NavigationStack {
        List {
            Section {
                TextField("Enter your word", text: $newWord)
                    .textInputAutocapitalization(.never)
            }

            Section {
                ForEach(usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }
                }
            }
        }
        .navigationTitle(rootWord)
        .onSubmit(addNewWord)
    }
}
```

---

### Recap

* SwiftUI’s `TextField` works beautifully when paired with `.onSubmit()` and state.
* Use `.textInputAutocapitalization(.never)` to match the visual output.
* Always test input features using a real simulator or physical iPhone to ensure keyboard behavior is accurate.

---

## Loading Bundle Resources: Using `start.txt` in Word Scramble

When Xcode builds an iOS app, it places all your **compiled code and assets** into a single directory called a **bundle**, typically named `YourAppName.app`.

This bundle includes:

* Compiled Swift code
* Image and asset catalogs
* Info.plist
* Other bundled files like `.txt`, `.json`, etc.

iOS and macOS automatically recognize `.app` bundles, which is why double-clicking `Notes.app` on macOS launches the actual app inside.


### Adding `start.txt` to Your Project

Our game will use a file called **`start.txt`**, which contains over 10,000 eight-letter words. This file was provided with the project—**drag it into your Xcode project** so it gets bundled with your app.

> **Important**: Make sure the “Copy items if needed” checkbox is selected, and the file is added to the correct target (usually your app's target).

### What We’re Doing in `startGame()`

We want to:

1. **Locate** `start.txt` inside the app bundle.
2. **Read** its contents into a single string.
3. **Split** the string into an array of individual words.
4. **Select** one random word to be our root word (or fallback to a default).

Here’s the function:

```swift
func startGame() {
    // 1. Locate start.txt in the app bundle
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
        // 2. Try loading the file contents into a String
        if let startWords = try? String(contentsOf: startWordsURL) {
            // 3. Split the contents into an array
            let allWords = startWords.components(separatedBy: "\n")

            // 4. Pick a random word or fall back to a default
            rootWord = allWords.randomElement() ?? "silkworm"
            return
        }
    }

    // ❌ If something went wrong, terminate immediately with a helpful message
    fatalError("Could not load start.txt from bundle.")
}
```


### Why Use `fatalError()`?

Calling `fatalError()` **intentionally crashes** your app with a clear error message.

* 💡 Use it when something **must never fail**, like loading critical resources.
* It helps **quickly surface configuration issues**, like forgetting to add `start.txt` to your project.

> This is **not** a bug—it's a powerful tool to catch developer mistakes early in development.

### Hooking It Up in SwiftUI

To make sure `startGame()` runs when the view appears, use SwiftUI’s `.onAppear()` modifier:

```swift
.onAppear(perform: startGame)
```

Add this below your `.onSubmit(...)` modifier.

---

### Final Reminder: Test on a Real Simulator

> ⚠️ Just like with text input issues, always **test bundle loading on an actual iOS simulator** or real device.

* Xcode previews or canvas modes sometimes don’t reflect bundle behavior properly.
* You won’t get a real crash from `fatalError()` in preview mode—it silently fails or never runs.
* Real simulators actually bundle and sandbox the file system just like on-device.


### Recap

* iOS app bundles store resources like `start.txt`, which you can access via `Bundle.main`.
* Use `fatalError()` to safely crash when core assets are missing—it’s better than letting your app continue in a broken state.
* Always test features like file loading and startup logic in the **actual iOS Simulator** or on a **real device** to catch realistic behavior.

---

## Word Validation in Word Scramble (with Example)

To keep our word game fair and functional, we need to ensure users only submit **valid words**. That means:

1. They haven’t **used the word already**.
2. The word can be **built from the root word**.
3. It’s a **real English word**.

To implement this, we define **three validator methods** and one helper for showing error alerts.


### 1. Is the Word Original?

Check if the word has already been submitted.

```swift
func isOriginal(word: String) -> Bool {
    !usedWords.contains(word)
}
```

### 2. Is the Word Possible?

Check if every letter in the player’s word exists in the **root word**, without reusing letters more than allowed.

```swift
func isPossible(word: String) -> Bool {
    var tempWord = rootWord

    for letter in word {
        if let pos = tempWord.firstIndex(of: letter) {
            tempWord.remove(at: pos)
        } else {
            return false
        }
    }

    return true
}
```


### 3. Is the Word Real?

Use UIKit’s `UITextChecker` to verify if the word exists in English.

```swift
func isReal(word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

    return misspelledRange.location == NSNotFound
}
```

### 4. Showing Validation Errors

Declare state variables to track the current alert:

```swift
@State private var errorTitle = ""
@State private var errorMessage = ""
@State private var showingError = false
```

Create a reusable method to show validation errors:

```swift
func wordError(title: String, message: String) {
    errorTitle = title
    errorMessage = message
    showingError = true
}
```

Show the alert in your `View` using `.alert()`:

```swift
.alert(errorTitle, isPresented: $showingError) { } message: {
    Text(errorMessage)
}
```


### Integrating All in `addNewWord()`

Replace `// extra validation to come` with:

```swift
guard isOriginal(word: answer) else {
    wordError(title: "Word used already", message: "Be more original")
    return
}

guard isPossible(word: answer) else {
    wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
    return
}

guard isReal(word: answer) else {
    wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
    return
}
```


## Example: Validating the Word **“palettes”**

Let’s assume the root word is **“telepaths”**.

We validate `"palettes"` like this:

### 1. **Originality**

If `"palettes"` hasn’t been used yet in `usedWords`, this returns `true`.

### 2. **Possibility**

Does `"palettes"` only use letters from `"telepaths"`?

* `"telepaths"` has: t, e, l, e, p, a, t, h, s
* `"palettes"` requires: p, a, l, e, t, t, e, s

Breakdown:

* ✅ p → used once
* ✅ a → used once
* ✅ l → used once
* ✅ e → used twice
* ✅ t → used twice
* ✅ s → used once

There are **not enough e’s** (only two needed, but `"telepaths"` has just two – okay!)
There are **not enough t’s** (needs two, has two – okay!)
✅ So: `"palettes"` *is possible*.

### 3. **Real Word**

`UITextChecker` confirms `"palettes"` is a real word.

✅ So, all validations pass – `"palettes"` is accepted!


## Recap

* This modular approach makes the code easy to test, extend, and maintain.
* You could later enhance `isReal()` to use custom dictionaries or offline spell checking.
* Errors are user-friendly and explain exactly what went wrong.

---

## Day 31 – Project 5, part three

---

## Challenges & Solutions

This is a SwiftUI word game where players try to make new words from a given root word. To deepen understanding and practice SwiftUI, I extended the basic app with the following challenges and solutions:


### 1. Disallow Answers That Are Too Short or Match the Root Word

**Challenge:**  
Prevent players from submitting words that are less than three letters or exactly the same as the root word.

**Solution:**  
Implemented the `isBadAnswer(word:)` function to check if a word is either shorter than 3 characters or matches the root word (case-insensitive). In `addNewWord()`, a guard clause prevents these invalid inputs, showing an 
alert if the input is invalid.

```swift
func isBadAnswer(word: String) -> Bool {
    let trimmedWord = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedWord.count < 3 || trimmedWord == rootWord.lowercased()
}
````

### 2. Add a Toolbar Button to Restart the Game

**Challenge:**
Allow users to restart the game at any time with a new root word.

**Solution:**
Added a toolbar button in the navigation bar that calls the `startGame()` function. This button is placed in the `.navigationBarTrailing` toolbar item, allowing users to easily get a new root word and reset the game.

```swift
.toolbar {
    ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: startGame) {
            Label("New Word", systemImage: "arrow.clockwise")
        }
    }
}
```

### 3. Display a Live Score Tracking the Player's Progress

**Challenge:**
Show the player's score, calculated based on the number and length of valid words submitted.

**Solution:**
Created a `pointsEarned` state variable to track the score. Each valid word adds points according to length rules defined in `wordPoints(for:)`. The current score is displayed in the navigation bar using a `.principal` 
toolbar item.

```swift
@State private var pointsEarned = 0

func wordPoints(for word: String) -> Int {
    let trimmedWord = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    
    switch trimmedWord.count {
    case _ where trimmedWord.count == rootWord.count:
        return rootWord.count
    case 4...:
        return 2
    case 3:
        return 1
    default:
        return 0
    }
}
```

The score updates dynamically when a valid word is added, and it appears centered in the navigation bar.

## Recap

These challenges helped practice SwiftUI features such as:

* Input validation with guard clauses
* State management and dynamic UI updates
* Using toolbars and navigation items effectively
* Providing user feedback with alerts

The final app is more robust, user-friendly, and interactive, making the learning experience fun and practical.

