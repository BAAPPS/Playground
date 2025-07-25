# Challenge Day 10 – TrackBite

---

## Project Overview

TrackBite is a full-stack iOS app designed to simulate real-time catering delivery tracking. Built with SwiftUI and MapKit on the frontend and powered by Supabase on the backend, it enables users to explore key app 
development concepts like map annotations, driver movement simulation, offline-first data persistence, and cloud synchronization. The app models features found in popular services like Yelp and DoorDash, making it a 
practical and engaging learning project.

---

## Technologies Used

* **SwiftUI** — for building modern, declarative UI
* **MapKit** — to display maps, pins, and animate driver location
* **Supabase** — backend-as-a-service for data storage, authentication, and syncing
* **Swift Codable & FileManager** — for offline JSON data persistence
* **Network framework** — to detect connectivity and manage offline/online mode
* **Unsplash image links** — to fetch themed images without API keys

---

## Features

* Full-stack integration with Supabase backend
* Role-based users: drivers, customers, and admins
* Dynamic restaurant and order management
* Real-time driver movement simulation on maps
* Offline-first data persistence with local JSON files
* Network status detection and syncing between local and cloud data
* Clean MVVM architecture for scalable and maintainable code

---

## Why This Challenge?

I will gain hands-on experience integrating frontend map features with backend data services, managing offline-first persistence, and handling multi-user scenarios — essential skills for building robust, production-quality 
apps.

It’s designed to help me:

* Build confidence with real-world app architecture
* Understand syncing complexities between offline and online states
* Create interactive, map-based experiences that users love
* Practice role-based authentication and data access

---

## What I Learned

---

## Challenges and Problems Encountered

### 1. Problem: Attempting Cached Login with SwiftData Only

Initially, I tried to persist the logged-in user session using only **SwiftData** by saving the `LocalUser` object locally. While this approach preserved the data in the local store, it failed to provide a reliable session 
experience on app relaunch.

#### Issues:

* There was **no persistent session identifier** across launches.
* SwiftData doesn't support a built-in "current user" concept — it just stores data.
* On app restart, I had **no way of knowing which user was the active session** without additional context.
* Fetching all users and selecting one arbitrarily was **unreliable and unsafe**, especially when multiple users exist in the store.

#### ❌ Code Example: Unreliable SwiftData-only Attempt

```swift
@MainActor
func loadCachedUserFromSwiftDataOnly() {
    let descriptor = FetchDescriptor<LocalUser>()
    if let user = try? modelContext.fetch(descriptor).first {
        currentUser = user
    }
}
```

**Problem:** This fetches the *first* user it finds — not necessarily the one that was last logged in.


#### Solution: Combine SwiftData with UserDefaults

To solve this issue, I introduced a **hybrid solution**:

* **SwiftData** continues to store user information persistently.
* **UserDefaults** stores the `id` of the last logged-in user, acting as a session pointer.

This allowed me to reliably:

* Identify the correct user on relaunch.
* Maintain offline access to the session.
* Keep SwiftData lean and focused on data persistence, while UserDefaults handles quick-access session metadata.

##### ✅ Code Example: Stable Cached Session with ID Pointer

```swift
// Save the user's ID after login
UserDefaults.standard.set(user.id, forKey: "cachedUserID")

// Later, restore the correct user from SwiftData using the ID
@MainActor
func loadCachedUserFromID() {
    guard let cachedID = UserDefaults.standard.string(forKey: "cachedUserID") else {
        print("🟡 No cached user ID found")
        return
    }

    let descriptor = FetchDescriptor<LocalUser>(predicate: #Predicate { $0.id == cachedID })
    if let user = try? modelContext.fetch(descriptor).first {
        currentUser = user
        print("📦 Loaded cached user from SwiftData: \(user.email)")
    }
}
```

✅ **Result:** On every launch, I now reliably fetch the last active user. If the user exists in SwiftData and the cached ID is still valid, they are logged in automatically — creating a smooth, offline-friendly session experience.

---

## What I Would Do Differently
