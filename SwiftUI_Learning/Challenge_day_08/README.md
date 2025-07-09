# UserBoard

UserBoard is a simple but powerful SwiftUI app designed to help you learn real-world app development concepts by building a **user dashboard**. It allows users to sign up or sign in using **Supabase Auth**, and displays 
their **username**, **sign-in date**, and a count of total registered users. Local data is handled using **SwiftData** for smooth, offline-aware functionality.

---

## What You’ll Build

* A working **Sign Up / Sign In flow** using **Supabase Auth**
* A dynamic **user dashboard** showing:

  * Logged-in user’s username
  * Sign-in timestamp
  * Total number of users in the system
  
* A SwiftData-powered **local session list** using the `@Model` attribute for data models
* A clean, reactive **SwiftUI interface** driven by user state
* A foundational app structure that mirrors real-world architecture

---

## What You’ll Learn

* How to integrate **Supabase Auth** into a SwiftUI app
* How to fetch and post data to a **cloud-based database**
* How to securely manage and persist **user sessions**
* How to model and display local data using **SwiftData’s `@Model`** attribute
* How to use **predicates** and **sort descriptors** to filter and order data using **@Query**
* How to conditionally render views based on **auth state**
* How to separate your code into **models**, **view models**, and **views** for better maintainability

---

## Project Structure

```text
UserBoard/       
├── Models/
├── ViewModels/
├── Views/
│   └── ContentView.swift          # Entry point view handling state-based navigation
├── Assets.xcassets/              # App icons and design assets
└── UserBoardApp.swift            # Main app entry point
````

---

## Final Thoughts

UserBoard may look simple on the surface, but it teaches you some of the most essential building blocks of modern app development: **auth, cloud sync, local data, clean architecture, and SwiftUI fundamentals**. It's a 
perfect stepping stone toward building more complex apps like journals, habit trackers, or full admin dashboards.

---

