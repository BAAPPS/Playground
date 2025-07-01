# BookWormm Summary

---

## Day 53 – Project 11, part one

---

## Understanding `@Binding` in SwiftUI

SwiftUI gives us multiple ways to manage and share state across views. You’ve seen:

* `@State`: for managing simple, local value types in a view.
* `@Bindable`: for working with properties inside observable classes (used with `@Observable`).

Now meet ** `@Binding` **, a powerful property wrapper that enables **two-way data sharing** for simple value types like `Bool`, `Int`, `String`, and arrays between views.

### What is `@Binding`?

* `@Binding` creates a connection between two views so that **changes made in one place reflect in the other**.
* It’s commonly used in reusable UI components, like a toggle switch or a custom button, which need to modify state **owned by a parent view**.

#### Example:

```swift
@State private var rememberMe = false

var body: some View {
    Toggle("Remember Me", isOn: $rememberMe)
}
```

Here, `Toggle` uses a `@Binding` to mutate the value stored in the parent view's `@State`.

### ⚠️ Common Pitfall

If you pass a value directly instead of a binding, you get a **one-way data flow** — the child view won’t be able to update the parent’s state, resulting in inconsistent UI behavior.

### ✅ Fixing with `@Binding`

**Before (Broken):**

```swift
struct PushButton: View {
    let title: String
    @State var isOn: Bool // this causes a disconnect
}
```

**After (Fixed):**

```swift
struct PushButton: View {
    let title: String
    @Binding var isOn: Bool
}
```

**Usage:**

```swift
PushButton(title: "Remember Me", isOn: $rememberMe)
```

The dollar sign (`$`) passes a binding, not just the value.

### Two-Way Sync in Action

With `@Binding`, your custom components like `PushButton` can **stay in sync** with the parent view, ensuring a single source of truth.

This makes `@Binding` essential for building **interactive, reusable UI components** that need to reflect or mutate shared state.

---

## Multi-line Text Input in SwiftUI: `TextEditor` vs `TextField`

When collecting user input, SwiftUI offers two primary tools:

* `TextField`: Ideal for short, single-line inputs.
* `TextEditor`: Designed for longer, multi-line input like notes or comments.


### `TextEditor`: For Long-Form Text

`TextEditor` is a SwiftUI view that allows users to type **multi-line text** with a familiar, scrolling text box experience. It's simple to use and binds directly to a `String` via `@State` or `@AppStorage`.

#### Example:

```swift
struct ContentView: View {
    @AppStorage("notes") private var notes = ""

    var body: some View {
        NavigationStack {
            TextEditor(text: $notes)
                .navigationTitle("Notes")
                .padding()
        }
    }
}
```

> ⚠️ Note: `@AppStorage` is **not secure** – don't store private or sensitive data in it.

#### ✅ Benefits:

* Supports multiline input by default.
* Easy setup with minimal configuration.

#### ⚠️ Considerations:

* No built-in styling or placeholder support.
* Needs to be inside a `NavigationStack`, `Form`, or other layout to avoid layout issues (e.g., overlapping keyboard).

---

### `TextField` with `.vertical` Axis

SwiftUI's `TextField` has evolved: it now supports **dynamic expansion** along a vertical axis.

#### Example:

```swift
struct ContentView: View {
    @AppStorage("notes") private var notes = ""

    var body: some View {
        NavigationStack {
            TextField("Enter your text", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .navigationTitle("Notes")
                .padding()
        }
    }
}
```

#### Benefits:

* Starts compact and expands with content (similar to iMessage).
* Offers styling options like `.roundedBorder`.

### Which One Should You Use?

| Use Case        | Recommended View             |
| --------------- | ---------------------------- |
| Short input     | `TextField`                  |
| Expanding input | `TextField` with `.vertical` |
| Long-form notes | `TextEditor`                 |

Try both **inside and outside a `Form` **, as SwiftUI may render them differently depending on the container.

---

## What Is SwiftData?

* A persistence framework that replaces Core Data for many apps.
* Works with custom models using the `@Model` macro.
* Supports advanced features like **iCloud sync**, **sorting/filtering**, **lazy loading**, and **undo/redo**.
* Integrates beautifully with SwiftUI via property wrappers and environment integration.


## Step-by-Step Setup

### 1. Define a SwiftData Model

```swift
import SwiftData

@Model
class Student {
    var id: UUID
    var name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
```

> ✅ `@Model` makes your class storable, observable, and queryable with minimal boilerplate.


### 2. Configure SwiftData in Your App Entry Point

In `BookwormApp.swift`:

```swift
import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Student.self)
    }
}
```

> 🔒 A `modelContainer` is where your app’s data is stored and accessed from.

### 3. Querying Data in SwiftUI

In `ContentView.swift`:

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var students: [Student]

    var body: some View {
        NavigationStack {
            List(students) { student in
                Text(student.name)
            }
            .navigationTitle("Classroom")
        }
    }
}
```

> `@Query` dynamically reflects the current data — updates in real time as data changes.


### 4. Adding Data with `modelContext`

To insert new data:

```swift
@Environment(\.modelContext) var modelContext

.toolbar {
    Button("Add") {
        let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
        let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]

        let student = Student(
            id: UUID(),
            name: "\(firstNames.randomElement()!) \(lastNames.randomElement()!)"
        )

        modelContext.insert(student)
    }
}
```

>  `modelContext` is the live interface to your app’s data. Insertions are automatically saved and persisted across app launches.


### Recap

| Concept                        | Purpose                                                |
| ------------------------------ | ------------------------------------------------------ |
| `@Model`                       | Defines a data object for persistence                  |
| `.modelContainer()`            | Configures storage at the app level                    |
| `@Query`                       | Automatically keeps views in sync with data            |
| `@Environment(\.modelContext)` | Interface to insert, delete, and manage data in memory |

---

## Day 54 – Project 11, part two

---

## Adding Books with SwiftData

### 1. Define the Book Model

Create `Book.swift`:

```swift
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int

    init(title: String, author: String, genre: String, review: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
}
```

* The model stores key book details: title, author, genre, user review, and rating.
* Use Xcode’s autocomplete to generate the initializer quickly.

### 2. Configure SwiftData Model Container

In `BookwormApp.swift`:

```swift
import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
```

### 3. Build the AddBookView Form

Create `AddBookView.swift` with:

* `@Environment(\.modelContext)` to access SwiftData.
* `@State` properties for all book fields.
* A list of genres for the picker.

```swift
struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var rating = 3

    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) { Text($0) }
                    }
                }

                Section("Write a review") {
                    TextEditor(text: $review)

                    Picker("Rating", selection: $rating) {
                        ForEach(0..<6) { Text(String($0)) }
                    }
                }

                Section {
                    Button("Save") {
                        let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add Book")
        }
    }
}
```

### 4. Update ContentView to Present AddBookView

In `ContentView.swift`:

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var books: [Book]

    @State private var showingAddScreen = false

    var body: some View {
        NavigationStack {
            Text("Count: \(books.count)")
                .navigationTitle("Bookworm")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                        } label: {
                            Label("Add Book", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView()
                }
        }
    }
}
```

* Tracks the number of books with `@Query`.
* Shows a toolbar button to present the add book sheet.
* Presents `AddBookView` modally.


### 5. How It Works

* The form collects all necessary book information.
* Pressing **Save** creates a new `Book` object and inserts it into SwiftData’s model context.
* The form dismisses automatically.
* The book count updates dynamically in the main view.


The SwiftData persistent storage only works on a real simulator or device. In Xcode Previews, the data is kept in-memory and resets every time the preview refreshes, so you won’t see saved data persist or update reliably 
there.

So to test Bookwormm app with real data persistence:

* Run it in the iOS Simulator (not just Preview)or run it on a physical iPhone or iPad.

That way, when you add books, they’ll be saved on disk and remain available across app launches.

Previews are great for UI layout and quick design tweaks, but for testing actual data saving/loading, a full run on a simulator or device is necessary.

---

## Building a Custom Star Rating View in SwiftUI

SwiftUI makes creating custom UI components easy by exposing `@Binding` properties that allow two-way data flow.

### Overview

We’ll create a flexible **`RatingView`** that lets users select a rating from 1 to a configurable maximum by tapping star images (or any custom image).

### Key Features

* Customizable label text (default: empty)
* Configurable maximum rating (default: 5)
* Customizable images for “off” (unselected) and “on” (selected) states
* Customizable colors for “off” and “on” stars
* A binding integer property to report the current rating back to the parent view

### Properties for `RatingView`

```swift
@Binding var rating: Int

var label = ""
var maximumRating = 5

var offImage: Image?
var onImage = Image(systemName: "star.fill")

var offColor = Color.gray
var onColor = Color.yellow
```

### Preview Setup

SwiftUI previews require a **constant binding** to provide a fixed rating value:

```swift
#Preview {
    RatingView(rating: .constant(4))
}
```

### Image Selection Logic

Encapsulate image selection in a helper method:

```swift
func image(for number: Int) -> Image {
    if number > rating {
        offImage ?? onImage
    } else {
        onImage
    }
}
```

#### Purpose

The `image(for:)` method decides **which image to show for each star position** based on the current rating.

#### Parameters

* `number: Int` — The star’s position/index (1, 2, 3, … up to max rating).

#### Logic

* If the star’s number is **greater than the current rating** (meaning it’s “off” or unselected):

  * Return `offImage` if it exists.
  * Otherwise, fall back to `onImage` (so there’s always something shown).
* If the star’s number is **less than or equal to the current rating** (meaning it’s “on” or selected):
  * Return `onImage`.

#### Why do this?

* This lets you customize what images represent selected vs unselected stars.
* The fallback ensures you don’t end up with empty or missing images.
* By encapsulating this logic in a method, your `body` stays clean and easy to read.

#### Example

If `rating` is 3, then for stars:

* `1, 2, 3` → returns `onImage` (highlighted star)
* `4, 5` → returns `offImage` (dimmed or empty star)

In short, this helper method controls the star icon appearance based on whether the star should be “filled” or “empty” given the current rating.


### Body Implementation

Create a horizontal stack showing an optional label and tappable star buttons:

```swift
HStack {
    if !label.isEmpty {
        Text(label)
    }

    ForEach(1..<maximumRating + 1, id: \.self) { number in
        Button {
            rating = number
        } label: {
            image(for: number)
                .foregroundStyle(number > rating ? offColor : onColor)
        }
    }
}
.buttonStyle(.plain) // IMPORTANT: prevents row tap interference in Forms/Lists
```

### Important Note: Fixing Tap Behavior

When used inside a `Form` or `List`, SwiftUI’s default behavior can cause **all buttons to be tapped at once**, resulting in the rating always being set to the max.

Add `.buttonStyle(.plain)` to the outer `HStack` to fix this by making each button respond independently.

### Using `RatingView` in a Form

Example snippet replacing a section in `AddBookView`:

```swift
Section("Write a review") {
    TextEditor(text: $review)
    RatingView(rating: $rating)
}
```

---

## Displaying Books with Custom Emoji Ratings

Now that we've stored books in SwiftData, it's time to visualize them with a list and add a fun custom rating display using emojis.


### Step 1: Replace the Count Label with a List

Previously, `ContentView` used a basic text view:

```swift
@Query var books: [Book]
Text("Count: \(books.count)")
```

We’ll replace this with a **`List` of books**, showing each book’s title, author, and an emoji representing its rating.

---

### Step 2: Create `EmojiRatingView`

Make a new SwiftUI view to show an emoji based on a book’s rating:

```swift
struct EmojiRatingView: View {
    let rating: Int

    var body: some View {
        switch rating {
        case 1: Text("😡")
        case 2: Text("😕")
        case 3: Text("😐")
        case 4: Text("🙂")
        default: Text("🤩")
        }
    }
}

#Preview {
    EmojiRatingView(rating: 3)
}
```

### Step 3: Use It in `ContentView`

Replace the old count `Text` view with the following `List`:

```swift
List {
    ForEach(books) { book in
        NavigationLink(value: book) {
            HStack {
                EmojiRatingView(rating: book.rating)
                    .font(.largeTitle)

                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.headline)
                    Text(book.author)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
```

This:
* Shows each book with its title and author
* Adds a custom emoji rating for quick visual feedback
* Wraps each row in a `NavigationLink` (we’ll connect it to a detail view soon)

> ⚠️ Keep your `.navigationTitle()` and `.toolbar()` modifiers — this replaces only the body content, not the whole view structure.

---

## Day 55 – Project 11, part three

---

## Detail View for Books

When a user taps a book in the list, we’ll present a detailed screen showing more information, including genre artwork, review text, and a read-only star rating. This demonstrates SwiftUI's view composition and SwiftData preview handling.

### Step 1: Add Genre Artwork

Download the `project11-files` image assets (from Unsplash) and import them into your asset catalog. Each genre should have a matching image named exactly like its genre string (e.g. `"Fantasy"` → `Fantasy.jpg`).

> 💡 Attribution is not required, but appreciated. All artwork is freely licensed via [Unsplash](https://unsplash.com).

### Step 2: Create `DetailView`

Create a new SwiftUI view called:

```swift
struct DetailView: View {
    let book: Book
}
```
### Step 3: Build SwiftData-Compatible Previews

SwiftData requires a model context to safely instantiate models. Here’s how to create a **temporary, in-memory model container** for previews:

```swift
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(
            title: "Test Book",
            author: "Test Author",
            genre: "Fantasy",
            review: "This was a great book; I really enjoyed it.",
            rating: 4
        )

        return DetailView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
```

### Step 4: Design the Detail UI

Replace the `body` with this layout:

```swift
ScrollView {
    ZStack(alignment: .bottomTrailing) {
        Image(book.genre)
            .resizable()
            .scaledToFit()

        Text(book.genre.uppercased())
            .font(.caption)
            .fontWeight(.black)
            .padding(8)
            .foregroundStyle(.white)
            .background(.black.opacity(0.75))
            .clipShape(.capsule)
            .offset(x: -5, y: -5)
    }

    Text(book.author)
        .font(.title)
        .foregroundStyle(.secondary)

    Text(book.review)
        .padding()

    RatingView(rating: .constant(book.rating)) // Read-only
        .font(.largeTitle)
}
.navigationTitle(book.title)
.navigationBarTitleDisplayMode(.inline)
.scrollBounceBehavior(.basedOnSize)
```

> ℹ️ `RatingView` uses `.constant()` to make it non-editable while still showing stars.

### Step 5: Wire Up Navigation in `ContentView`

Finally, update your `List` in `ContentView.swift` to present `DetailView` using:

```swift
.navigationDestination(for: Book.self) { book in
    DetailView(book: book)
}
```

---

## Sorting Data with `@Query` in SwiftData

SwiftData's `@Query` property wrapper lets you **sort your data directly at the point of retrieval** — ensuring a consistent, predictable experience for users. 

- You can sort by one or more fields, such as title, author, or rating.


### ✅ Option 1: Simple One-Field Sort

Use this when you only need a single sort criterion.

#### Example: Sort alphabetically by title

```swift
@Query(sort: \Book.title) var books: [Book]
```

#### Example: Sort by rating (highest to lowest)

```swift
@Query(sort: \Book.rating, order: .reverse) var books: [Book]
```

> ✅ Best for quick, basic sorts.

### ✅ Option 2: Multiple-Field Sort with `SortDescriptor`

For more advanced control, use an array of `SortDescriptor` values.

#### Example: Sort by title, then author

```swift
@Query(sort: [
    SortDescriptor(\Book.title),
    SortDescriptor(\Book.author)
]) var books: [Book]
```

#### Example: Sort by rating (descending), then title (ascending)

```swift
@Query(sort: [
    SortDescriptor(\Book.rating, order: .reverse),
    SortDescriptor(\Book.title)
]) var books: [Book]
```

> 💡 Sorting is **ascending by default** unless you set `.reverse`.

### Why Use Multi-Field Sorting?

* Adds **predictability** for users
* Helps with **tiebreakers** (e.g. two books with the same title)
* Has **minimal performance impact** for small datasets

### 📌 Best Practices

* Always specify **at least one sort field**.
* Consider adding a **secondary sort field** (like author or title).
* Keep user expectations in mind: A list sorted by rating should still be consistent when ratings are the same.

---

## Deleting SwiftData Items in a SwiftUI List

SwiftData integrates beautifully with SwiftUI's list deletion tools. With just a few steps, you can enable **swipe to delete** and an **Edit/Done toggle** for your `@Query`-powered list.

### Step 1: Add a Delete Function

You need to locate the right `Book` in your query result and delete it using the `modelContext`.

```swift
func deleteBooks(at offsets: IndexSet) {
    for offset in offsets {
        let book = books[offset]
        modelContext.delete(book)
    }
}
```

> ✅ SwiftData will **autosave** changes after deletion — no extra code needed!


### Step 2: Attach `.onDelete()` to `ForEach`

To make this work, place `.onDelete(perform:)` **on the `ForEach`, not the `List`**.

```swift
List {
    ForEach(books) { book in
        NavigationLink(value: book) {
            // your book row UI
        }
    }
    .onDelete(perform: deleteBooks)
}
```

### Step 3: Add the Edit/Done Button

Inside your `.toolbar`, insert the `EditButton()` so users can delete multiple books via the Edit mode.

```swift
.toolbar {
    ToolbarItem(placement: .topBarLeading) {
        EditButton()
    }

    ToolbarItem(placement: .topBarTrailing) {
        Button("Add Book", systemImage: "plus") {
            showingAddScreen.toggle()
        }
    }
}
```

### 📌 Recap

| Feature             | Code Involved                      |
| ------------------- | ---------------------------------- |
| Delete from context | `modelContext.delete(book)`        |
| Trigger deletion    | `.onDelete(perform:)` on `ForEach` |
| Enable edit mode    | `EditButton()` in toolbar          |

---

## Deleting a SwiftData Item from DetailView in SwiftUI

Sometimes it’s not enough to delete from a list — you also want to let users **delete an item directly from its detail screen**, and then **automatically go back**. SwiftUI makes this clean and simple using `@Environment`, 
`@State`, and an `.alert()` modifier.

### Step 1: Add Required Properties

In your `DetailView`, you need three things:

```swift
@Environment(\.modelContext) var modelContext     // so we can delete
@Environment(\.dismiss) var dismiss               // so we can go back
@State private var showingDeleteAlert = false     // show confirmation alert
```

### Step 2: Write the Delete Function

This removes the book from SwiftData and **programmatically dismisses** the current view:

```swift
func deleteBook() {
    modelContext.delete(book)
    dismiss()
}
```

Even though the view was shown using `NavigationLink`, `dismiss()` works the same as with a `.sheet()`.

### ⚠️ Step 3: Add a Confirmation Alert

This shows a prompt before deleting. Add it to your `ScrollView`:

```swift
.alert("Delete book", isPresented: $showingDeleteAlert) {
    Button("Delete", role: .destructive, action: deleteBook)
    Button("Cancel", role: .cancel) { }
} message: {
    Text("Are you sure?")
}
```

> 💡 Apple recommends using clear, **verb-based** labels like “Delete” and “Cancel”, not just “Yes” or “No”.

### Step 4: Add a Toolbar Button to Trigger Alert

Still inside the `ScrollView`, add a trash button to show the alert:

```swift
.toolbar {
    Button("Delete this book", systemImage: "trash") {
        showingDeleteAlert = true
    }
}
```

### Recap

| Feature                      | Code Element                       |
| ---------------------------- | ---------------------------------- |
| Access model context         | `@Environment(\.modelContext)`     |
| Programmatic back navigation | `@Environment(\.dismiss)`          |
| Show confirmation dialog     | `.alert(...)` with two buttons     |
| Trigger deletion             | `.toolbar` button + `deleteBook()` |

---

## Day 56 – Project 11, part four

---

## Challenge

1. **Fix missing or empty book details:**  
   Currently, it’s possible to create books without a title, author, or genre, which causes issues in the detail view. 
   
   The challenge is to handle this gracefully by either:
   - Forcing default values,  
   - Validating input before saving, or  
   - Showing a default image for unknown genres.

2. **Highlight low-rated books:**  
   Modify the `ContentView` so that books rated 1 star are visually distinct, such as displaying their titles in red.

3. **Add a "date" attribute to books:**  
   Add a new `date` property to the `Book` model. When creating a new book, assign `Date.now` to it, then format and display this date nicely in the detail view.


### Solution Overview

- **Handling missing book details:**  
  Added default values in the `Book` model or validated input in the add-book form. Also included a default genre image for unknown or empty genres to avoid crashes or empty UI.

* **Highlighting books by rating:**
  Updated the `ContentView` list to color-code book titles based on their rating.
  
  * 1-star books are shown in **red** (poor rating)
  * 2-star books in **orange** (below average)
  * 3-star books in **yellow** (average)
  * 4-star books in **green** (good)
  * 5-star books in **blue** (excellent)
    
 This helps visually communicate the quality of each book at a glance.

- **Adding and displaying the date:**  
  Added a `date` property to the `Book` class initialized with `Date.now` in the initializer.  
  In the `DetailView`, formatted the date using a `DateFormatter` and displayed it in the bottom-left corner of the book image, styled similarly to the genre label.

#### Key Code Snippets

##### Validate missing or empty book details

**AddBookView**

```swift
    let safeTitle = title.isEmpty ? "Unknown Title" : title
    let safeAuthor = author.isEmpty ? "Unknown Author" : author
    let safeGenre = genre.isEmpty ? "Unknown Genre" : genre
    
    Section {
        Button("Save") {
            let newBook = Book(title: safeTitle, author: safeAuthor, genre: safeGenre, review: review, rating: rating, date: Date.now)
            modelContext.insert(newBook)
            dismiss()
        }
    }
```

**Default genre image for unknown or empty genres**

```swift
var genreImageName: String {
    if UIImage(named: book.genre) != nil {
        return book.genre
    } else {
        return "DefaultGenre"
    }
}
```

##### ContentView (color-code book rating titles):

```swift
func bookRatingColor(rating: Int) -> Color {
        switch rating {
        case 1: return .red          // Poor rating - urgent/warning
        case 2: return .orange       // Below average - caution
        case 3: return .yellow       // Average - neutral/warning but less urgent
        case 4: return .green        // Good rating - positive
        case 5: return .blue         // Excellent - calm and trustworthy
        default: return .gray        // Default/fallback color
        }
}
    
Text(book.title)
    .foregroundColor(bookRatingColor(rating: book.rating))
```

##### DetailView (date display):

**Book Model (with date)**

```swift
@Model
class Book {
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var date: Date

    init(title: String, author: String, genre: String, review: String, rating: Int, date: Date = Date.now) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
        self.date = date
    }
}
````

**Display date**

```swift

var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: book.date)
}
    
ScrollView {
    ZStack {
        Image(book.genre)
            .resizable()
            .scaledToFit()

        Text(book.genre.uppercased())
            .font(.caption)
            .fontWeight(.black)
            .padding(8)
            .foregroundStyle(.white)
            .background(.black.opacity(0.75))
            .clipShape(.capsule)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .offset(x: -5, y: -5)

        Text(formattedDate)
            .font(.caption)
            .fontWeight(.black)
            .padding(8)
            .foregroundStyle(.white)
            .background(.black.opacity(0.75))
            .clipShape(.capsule)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .offset(x: 5, y: -5)
    }
    // other UI elements...
}
```


