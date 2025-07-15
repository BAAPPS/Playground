# Challenge Day 9 – SplashEdit

SplashEdit is a full-stack SwiftUI challenge project that blends creative image editing with modern backend integration and robust offline-first architecture. Users can explore photos from Unsplash, apply stunning Core 
Image filters, and save both filtered and original images locally with SwiftData. All content is securely synced to the cloud using Supabase, complete with user authentication, secure access policies, and personalized 
features like favorites and collections. Whether online or offline, SplashEdit delivers a seamless experience that combines artistry, data management, and scalable cloud connectivity — making it the perfect real-world 
challenge to level up your iOS development skills.

---

## Features

* Email-based **user authentication** via **Supabase Auth**
* Secure, user-specific access using **Row Level Security (RLS) policies**
* Public view of recent signups using a **Supabase SQL view**
* Display of signed-in user's **username**, **email**, and **sign-in timestamp**
* **Unsplash API integration** to fetch high-quality, searchable images
* Apply **Core Image filters** with real-time preview and save both filtered and original versions
* Store images and metadata **locally with SwiftData** using `@Model` and `@Query`
* Sync saved images and metadata to **Supabase Storage** and **Postgres**
* Save **likes** and create a **personal collection** of favorites across sessions
* View and manage liked photos in a dedicated **"My Collection"** screen
* **Offline-first design**: all data is available offline, syncing resumes when network is restored
* Real-time **user count** and global data view using Supabase queries
* **Reactive UI** architecture using `@Observable` view models and **SwiftUI**
* Filtering and sorting of local photo data with **predicates** and **sort descriptors**
* Automatic **profile updates** across views via **NotificationCenter** broadcasting
* **Network monitoring** to dynamically adapt between online and offline states

---

## Why This Challenge?

This challenge goes beyond local app development — it introduces real-world skills like:

* Building **offline-resilient apps**
* Creating **photo editing tools** using Core Image
* Syncing between **local and cloud storage**
* Working with **RESTful APIs** (Unsplash) and **Postgres SQL** (Supabase)
* Designing for **user personalization** (likes, filtered versions, collections)
* Managing **authentication, secure access**, and **live user data**

It’s not just a coding exercise — it’s a real app foundation.

---

## What I Learned


---

## Challenges and Problems Encountered

### 1. `ContentUnavailableView` Not Displaying Inside `ScrollView`

**Problem:**
When attempting to show a `ContentUnavailableView` to indicate that no photos were available (`photoVM.photos.isEmpty`), the view did not appear as expected. This happened even though the condition was met and the array was empty.

**Root Cause:**
`ScrollView` does not automatically fill all available vertical space, which means placing a `Spacer()` before the `ContentUnavailableView` won’t push it to the vertical center unless it's wrapped in a parent container that enforces layout stretching (e.g. a `VStack` with `frame(maxHeight: .infinity)` or an outer `ZStack`).

**Solution:**
To ensure that the placeholder view appeared and was vertically centered, we had to wrap the content in a `VStack` and give it an explicit `frame` to expand and fill space. Here's the corrected approach:

```swift
if photoVM.photos.isEmpty {
    VStack {
        Spacer()
        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus")
            .font(.title) // optional size tweak
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
```

Alternatively, using a `ZStack` to overlay the view on an empty scroll view works as well:

```swift
ZStack {
    if photoVM.photos.isEmpty {
        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else {
        ScrollView {
            LazyVStack {
                // display photos
            }
        }
    }
}
```

This ensures proper layout and visual feedback even when the data is missing.


### 2. Auth Switcher View: Handling Offline Mode and Refresh Token Reset

**Problem:**
The app needed to maintain user authentication state across app restarts and network interruptions. Initially, when the device was offline, the app failed to persist the logged-in state and would revert to the login screen 
because the session refresh failed without a network connection.

Additionally, managing refresh tokens securely and resetting the session upon token expiration was challenging.

**Root Cause:**

* Supabase authentication sessions require valid refresh tokens to restore the session.
* When offline, trying to refresh the token fails, causing the app to lose the user state.
* Refresh tokens were stored in `UserDefaults` for simplicity during development, which is not secure and can lead to inconsistent state.
* The app lacked proper fallback logic to use cached user data when offline.

**Solution:**

* Implemented a network monitor using `NWPathMonitor` to detect connectivity status.
* Modified the session restore logic to:

  * Check network connectivity before attempting token refresh.
  * If offline, load cached user data from local storage (`UserDefaults`) instead of refreshing tokens.
  * If online, refresh the session and update tokens accordingly.
* Added error handling to clear tokens and log out the user when refresh tokens become invalid or expired.
* Plan to migrate refresh token storage to iOS Keychain for enhanced security in production.

**Code Snippet:**

```swift
func restoreSession() async {
    print("🔁 Attempting to restore session...")
    
    if !networkMonitor.isConnected {
        print("⚠️ Offline: loading cached user without refreshing session")
        if let cachedUser = loadCachedUser() {
            currentUser = cachedUser
        }
        return
    }

    guard let refreshToken = UserDefaults.standard.string(forKey: "supabase_refresh_token") else {
        print("🚫 No refresh token found")
        return
    }

    do {
        let session = try await client.auth.refreshSession(refreshToken: refreshToken)
        print("✅ Session restored for: \(session.user.email ?? "unknown")")

        // Fetch user data and cache
        ...
        UserDefaults.standard.set(session.refreshToken, forKey: "supabase_refresh_token")
    } catch {
        print("❌ Failed to refresh session: \(error.localizedDescription)")
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: "supabase_refresh_token")
        UserDefaults.standard.removeObject(forKey: userDefaultKey)
    }
}
```

With these improvements, the app gracefully handles offline scenarios by showing the cached user state and only attempts token refresh when the network is available. It also properly resets the session and cleans up tokens 
on authentication failure, improving reliability and user experience.

