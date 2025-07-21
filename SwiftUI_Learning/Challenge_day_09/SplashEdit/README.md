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

### 3. Info Button Missing on Swipe Cards

**Problem:**

In the Tinder-style swipe stack (`TinderStackView`), an `info.circle` button was intended to appear only on the topmost photo card. However, the button was inconsistently missing, even when a photo was visually on top — 
especially after swiping some cards away.

This broke the expected user experience and made it unclear how to access the photo's details.

### Root Cause:

The code used to determine which photo was the top card relied on this logic:

```swift
let isTopPhoto = index == photos.count - 1
```

This assumption works **only if**:

* The stack is static, and
* No cards are removed

But in a dynamic swipe view where photos are constantly removed (`remove(photo)`), the indices shift, and the logic can fail to mark the **visually top card** as the top one in data. This causes the button to disappear from the card currently on top of the screen.

Moreover, SwiftUI doesn’t automatically guarantee Z-stack layering by `ForEach` order — without explicit `zIndex()` management, view stacking becomes inconsistent.

---

### 🔴 Before: Problematic Code (Broken Overlay Logic)

```swift
ZStack {
    ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
        let isTopPhoto = index == photos.count - 1 // ❌ not reliable after removal

        PhotoSwipeView(photo: photo) {
            remove(photo)
        }
        .overlay(
            isTopPhoto ?
            VStack {
                HStack {
                    Spacer()
                    Button {
                        selectedPhoto = photo
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                Spacer()
            }
            .offset(x: -100)
            : nil // ❌ overlay disappears when top photo is misidentified
        )
        .frame(width: parentSize.width, height: parentSize.height)
        // ⚠️ No zIndex set – view layering not controlled
    }
}
```

### ✅ After: Fixed Solution with `zIndex` + ID Match

```swift
ZStack {
    ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
        let isTopPhoto = photo.id == photos.last?.id // ✅ safe comparison

        PhotoSwipeView(photo: photo) {
            remove(photo)
        }
        .overlay(
            isTopPhoto ?
            VStack {
                HStack {
                    Spacer()
                    Button {
                        selectedPhoto = photo
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                Spacer()
            }
            .offset(x: -100)
            : nil
        )
        .frame(width: parentSize.width, height: parentSize.height)
        .zIndex(Double(index)) // ✅ force visual order
    }
}
```

---

### Why This Fix Works

* `photo.id == photos.last?.id` directly compares the photo object to the **last item in the array**, which always represents the top visual card.
* `.zIndex(Double(index))` makes sure cards are layered from bottom to top in the order they appear.
* Overlay logic is now bound to the actual top card, regardless of dynamic data changes.


### 4. Timeout and Compilation Issues When Using `Task {}` with Complex Async Expressions

**Problem:**
When wrapping a complex async call inside a single `Task {}` block—especially one that includes creating model instances, calling async API methods, and updating state all inline—the Swift compiler either failed to build 
due to a timeout or reported *“The compiler is unable to type-check this expression in reasonable time”* errors.

This caused significant delays and blocked development progress.

**Root Cause:**
Swift’s type checker can struggle with very complex closures or expressions inside async contexts like `Task {}` if too many operations are chained or nested inline. This is because the compiler tries to infer types and 
control flow all at once, and heavy chaining or embedding causes it to exceed its heuristics or time limits.

**Solution:**
The solution was to **break the complex expression into smaller, simpler sub-expressions** or separate async functions. For example, instead of writing everything inside one `Task {}` block in a button action, the 
asynchronous logic was moved into a dedicated async method. Then, the button action simply called that method inside a minimal `Task {}` block.

This reduces the complexity inside the compiler’s type-checking scope and drastically improves compile time and stability.

**Example Before (Problematic):**

```swift
Button {
    Task {
        let photo = photos[currentIndex]
        let liked = await authVM.toggleLike(for: PhotoModel(
            id: UUID(),
            user_id: authVM.currentUser?.id ?? UUID(),
            unsplash_id: photo.unsplash_id,
            original_url: photo.urls.regular,
            created_at: nil
        ))
        await MainActor.run {
            isLiked = liked
            showHeartOverlay = liked
        }
        try? await Task.sleep(nanoseconds: 700_000_000)
        await MainActor.run {
            showHeartOverlay = false
        }
    }
} label: {
    // Button label
}
```

**Example After (Fixed):**

```swift
Button {
    Task {
        await likeCurrentPhotoAsync()
    }
} label: {
    // Button label
}

func likeCurrentPhotoAsync() async {
    guard currentIndex >= 0 && currentIndex < photos.count else { return }
    let photo = photos[currentIndex]
    let photoModel = PhotoModel(
        id: nil,
        user_id: authVM.currentUser?.id ?? UUID(),
        unsplash_id: photo.unsplash_id,
        original_url: photo.urls.regular,
        created_at: nil
    )
    let liked = await authVM.toggleLike(for: photoModel)
    await MainActor.run {
        isLiked = liked
        showHeartOverlay = liked
    }
    try? await Task.sleep(nanoseconds: 700_000_000)
    await MainActor.run {
        showHeartOverlay = false
    }
}
```

### 5. Filename Clashing When Saving Filtered Photos

**Problem:**
When multiple users applied filters to the same photo, filtered images were saved using filenames constructed only from the `likedPhotoID` and filter name. This caused filename clashes because users filtering the same 
photo generated identical filenames, leading to overwriting or upload failures.

**Problematic Code Example:**

```swift
// Filename constructed only with likedPhotoID and filter name
let fileName = "\(likedPhotoID.uuidString)_\(safeFilterName).jpg"
try await uploadFilteredImage(data: imageData, fileName: fileName)
```

This assumes `likedPhotoID` always exists and uniquely identifies the filtered image, but when a photo is *not liked* yet, this causes issues. Also, multiple users filtering the same liked photo produce duplicate filenames.

**Root Cause:**
Using only the `likedPhotoID` to construct the filename does not uniquely identify the file per user, so if multiple users like or filter the same photo, filenames collide.

**Solution:**
Add a fallback to use the photo ID combined with the user ID if there is *no liked photo ID*, ensuring uniqueness across users and photos:

```swift
let prefix: String
if let likedID = likedPhotoID {
    prefix = likedID.uuidString
} else {
    prefix = "nolikedphoto_\(photo.id)_\(userID.uuidString)"
}
let fileName = "\(prefix)_\(safeFilterName).jpg"
try await uploadFilteredImage(data: imageData, fileName: fileName)
```

This way:

* If the photo is liked, the filename uses the liked photo UUID.
* If not liked, it uses the photo ID plus the user ID prefixed with `"nolikedphoto_"` to avoid collisions.

**Why it Works:**
UUIDs (both liked photo ID and user ID) are unique. Combining them with the photo ID and an explicit prefix for non-liked photos guarantees unique filenames per user per photo, preventing collisions and overwriting.

### 6. Handling Multiple `.fullScreenCover` Presentations

**Problem:**
Presenting multiple `.fullScreenCover` modifiers independently from different buttons led to the runtime error:

> *"Currently, only presenting a single sheet is supported. The next sheet will be presented when the currently presented sheet gets dismissed."*

**Root Cause:**
SwiftUI only allows one sheet or full screen cover to be active at a time per view hierarchy. Using separate `.fullScreenCover` modifiers for each modal causes conflicts if multiple are triggered.

#### Problematic Code Example

```swift
struct SomeView: View {
    @State private var showPhotoDetail = false
    @State private var showFilterPhoto = false
    let photo: UnsplashPhotosModel

    var body: some View {
        VStack {
            Button("Show Photo Detail") {
                showPhotoDetail = true
            }
            Button("Show Filter Photo") {
                showFilterPhoto = true
            }
        }
        .fullScreenCover(isPresented: $showPhotoDetail) {
            PhotoDetailView(photo: photo)
        }
        .fullScreenCover(isPresented: $showFilterPhoto) {
            FilterPhotoView(photo: photo)
        }
    }
}
```

This causes crashes if both booleans become true close together, since multiple sheets cannot be presented simultaneously.


#### Improved Solution: Use an Enum with Associated Values to Track Active Modal

```swift
enum ActiveModal: Identifiable {
    case photoDetail(UnsplashPhotosModel)
    case filterPhoto(UnsplashPhotosModel)

    var id: String {
        switch self {
        case .photoDetail(let photo): return "detail-\(photo.id)"
        case .filterPhoto(let photo): return "filter-\(photo.id)"
        }
    }
}

struct SomeView: View {
    @State private var activeModal: ActiveModal?
    let authVM: SupabaseAuthViewModel
    let photo: UnsplashPhotosModel

    var body: some View {
        VStack {
            Button("Show Photo Detail") {
                activeModal = .photoDetail(photo)
            }
            Button("Show Filter Photo") {
                activeModal = .filterPhoto(photo)
            }
        }
        .fullScreenCover(item: $activeModal) { modal in
            switch modal {
            case .photoDetail(let photo):
                PhotoDetailView(photo: photo)
            case .filterPhoto(let photo):
                FilterPhotoView(authVM: authVM, photo: photo)
            }
        }
    }
}
```

#### Benefits

* Ensures only one `.fullScreenCover` is active at once, preventing SwiftUI errors.
* Leverages Swift’s enums with associated values for clean modal data passing.
* Simplifies modal management to a single state property.
* Easily extensible for new modal types.

