# Challenge Day 5 - EntertainmentZone

---

## Features

* Decodes and links two separate JSON data sources: media entries and cast members
* Implements MVVM architecture to maintain clean, centralized business logic
* Displays fullscreen media posters with smooth vertical swipe navigation, mimicking TikTok or Instagram Reels
* Handles asynchronous image loading with robust layout and alignment fixes
* Implements a custom vertical snap paging view with gesture detection for precise fullscreen page snapping
* Centralized navigation management using a shared, observable `NavigationPath` wrapper that supports programmatic navigation and persistence

---

## Why This Challenge?

This challenge pushed me to deepen my understanding of:

* Decoding and linking multiple JSON files with relationships
* Complex SwiftUI layouts involving asynchronous image loading and fullscreen paging
* Building smooth, native-feeling swipe gestures for vertical paging
* Managing navigation state in SwiftUI with `NavigationStack` and preserving state across views and app launches

---

## What I Learned

* How to effectively debug JSON decoding by adding explicit error handling and descriptive fatal errors
* Techniques to link datasets with matching IDs by filtering and associating related models in the ViewModel layer
* Managing tricky SwiftUI layout issues caused by `AsyncImage` and view hierarchy, especially around safe areas and clipping
* How to implement custom snapping scroll behavior using `GeometryReader` + `DragGesture` to achieve fullscreen vertical paging compatible with iOS 16+
* The importance of explicitly sizing views in asynchronous loading scenarios to stabilize alignment and avoid layout shifts
* How to architect navigation state with an observable wrapper class around `NavigationPath` to enable programmatic navigation and state persistence

---

## Challenges and Problems Encountered

### 1. **Decoding Multiple JSON Files**

* Initially faced crashes due to malformed JSON.
* Improved debugging by adding fatal errors with clear messages in the `Bundle.decode` helper.
* Helped identify and fix errors in `cast.json` and `media.json`.

### 2. **Linking Cast to Media**

* Needed to associate cast members with media entries using cast IDs.
* Implemented filtering logic in `MediaViewModel` to link related models, following MVVM principles.

### 3. **Displaying Fullscreen Images**

* Tried `GeometryReader` and `.ignoresSafeArea()` but encountered spacing and safe area glitches.
* Fixed by moving `.ignoresSafeArea()` higher in the view hierarchy and applying `.scaledToFill()`, `.frame(maxWidth: .infinity, maxHeight: .infinity)`, and `.clipped()` on `AsyncImage`.

### 4. **Layout Glitches with `AsyncImage`**

* `AsyncImage` caused white gaps and inconsistent scaling inside complex containers.
* Resolved by minimizing nesting, explicitly setting frame sizes, and using `.clipped()` consistently.

### 5. ** `ScrollView` Did Not Snap to Fullscreen Pages**

* Default `ScrollView` allowed free scrolling with no snapping.
* `ScrollViewReader` and `.tabViewStyle(.page)` had compatibility issues (vertical paging only in iOS 17+).
* Solution: Combined `GeometryReader` and `DragGesture` to detect drag offsets and control page snapping with smooth animations.
* Resulted in a smooth vertical swiper fully compatible with iOS 16+.

### 6. **Layout Issue with Centered `Text` on `AsyncImage`**

* Text initially centered but shifted right on image load due to `AsyncImage`'s `.empty` phase lacking size.
* Fixed by passing explicit `width` and `height` from `GeometryReader` to both `AsyncImage` and overlay `Text` inside a `ZStack(alignment: .bottom)`.
* This stabilized the layout and ensured text stayed bottom-centered.

```swift
ZStack(alignment: .bottom) {
    AsyncImage(url: url) { phase in
        switch phase {
        case .empty:
            ProgressView()
                .frame(width: width, height: height)
        case .success(let image):
            image
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
        case .failure:
            Image(systemName: "photo")
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
        @unknown default:
            EmptyView()
        }
    }

    OverlayEffectView()

    Text(mediaVM.media.title)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
        .font(.title2)
        .bold()
        .frame(maxWidth: .infinity)
        .padding(.bottom, 100)
}
.frame(width: width, height: height)
```

### 7. **Managing NavigationPath State Across Views in SwiftUI**

* Needed centralized, observable navigation state (`NavigationPath`) shared across multiple views.
* Created an `@Observable` `PathStore` class wrapping `NavigationPath` with automatic save/load to disk.
* Managed path state with `@State` in root view and passed down as `@Binding` to child views.
* Enabled programmatic navigation control, path reset, and persisted navigation state across launches.

---

