## Challenge Day 8 – UserBoard

A full-stack SwiftUI app challenge focused on **user authentication**, **cloud integration**, and **local data persistence**. The app allows users to **sign up or sign in**, and then displays a personalized dashboard showing their **username**, **sign-in date**, and the **total number of registered users** pulled from the Supabase backend.

---

## Features

* Email-based **user authentication** using **Supabase Auth**
* Profile creation and management using **Supabase tables**
* Public view of recent signups using a **Supabase SQL view**
* Secure data access using **Row Level Security (RLS) policies**
* Display of logged-in user's **username** and **sign-in timestamp**
* Real-time **user count** via Supabase queries
* Local data caching using **SwiftData** with `@Model` and `@Query`
* Filtering and sorting of local session data with **predicates** and **sort descriptors**
* Clean, reactive UI architecture using **SwiftUI** and `@Observable` view models
* **Network connectivity monitoring** to seamlessly switch between **online** and **offline modes**
* **User profile updates** with immediate UI refresh via **NotificationCenter** broadcasting

---

## Why This Challenge?

This challenge helped me:

* Integrate a **third-party authentication system** (Supabase) into a real-world SwiftUI app
* Set up and manage **user profiles and policies** in a backend database securely
* Decode and display complex backend data using custom `JSONDecoder` logic
* Use **Supabase SQL Views** and grant public access via policies for read-only content
* Model and query **local state** using **SwiftData’s declarative tools**
* Build a **clean MVVM architecture**, separating authentication, data, and UI logic
* Handle **navigation**, **asynchronous calls**, and **state management** in SwiftUI
* Combine **cloud data with local persistence** for smooth user experience regardless of connectivity
* Implement **network status monitoring** to detect online/offline state, enabling the app to:

  * Fetch fresh data from Supabase when online
  * Serve cached SwiftData user data when offline without losing app functionality
  * Avoid duplicate data caching by enforcing unique IDs and checking for existing cached records before insert
  
* Use **NotificationCenter** to broadcast profile update events on `currentUser` changes, enabling immediate and flicker-free UI refreshes without relying on view lifecycle events

---

## What I Learned

Building UserBoard helped me deepen my understanding of several key modern app development concepts:

* How to implement **user authentication** using Supabase Auth and manage secure sessions
* How to integrate and sync data between a **cloud backend (Supabase)** and local persistence layers
* How to enforce **data security** using Row Level Security (RLS) policies to restrict access
* How to design **offline-first apps** with SwiftData models that cache data locally and update smoothly
* How to build a **network-aware UI** that detects connectivity changes and switches data sources seamlessly
* How to use **NotificationCenter** to broadcast data changes and trigger immediate UI refreshes without flicker
* How to architect apps cleanly using the **MVVM pattern**, separating concerns clearly between models, view models, and views
* How to leverage **SwiftUI’s declarative and reactive UI** paradigms to create smooth, state-driven interfaces

These lessons form a solid foundation for tackling real-world challenges in building responsive, secure, and user-friendly iOS apps.

---

## Challenges and Problems Encountered

### 1. **Navigation After Authentication Using `navigationDestination`**

**Problem:**
`navigationDestination(for:)` allowed users to swipe back to login after signing in, which was undesirable.

**Solution:**
Switched to a root view pattern that shows either the auth or users list view based on auth state:

```swift
struct ContentView: View {
    @State var authVM = SupabaseAuthViewModel()

    var body: some View {
        Group {
            if authVM.currentUser == nil {
                AuthView(authVM: authVM)
            } else {
                UsersListView(authVM: authVM)
            }
        }
    }
}
```

### 2. **Invalid Email During Sign-Up**

**Problem:**
Supabase rejected sign-up emails as invalid.

**Solution:**
Disabling email confirmation in Supabase dashboard fixed this:

```swift
// No code change; toggle in Supabase Auth settings:
// Disable "Email Confirmations" to allow immediate sign-up without verification.
```

### 3. **Decoding Supabase Response Data**

**Problem:**
Using `JSONDecoder`’s built-in `.iso8601` date decoding strategy failed because Supabase timestamps include fractional seconds and timezone formatting that `iso8601` alone does not handle correctly.

**Solution:**
Implemented a custom `DateFormatter` to exactly match Supabase’s timestamp format and assigned it to the decoder’s date decoding strategy:

```swift
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"  // Matches "2025-07-11T18:18:45.537+00:00"
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.timeZone = TimeZone(secondsFromGMT: 0)

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .useDefaultKeys
decoder.dateDecodingStrategy = .formatted(formatter)

let profile = try decoder.decode(SupabaseProfileModel.self, from: data)
```

This fixed the date decoding errors and allowed your app to correctly parse the profile’s `created_at` timestamps.


### 4. **Centering the Navigation Bar Title Using a Custom Header**

**Problem:**
While trying to center the navigation bar title, we found that using `.navigationTitle()` combined with `.navigationBarTitleDisplayMode(.inline)` left the title aligned to the left by default. Attempts to center it using 
`.toolbar` with a `.principal` placement and adding padding didn’t work as expected — the padding had no visible effect, and the title remained too close to the edges.

UIKit’s `UINavigationBarAppearance` provides limited customization for inline titles, making it difficult to control exact positioning or add padding.

**Solution:**
To gain full control over the title’s position, font, and spacing, we created a custom header view that replaces the native navigation title entirely. This view centers the title text, applies custom styling, and adds a 
divider with adjusted color and opacity for a polished look:

```swift
struct CustomHeaderView: View {
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Divider()
                .background(Color.white.opacity(0.8))
        }
        .padding()
        .background(Color.black.opacity(0.5))
    }
}
```

Then place this `CustomHeaderView` at the top of your view hierarchy instead of relying on the navigation bar’s built-in title, giving you precise control over layout and style.

This approach avoids the limitations of the native navigation bar title system, ensuring the header text is centered and properly padded exactly as needed.


### 5: Duplicate Data When Offline

**Problem:**
When fetching user data from Supabase and caching it locally with SwiftData, duplicate entries appeared on repeated fetches, especially when offline.

* The caching logic inserted new `UserProfile` objects without checking if the user already existed in the local store.
* The unique identifier (`id`) wasn’t enforced as unique in the SwiftData model, allowing duplicates.

**Solution:**

* Marked the `id` property in `UserProfile` model with `@Attribute(.unique)` to enforce uniqueness.
* Before inserting cached data, performed a fetch using a predicate to check if the record already exists. Insert only if missing:

```swift
let fetchRequest = FetchDescriptor<UserProfile>(predicate: #Predicate { $0.id == user.id })

let existing = try context.fetch(fetchRequest)
if existing.isEmpty {
    let cached = UserProfile(id: user.id, username: user.username, created_at: user.createdAt)
    context.insert(cached)
}
```

### 6: No Data Showing When Offline

**Problem:**
When the app detected no internet connection, it failed to display any user data, despite local cache existing.

* The UI was only showing live data fetched from Supabase and not reading from the cached SwiftData storage during offline mode.

**Solution:**

* Added **network connectivity monitoring** with a `NetworkMonitorModel`.
* In the users list view, switched data source based on network status:

```swift
if networkMonitor.isConnected {
    UserListRowView(users: publicUserVM.users) // Live data from network
} else {
    UserListRowView(users: cachedUsers)       // Cached data from SwiftData
}
```

* Added a small offline mode notice to the UI for clarity.
```swift
   if !networkMonitor.isConnected {
        Text("You're in offline mode")
            .font(.caption)
            .foregroundColor(.yellow)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 5)
  }
```
* Wrapped fetch calls in `.task` modifiers and guarded network fetch with connectivity check to prevent failed network calls offline.

### 7: UI Not Updating Smoothly After Profile Change (Flashing/Stale Data)

**Problem:**

After updating the user profile (e.g., username), the UI welcome message updated correctly but the users list (`UserListRowView`) showed stale data or briefly flashed old content before updating.

* Directly relying on SwiftUI’s automatic state updates caused unwanted flickering.
* Using view lifecycle events like `.onDisappear` to refresh data caused awkward UI timing and potential delays.

---

**Solution:**

* Implemented a custom setter on the `currentUser` property in `SupabaseAuthViewModel` that:

  * Uses a private backing variable.
  * Checks if the username changed before notifying.
  * Posts a **NotificationCenter** event (`.userDidUpdate`) only on meaningful updates.

```swift
private var _currentUser: SupabaseProfileModel?

var currentUser: SupabaseProfileModel? {
    get { _currentUser }
    set {
        let oldValue = _currentUser
        _currentUser = newValue
        
        if oldValue?.username != newValue?.username {
            print("✅ currentUser changed: \(oldValue?.username ?? "nil") → \(newValue?.username ?? "nil")")
            NotificationCenter.default.post(name: .userDidUpdate, object: newValue)
        }
    }
}
```

* In the `UsersListView`, observe this notification and fetch updated user data immediately on notification reception:

```swift
.onAppear {
    NotificationCenter.default.addObserver(forName: .userDidUpdate, object: nil, queue: .main) { _ in
        Task { @MainActor in
            await publicUserVM.fetchRecentUsers(context: modelContext)
        }
    }
}
.onDisappear {
    NotificationCenter.default.removeObserver(self, name: .userDidUpdate, object: nil)
}
```

**Why NotificationCenter Helps:**

* **NotificationCenter** acts as a **central event bus** allowing different parts of the app to communicate decoupled from SwiftUI’s reactive bindings.
* When the `currentUser` changes meaningfully, posting a notification broadcasts this event globally.
* Any listener (like the users list view) can **respond immediately and independently** by refreshing data or updating UI.
* This approach **avoids issues with SwiftUI’s sometimes unpredictable state propagation and view lifecycle timing**.
* It makes updates explicit and precise, preventing UI flicker or stale content.

**Why This Works Better:**

* The notification system **decouples data changes from UI refreshes**, triggering updates exactly when data changes, not on view lifecycle.
* The setter avoids unnecessary updates by only notifying on meaningful data changes, preventing flicker.
* Fetching inside the notification handler happens promptly on the main thread, ensuring smooth UI refresh.
* Unregistering observers on disappear prevents duplicate calls or leaks.

This approach leads to **flash-free, immediate UI updates** reflecting backend changes seamlessly.


### 8: Update Message Not Showing Before Sheet Closes

**Problem:**
When the **Update Profile** button was tapped, the sheet closed immediately on success, not giving users time to see the result message (e.g., "✅ Updated!" or "⚠️ Failed to update").

* The `updateMessage` was being set inside the async `Task`, but `showEditProfile = false` executed too quickly afterward.
* As a result, the update message had no time to display before the sheet disappeared.

**Solution:**

* Introduced a **1-second delay** after a successful update to give users time to see the message.
* Moved the update result message into a separate `Text` view **outside the button** so it persists during the delay.
* Used conditional rendering with SwiftUI modifiers to style and transition the message.

```swift
Button {
    Task {
        isUpdating = true
        let result = await authVM.updateCurrentUserProfile(username: username)
        updateMessage = result ? "✅ Updated!" : "⚠️ Failed to update"
        isUpdating = false
        
        // Give time for user to read success before closing
        if result {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
            showEditProfile = false
        }
    }
} label: {
    Text(isUpdating ? "Updating..." : "Update Profile")
}
.buttonStyle(.borderedProminent)
.disabled(isUpdating || username.trimmingCharacters(in: .whitespaces).isEmpty)

// Show update result message
if let message = updateMessage, !isUpdating {
    Text(message)
        .foregroundColor(message.contains("✅") ? .green : .red)
        .font(.callout)
        .transition(.opacity)
}
```

Users now receive clear visual feedback when updating their profile, with the update message staying visible briefly before the sheet is dismissed — greatly improving the perceived responsiveness and clarity of the action.
