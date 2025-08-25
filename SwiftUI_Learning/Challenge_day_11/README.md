# **DramaBox**

A SwiftUI learning project where we build a **TVB drama library app** from scratch — starting from retrieving data via a web scraper to building a feature-rich, offline-capable SwiftUI app with database integration.

---

## **What You’ll Build**

DramaBox is a multi-tab SwiftUI app that:

* Retrieves **TVB show data** from `https://tvbanywherena.com/english`.
* Displays it in a **custom tab-based UI** with filtering, sorting, and search.
* Integrates with **Supabase** for cloud data storage and syncing.
* Supports **offline mode** using SwiftData and local JSON files via FileManager.
* Allows **swipe actions** for marking favorites and deleting items.
* Sends **local notifications** when new content is available.

**Key features at a glance:**

* Multi-tab navigation with `TabView`
* Remote + local database support
* Offline caching and reading
* Filtering & sorting UI
* Notifications for updates
* Swipe gestures in list views

---

## **What You’ll Learn**

This challenge project covers a wide range of iOS development concepts:

### **Networking & Data Handling**

* Using `URLSession` to fetch raw HTML data.
* Parsing HTML with **SwiftSoup**.
* Structuring data models for shows, episodes, and categories.
* Implementing the `Result` type for success/failure handling in network calls.

### **UI & Navigation**

* Building a **tab-based app** with `TabView`.
* Designing dynamic `List` views with swipe actions.
* Creating filtering and sorting menus.
* Implementing search functionality in SwiftUI.

### **Persistence & Offline Mode**

* Using **Supabase** to store and retrieve TVB library data.
* Storing fetched data locally with **SwiftData**.
* Saving fallback JSON files via **FileManager** for offline mode.

### **User Interaction**

* Handling swipe actions to mark favorites or delete shows.
* Sending **local notifications** when new shows are added or marked as favorites.

---

## **Project Structure**

```text
DramaBox/
├── Models/                 # Data structures (Show, Episode, Category, etc.)
├── ViewModels/              # Business logic & state management (fetch, filter, sort)
├── Views/                   # SwiftUI views (LibraryView, FavoritesView, SettingsView)
├── Assets.xcassets/         # App images & icons
├── Persistence/             # SwiftData models & FileManager helpers
├── Services/                # Networking, Supabase API, and HTML parsing
└── DramaBoxApp.swift        # App entry point
```
---

## **Final Thoughts**

DramaBox isn’t just an app — it’s a **hands-on SwiftUI bootcamp** packed into one project. By the end, you’ll have:

* Mastered **data fetching**, **parsing**, and **persistence** in Swift.
* Learned to handle **offline capabilities** gracefully.
* Built a real-world multi-tab SwiftUI app with swipe actions, notifications, and search.
* Created a clean and scalable project structure you can reuse for future apps.

---
