# Instafilter

Instafilter is an iOS app that allows users to import photos from their library and apply various Core Image filters for real-time image processing. This project blends SwiftUI and UIKit, giving you hands-on experience working with both Apple frameworks.

---

## What You'll Learn

* How to integrate **Core Image** for advanced image processing
* Bridging **UIKit** components with **SwiftUI**
* Applying image filters like blur, sepia, and pixellation
* Using `UIViewControllerRepresentable` to wrap UIKit views
* Managing image input/output and applying GPU-accelerated effects

---

## What the App Does

* Imports photos from the user’s photo library
* Displays the selected image in a SwiftUI interface
* Applies a variety of image filters using Core Image
* Allows real-time preview and adjustments of image effects

---

## Project Structure

```text
Instafilter/
├── Views/
│   └── ContentView.swift       # Main interface for image selection and filtering
├── Assets.xcassets/            # App assets and icons
├── InstafilterApp.swift        # App entry point
```

---

## Final Thoughts

**Core Image** is a powerful, GPU-accelerated framework perfect for real-time image manipulation. While it works in the simulator, you’ll see true performance only on physical devices.

Although **SwiftUI** is Apple's future, many frameworks (like image pickers, MapKit, etc.) still rely on UIKit. Learning how to bridge the two is essential if you're working with Apple's full ecosystem or integrating with existing UIKit codebases.

This project is a great stepping stone into building more complex SwiftUI apps with UIKit interoperability.

