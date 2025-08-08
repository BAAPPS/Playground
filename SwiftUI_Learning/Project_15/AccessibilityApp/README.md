# Accessibility Summary

---

## Day 74 – Project 15, part one

---

## Accessibility in SwiftUI – VoiceOver & Image Labels

This project demonstrates how to make image-based UIs accessible to VoiceOver users in iOS. We start with four Unsplash images whose filenames contain the photographer’s name and an ID (e.g., `ales-krivec-15949`). While descriptive for developers, these filenames are unhelpful when read aloud by VoiceOver.

### Problem

1. **Unhelpful VoiceOver labels** – VoiceOver reads the filename (`kevin-horstmann-141705`) instead of describing the image.
2. **Incorrect control type** – The image has a tap gesture but VoiceOver only announces it as an image, not a button.

#### Initial Example

```swift
struct ContentView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]

    @State private var selectedPicture = Int.random(in: 0...3)

    var body: some View {
        Image(pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            .onTapGesture {
                selectedPicture = Int.random(in: 0...3)
            }
    }
}
```

### Accessibility Fixes

#### 1. Add Meaningful Labels

```swift
let labels = [
    "Tulips",
    "Frozen tree buds",
    "Sunflowers",
    "Fireworks"
]

.accessibilityLabel(labels[selectedPicture])
```

VoiceOver now reads descriptive text instead of the filename.

#### 2. Correct the Control Type

```swift
.accessibilityAddTraits(.isButton)
// Optional: .accessibilityRemoveTraits(.isImage)
```

Tells VoiceOver the image is also a button.

#### 3. Prefer Buttons Over Tap Gestures

Using `Button` automatically sets the correct traits and behavior:

```swift
Button {
    selectedPicture = Int.random(in: 0...3)
} label: {
    Image(pictures[selectedPicture])
        .resizable()
        .scaledToFit()
}
.accessibilityLabel(labels[selectedPicture])
```

### Key Takeaways

* Use **`.accessibilityLabel()`** for concise descriptions.
* Use **`.accessibilityHint()`** for additional context.
* Add/remove traits with `.accessibilityAddTraits()` and `.accessibilityRemoveTraits()` as needed.
* Prefer `Button` over `.onTapGesture()` for interactive images.

---

## Accessibility in SwiftUI – Hiding & Grouping Elements for VoiceOver

VoiceOver power users navigate extremely quickly, often at very high reading speeds. To support them, our UI should remove unnecessary clutter so users don’t waste time listening to unhelpful descriptions.

This guide covers three key techniques for controlling what VoiceOver reads:

### 1. Marking Unimportant Images

If an image is purely decorative and conveys no useful information, use:

```swift
Image(decorative: "character")
```

This tells SwiftUI to ignore the image for accessibility.

**Alternative:** Use `.accessibilityHidden(true)` on any view to hide it from VoiceOver:

```swift
Image(.character)
    .accessibilityHidden(true)
```

Only use this if the view truly adds nothing meaningful.


### 2. Hiding Views from Accessibility

Views that are offscreen or purely visual should be hidden from the accessibility system with:

```swift
.accessibilityHidden(true)
```

This keeps VoiceOver focused on relevant content.

### 3. Grouping Views for Better Reading

VoiceOver normally reads views individually. Group related views to make reading more natural.

#### Combine Children (pause between items)

```swift
VStack {
    Text("Your score is")
    Text("1000")
        .font(.title)
}
.accessibilityElement(children: .combine)
```

#### Ignore Children (single custom label)

```swift
VStack {
    Text("Your score is")
    Text("1000")
        .font(.title)
}
.accessibilityElement(children: .ignore)
.accessibilityLabel("Your score is 1000")
```

* **`.combine`** – Keeps children separate but read in sequence with a pause.
* **`.ignore`** – Hides children and replaces them with a custom label for smoother reading.

💡 **Tip:** `.ignore` is the default, so `.accessibilityElement()` works the same.

### Key Takeaways

* Use `Image(decorative:)` or `.accessibilityHidden(true)` for purely visual elements.
* Group related views to reduce navigation steps for VoiceOver users.
* Prefer `.ignore` with a custom label when you want text read as one smooth sentence.
* Always test with VoiceOver enabled to ensure a logical reading flow.

---

## Accessibility in SwiftUI – Custom Adjustable Actions

SwiftUI automatically provides VoiceOver readouts for UI controls, but sometimes the defaults aren’t ideal. For controls where the **value** changes but the **label** stays the same, we can use:

* ** `.accessibilityValue()`** – Separates the control’s current value from its label.
* ** `.accessibilityAdjustableAction()`** – Lets VoiceOver users adjust a value with swipe gestures.

### Problem

A basic custom stepper works fine with taps, but with VoiceOver it just reads `"Increment"` or `"Decrement"` each time — the actual value isn’t naturally accessible.

```swift
struct ContentView: View {
    @State private var value = 10

    var body: some View {
        VStack {
            Text("Value: \(value)")

            Button("Increment") { value += 1 }
            Button("Decrement") { value -= 1 }
        }
    }
}
```

### Solution – Grouping & Adjustable Actions

By grouping controls and attaching accessibility modifiers, VoiceOver can:

* Read the label **and** current value together.
* Allow swipe-up/swipe-down gestures to adjust the value directly.

```swift
VStack {
    Text("Value: \(value)")

    Button("Increment") { value += 1 }
    Button("Decrement") { value -= 1 }
}
.accessibilityElement()
.accessibilityLabel("Value")
.accessibilityValue(String(value))
.accessibilityAdjustableAction { direction in
    switch direction {
    case .increment:
        value += 1
    case .decrement:
        value -= 1
    default:
        print("Not handled.")
    }
}
```

### How It Works

* **`.accessibilityElement()`** – Treats the entire `VStack` as a single accessibility item.
* **`.accessibilityLabel("Value")`** – Provides the static label.
* **`.accessibilityValue(String(value))`** – Updates the spoken value dynamically.
* **`.accessibilityAdjustableAction { ... }`** – Responds to swipe gestures:

  * **`.increment`** – Swipe up to increase.
  * **`.decrement`** – Swipe down to decrease.
  * **`default`** – Required for any future directions Apple might add.

### Benefits

* VoiceOver reads `"Value, 10"` instead of just the button names.
* Users can adjust the value naturally with swipe gestures rather than finding multiple buttons.
* Cleaner, faster, and more intuitive navigation for accessibility users.

---

## Day 74 – Project 15, part 2

--- 

## Accessibility in SwiftUI – Supporting Voice Control Input

Once your app works well with **VoiceOver**, the next step is to ensure it also works smoothly with **Voice Control** — Apple’s speech-based control system. Voice Control lets users activate controls by speaking their 
names or numbers.


### How Voice Control Works

* Control names are generated automatically from visible text.
* Example:

```swift
Button("Tap Me") {
    print("Button tapped")
}
```

Users can say **"Press Tap Me"** to activate it.


### Problem

When button labels are long or formal (e.g., `"John Fitzgerald Kennedy"`), users might naturally say `"Tap Kennedy"` or `"Tap JFK"` instead — but by default, only the exact on-screen text works.


### Solution – Multiple Voice Input Labels

Use **`.accessibilityInputLabels()`** to provide alternative spoken phrases for a control.

```swift
Button("John Fitzgerald Kennedy") {
    print("Button tapped")
}
.accessibilityInputLabels([
    "John Fitzgerald Kennedy",
    "Kennedy",
    "JFK"
])
```

### Benefits

* Users can activate controls with **any** natural phrase you provide.
* Supports nicknames, abbreviations, and alternate spellings.
* Improves accessibility for **Voice Control power users**.

---

### Key Takeaways

* **Voice Control** is different from VoiceOver — it’s about **speech commands**.
* `.accessibilityInputLabels()` accepts an array of trigger phrases.
* Add as many phrases as needed to match real-world usage.

---

## Accessibility in SwiftUI – Fixing Guess the Flag for VoiceOver

In the original **Guess the Flag** game (from Project 2), users had to tap the correct flag out of three choices. However, there’s a **fatal flaw**:
By default, **SwiftUI uses the image’s filename as its VoiceOver label**, meaning VoiceOver users could simply move their finger over the flags and hear the country names — making the game trivial.


### Problem

* VoiceOver reads **image filenames** by default.
* Anyone using VoiceOver could identify the correct answer instantly.

### Solution – Add Descriptive Accessibility Labels

Instead of using country names directly, provide **descriptive, non-revealing** labels that help users recognize the flag if they’ve learned it, but don’t give away the answer.

#### 1. Create a Dictionary of Descriptions

```swift
let labels = [
    "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
    "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
    "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
    "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
    "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
    "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
    "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
    "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
    "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
    "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
    "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
]
```

#### 2. Apply `.accessibilityLabel()` to Each Flag

```swift
.accessibilityLabel(labels[countries[number], default: "Unknown flag"])
```

### How It Works

1. Uses `countries[number]` to get the current country name.
2. Looks up that name in the `labels` dictionary.
3. Falls back to `"Unknown flag"` if no match is found (safe default).

### Result

* VoiceOver users now hear **descriptive flag details** instead of the country name.
* The game remains challenging and fun for **all** players, regardless of accessibility needs.

---

## Accessibility in SwiftUI – Improving Word Scramble with VoiceOver

In **Project 5 – Word Scramble**, users make new words from a random eight-letter word.
While the game works with VoiceOver, the **reading experience** when adding words can be improved.


### Problem

When a new word is added, VoiceOver reads:

> `"five circle, image"` (for the letter count)
> *then separately*
> `"spill"` (the word itself)

This results in:

* Unnatural reading order.
* Extra elements for the user to navigate.


### Solution – Group & Customize VoiceOver Output

#### Original Code

```swift
Section {
    ForEach(usedWords, id: \.self) { word in
        HStack {
            Image(systemName: "\(word.count).circle")
            Text(word)
        }
    }
}
```

#### Improved Code – Single Label

Combine the image and text into **one accessibility element** with a natural label:

```swift
Section {
    ForEach(usedWords, id: \.self) { word in
        HStack {
            Image(systemName: "\(word.count).circle")
            Text(word)
        }
        .accessibilityElement()
        .accessibilityLabel("\(word), \(word.count) letters")
    }
}
```

### Alternative – Label + Hint

Use a label for the word and a hint for the letter count:

```swift
HStack {
    Image(systemName: "\(word.count).circle")
    Text(word)
}
.accessibilityElement()
.accessibilityLabel(word)
.accessibilityHint("\(word.count) letters")
```

### Result

VoiceOver now reads:

> `"spill, five letters"`

Benefits:

* More natural, concise reading.
* Single tap interaction for both parts of the UI element.
* Reduced cognitive load for VoiceOver users.

---


## Accessibility in SwiftUI – Improving Bookworm’s RatingView

In **Project 11 – Bookworm**, we built a `RatingView` UI component to display and set star ratings (1–5). While visually effective, it fails for VoiceOver users:


### Problem

* Each star is a separate button.
* VoiceOver reads `"favorite, button, favorite button, favorite button..."` without context.
* Users don’t get a sense that the stars **represent a single rating**.
* Since `RatingView` is reusable, this poor accessibility could be repeated across many projects.


### Solution – Two Approaches

#### **Approach 1 – Improve Individual Buttons**

Add an accessibility label for each star, plus a trait for selected stars:

```swift
.accessibilityLabel("\(number == 1 ? "1 star" : "\(number) stars")")
.accessibilityAddTraits(number > rating ? [] : [.isSelected])
```

✅ **Pros**

* Simple to implement.
* Builds on familiar `.accessibilityLabel()` and `.accessibilityAddTraits()`.

⚠️ **Cons**

* Still requires navigating multiple elements.

#### **Approach 2 – Optimal Grouped Control**

Instead of many elements, make the entire `HStack` one adjustable accessibility element:

```swift
.accessibilityElement()
.accessibilityLabel(label)
.accessibilityValue(rating == 1 ? "1 star" : "\(rating) stars")
.accessibilityAdjustableAction { direction in
    switch direction {
    case .increment:
        if rating < maximumRating { rating += 1 }
    case .decrement:
        if rating > 1 { rating -= 1 }
    default:
        break
    }
}
```

### How It Works

* **`.accessibilityElement()`** – Treats the whole rating control as one element.
* **`.accessibilityLabel(label)`** – Announces “Rating”.
* **`.accessibilityValue(...)`** – Announces the current star count naturally.
* **`.accessibilityAdjustableAction`** – Lets VoiceOver users swipe up/down to adjust the rating.


### Benefits of Approach 2

* Only one element to navigate.
* Clearer meaning of the control.
* Faster, more intuitive adjustments for VoiceOver users.
* Highly reusable and accessible in all projects.

---

