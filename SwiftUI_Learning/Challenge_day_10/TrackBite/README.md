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

### 2. Problem: Inconsistent Navigation to Onboarding After Sign Up

During development, I encountered a confusing issue where **the app would sometimes skip the onboarding flow entirely and jump straight to the logged-in view**, even immediately after a user signed up. This behavior was 
inconsistent between the **Preview canvas** and the **iOS Simulator**, making debugging even trickier.

#### Symptoms:

* After successful sign-up, the app should show a tailored onboarding view based on the user’s role.
* In Preview, onboarding appeared correctly.
* In Simulator, it would skip onboarding and jump directly to the main `LoggedInView`.

#### Root Cause:

This behavior stemmed from my reliance on `localAuthVM.currentUser` alone to determine what to show:

```swift
if localAuthVM.currentUser != nil {
    LoggedInView(authVM: authVM)
} else {
    AuthSwitcherView(authVM: authVM)
}
```

Because the user was cached and loaded immediately after sign-up, `currentUser` was **already non-nil** before navigation occurred — **bypassing the onboarding logic** unintentionally.

Also:

* **Preview runs in a clean environment** — no persistent UserDefaults or SwiftData — so onboarding appeared as expected.
* **Simulator retains cached data** — so `currentUser` was restored immediately, skipping onboarding.

#### ❌ Problematic Logic (Before)

```swift
if localAuthVM.currentUser != nil {
    LoggedInView(authVM: authVM) // Gets shown even if onboarding not completed
}
```

#### Solution: Introduce Persistent Onboarding Completion Flag

To fix this, I added a `hasCompletedOnboarding` flag to `LocalAuthVM`, stored in `UserDefaults`. This boolean explicitly tracks whether the user has finished onboarding, giving me full control over the app’s flow.

```swift
var hasCompletedOnboarding: Bool {
    get { UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") }
    set { UserDefaults.standard.set(newValue, forKey: "hasCompletedOnboarding") }
}
```

Then I updated the view logic in `ContentView`:

##### ✅ Improved Flow Logic

```swift
if localAuthVM.currentUser != nil {
    if localAuthVM.hasCompletedOnboarding {
        LoggedInView(authVM: authVM)
    } else {
        OnboardingView(userRole: localAuthVM.currentUser!.role)
    }
} else {
    AuthSwitcherView(authVM: authVM)
}
```

Finally, after the user finishes onboarding, I set the flag:

```swift
localAuthVM.hasCompletedOnboarding = true
```

#### ✅ Result: Predictable, Role-Specific Flow

* Users are always taken to the correct onboarding screen after sign-up.
* App persists onboarding status across launches using `UserDefaults`.
* Clear separation between auth, onboarding, and main app views.
* Debugging is much easier because Preview and Simulator now behave consistently (once cache is cleared).


---

### 3. Problem: UUID Mismatch During Onboarding

**Issue:** During customer onboarding, the `id` used in `CustomerModel` did not match the `auth.uid()` from Supabase. This happened because the user ID from Supabase (`localAuthVM.currentUser?.id`) wasn't yet available 
when `ContentView` appeared, leading to a temporary `UUID()` being used instead.

**What went wrong:**

* `onAppear` ran too early, before the user was fully signed in.
* A new random UUID was incorrectly assigned, breaking RLS `WITH CHECK (auth.uid() = id)`.

**Solution:**
Used `onChange(of: localAuthVM.currentUser)` to defer logic until the user was actually available. This guaranteed the real `auth.uid()` was present before creating or updating the onboarding model.

```swift
.onChange(of: localAuthVM.currentUser) { _, _ in
    if let userIDString = localAuthVM.currentUser?.id,
       let userUUID = UUID(uuidString: userIDString) {
        customerVM = CustomerVM(customerModel: CustomerModel(id: userUUID, ...))
    }
}
```

This reactive approach ensured model updates were synced with Supabase's authenticated user ID.

---

### 4. Problem: Prop Drilling and State Management

**Issue:** As the app grew, onboarding and shared user state needed to flow through multiple view layers, leading to prop drilling — where props were passed down several levels unnecessarily.

**Solution:**
Adopted the new Swift 5.9+ data flow system using `@Observable` view models and `@Environment(...)` injection.

```swift
@Observable class CustomerVM { ... }

@main
struct TrackBiteApp: App {
    @State private var customerVM = CustomerVM(...)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(customerVM) // accessible app-wide
        }
    }
}
```

This eliminated the need to pass state manually through view hierarchies, making the codebase cleaner and more maintainable.

---

## What I Would Do Differently
