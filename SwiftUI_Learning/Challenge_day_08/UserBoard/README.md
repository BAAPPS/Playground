# Challenge Day 8 – UserBoard

A full-stack SwiftUI app challenge focused on **user authentication**, **cloud integration**, and **local data persistence**. The app allows users to **sign up or sign in**, and then displays a personalized dashboard 
showing their **username**, **sign-in date**, and the **total number of registered users** pulled from the Supabase backend.

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
* Learn to combine **cloud and local persistence** for a smooth, scalable app experience

---

## What I Learned

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

