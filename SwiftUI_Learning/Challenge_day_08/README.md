# UserBoard

UserBoard is a simple but powerful SwiftUI app designed to help you learn real-world app development concepts by building a **user dashboard**. It allows users to **sign up or sign in using Supabase Auth**, and displays their **username**, **sign-in date**, and a count of total registered users. Local data is optionally handled using **SwiftData** for offline-aware session tracking or state management.

---

## What You’ll Build

* A working **Sign Up / Sign In flow** using **Supabase Auth**
* A dynamic **user dashboard** showing:

  * Logged-in user’s **username**
  * **Sign-in timestamp**
  * **Total number of registered users**
* Integration with **Supabase tables** to store user profile data
* A read-only **public view** of recent signups using **Supabase Views**
* Controlled access using **Row Level Security (RLS) policies**
* A SwiftData-powered **local session list** using the `@Model` attribute for local storage
* A clean, reactive **SwiftUI interface** driven by observable user state
* A modular app architecture using **models**, **view models**, and **views**

---

## What You’ll Learn

* How to integrate **Supabase Auth** into a SwiftUI app using `supabase-swift`
* How to securely sign up users and write profile data to **Supabase tables**
* How to use **Row Level Security (RLS)** to restrict table access per user
* How to **read from public views** like `public_recent_users` to show recent signups
* How to model and display local data using **SwiftData’s `@Model`**
* How to filter and sort local data using `@Query`, **predicates**, and **sort descriptors**
* How to build UI that **reacts to authentication state**
* How to write clean, testable code using **MVVM principles** (models, view models, and views)

---

## Project Structure

```text
UserBoard/       
├── Models/
|   └── PublicUserModel.swift 
|   └── SupabaseClientModel.swift 
|   └── SupabaseProfileModel.swift 
|   └── UserProfile.swift 
├── Utils/
|   └── JSON-Decodable.swift 
├── ViewModels/
|   └── PublicUserViewModel.swift 
|   └── SupabaseAuthViewModel.swift 
|   └── SupabaseManager.swift 
├── Views/
│   └── AuthView.swift   
│   └── ContentView.swift 
│   └── UsersListView.swift       
├── Assets.xcassets/             
└── UserBoardApp.swift           
````

---

## Final Thoughts

UserBoard may look simple on the surface, but it teaches you some of the most essential building blocks of modern app development:

* **Authentication** with Supabase Auth
* **Cloud storage and syncing** via Supabase tables and views
* **Secure data access** with **Row Level Security (RLS)** policies
* **Local persistence** with SwiftData models
* **Modern architecture** using MVVM (Model–View–ViewModel)
* **Reactive, declarative UI** with SwiftUI

These skills mirror real-world scenarios — making this app a great stepping stone toward building more advanced apps like journals, habit trackers, user dashboards, or even fully authenticated admin panels.

