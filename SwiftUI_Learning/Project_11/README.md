# BookWormm

**BookWormm** is an iOS app that helps you track the books you've read and record your thoughts. This project is built as a continuation of prior learning, combining core SwiftUI techniques with powerful new tools like 
**SwiftData** and **custom UI components**.

---

## What You'll Learn

* How to use **SwiftData**, Apple’s modern database framework, to persist data.
* How to build a **custom star rating UI component**.
* How to use the `@Binding` property wrapper to pass data between views.
* How to structure SwiftUI apps using a clean and modular approach.

---

## What the App Does

* Allows users to add books they’ve read.
* Lets users leave a star rating and review for each book.
* Stores all data persistently using SwiftData.
* Demonstrates a reusable and tappable star rating view.

---

## Project Structure

```text
BookWormm/
├── Model/
│   └── Book.swift
├── Views/
│   └── AddBookView.swift
│   └── ContentView.swift
│   └── DetailView.swift
│   └── EmojiRatingView.swift
│   └── RatingView.swift
├── Assets.xcassets/
├── BookWormmsApp.swift
```

---

## Setup Notes

> ❗️When creating the project, **do not enable** SwiftData in the template options. This generates extra boilerplate code that we’ll remove manually to follow the project cleanly.

---

## Final Thoughts

This project was a valuable chance to explore SwiftData beyond the basics and uncover real-world quirks in data persistence and preview behavior.

Here's a reflection on a key problem encountered and how it was resolved:

### Problem: `@Query` Always Returning 0 in Previews

Despite inserting data, the `@Query` property wrapper returned an empty array in Xcode Previews — making it seem like the model wasn't working.

**Cause:**
Xcode Previews use an in-memory SwiftData context that starts empty every time and doesn’t persist data or reflect the app state from the simulator.

**Solution:**
The app was tested in the simulator, which uses the real model container and confirmed correct behavior. Additionally, to get realistic data in Previews, a mock model container was created with a sample `Book` inserted:

```swift
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)

    let context = container.mainContext
    let sample = Book(title: "Test", author: "Author", genre: "Fantasy", review: "Great!", rating: 5)
    context.insert(sample)

    return ContentView()
        .modelContainer(container)
}
```

This allowed the preview to display the correct book count and simulate real data without affecting the app’s persistent storage.

#### Data Persistance

**On the actual simulator or device**:
Your data is saved persistently on disk. When you add books, they stay there until you delete the app or reset the simulator. So your app remembers and shows the saved data across launches.

**In Xcode Previews**:
The data is kept only in-memory and temporary. Each time the preview refreshes or resets, it starts fresh with no saved data. That’s why you need to insert sample data manually in the preview code to see anything 
meaningful.
