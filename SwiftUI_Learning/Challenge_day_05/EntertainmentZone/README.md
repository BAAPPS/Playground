# Challenge Day 5 - EntertainmentZone

---

## Features


--- 


## Why This Challenge?

---


## What I Learned



---

## Challenges and Problems Encountered

### 1. **Decoding Multiple JSON Files**

I encountered crashes due to malformed or invalid JSON structures. The `Bundle.decode` helper failed silently until I added clearer error messages using `fatalError`, which helped pinpoint issues in `cast.json` and
`media.json`.

### 2. **Linking Cast to Media**

Creating a relationship between two separate JSON files was challenging. Each `Media` item contained `castIds`, which needed to match entries in the `Cast` dataset. I resolved this by filtering and linking them in `MediaViewModel`, making full use of the MVVM pattern to keep the logic clean and centralized.

### 3. **Displaying Fullscreen Images**

I aimed to mimic TikTok-style vertical scrolling with full-screen media posters. Early layout attempts using `GeometryReader` introduced unexpected spacing and safe area issues.

Key challenges:

* `.ignoresSafeArea()` inside `TabView` didn’t fully remove white space until moved higher in the view hierarchy.
* `AsyncImage` occasionally displayed cropped or blank areas unless constrained correctly.

Using `.scaledToFill()` with `.frame(maxWidth: .infinity, maxHeight: .infinity)` and proper `.clipped()` handling resolved most layout inconsistencies.

### 4. **Layout Glitches with `AsyncImage`**

When used inside complex containers like `TabView` or `GeometryReader`, `AsyncImage` often displayed white gaps or didn’t scale fully. The solution involved:

* Avoiding excessive nesting.
* Applying `.scaledToFill()` and explicit `.frame(...)` values.
* Using `.clipped()` to maintain consistent sizing.

### 5. ** `ScrollView` Did Not Snap to Fullscreen Pages **

The goal was to create a fullscreen vertical scroller — one media item per screen, with smooth swipe-based navigation (like Instagram Reels).

Initial issues:

* Using `ScrollView` with `VStack(spacing: 0)` and `.frame(height: UIScreen.main.bounds.height)` allowed free scrolling with no page snapping.
* `ScrollViewReader` didn’t enforce snapping.
* `.tabViewStyle(.page)` only supports vertical scrolling on iOS 17+, which limited compatibility.

#### Solution: `GeometryReader` + `DragGesture`

I replaced `ScrollView` with a combination of:

* `GeometryReader` to capture the screen height.
* `DragGesture` to detect swipe direction and magnitude.
* A calculated Y-offset using `-currentPage * height + dragOffset`.
* Smooth transitions via `withAnimation`.

This gave me **full control** over the scroll behavior without relying on `ScrollViewReader` or platform-specific features.

#### Final Result

The vertical swiper now behaves exactly like a native paging interface:

* Each media item fills the entire screen.
* Swiping up/down transitions between pages with snappy animation.
* Compatible with iOS 16 and up — no need for `TabView` tricks or `.tabViewStyle(.vertical)`.


### 6. **Layout Issue with Centered `Text` on `AsyncImage` **

Initial issue:

When displaying a list of media items using a custom vertical `SnapPagingView`, we placed a title at the **bottom-center** of each fullscreen page using `ZStack(alignment: .bottom)`. However, during runtime, the title text 
would **briefly appear centered**, then **shift to the right side** as the view loaded.

This issue only happened when using `AsyncImage` to load background images. If the image was commented out, the title remained properly centered.

#### Root Cause

SwiftUI's `AsyncImage` loads asynchronously. Initially, it uses a `.empty` placeholder state that does **not define width or height**, which causes the surrounding `ZStack` to have undefined dimensions during the first layout pass. Because of this, SwiftUI miscalculates the alignment context, and the title text ends up rendered off-center (often pushed to the right).

#### Solution

To resolve this, we updated our `SnapPagingView` to pass both `width` and `height` from a `GeometryReader`, and we applied those explicitly to every image and container frame.

We then used `ZStack(alignment: .bottom)` to position the overlay text, ensuring it rendered **bottom-centered** reliably.

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

### Final Result

By ensuring all views in the `ZStack` — including the image and text — were framed with the same explicit width and height, the layout remained stable. 
The text no longer shifted to the right and consistently appeared bottom-centered.

---

