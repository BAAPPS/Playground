# TrackBite

TrackBite is a full-stack iOS app built with SwiftUI and MapKit that enables real-time tracking of catering deliveries. Powered by Supabase as the backend, TrackBite lets you manage a dynamic list of restaurants, orders, 
and users, simulate driver movement on a map, and seamlessly sync delivery status between offline local storage and the cloud. This app draws inspiration from platforms like Yelp and DoorDash, providing a rich, real-world 
development experience.

---

## What You’ll Build

* A full-stack iOS app using **SwiftUI**, **UIKit**, and **MapKit**
* A dynamic list of restaurants managed through a **Supabase backend**
* Multiple user types (drivers, customers, admins) with **role-based access**
* Real-time simulation of driver movement on a map
* Order assignment and tracking per user
* Seamless syncing of delivery status between local JSON storage and Supabase
* Offline-first data persistence using local JSON files
* UI elements modeled after **Yelp** and **DoorDash**
* A reusable **UIKit-based segmented control component** embedded in SwiftUI

---

## What You’ll Learn

* How to integrate **MapKit** with SwiftUI to display annotated maps and animate driver movement
* How to design and implement **dummy restaurant and user data** and manage it via Supabase
* How to use **Supabase** for backend services including data storage, authentication, role management, and real-time syncing
* How to implement **offline-first persistence** using `FileManager` and local JSON file storage
* How to build a robust **MVVM architecture** in SwiftUI with clear separation of concerns
* How to detect network status and manage online/offline synchronization effectively
* How to work with **image URLs** and remote assets to display rich UI content
* How to simulate real-world order tracking workflows with dynamic status updates and multi-user scenarios
* How to **embed and customize UIKit components in SwiftUI**, such as using `UISegmentedControl` for platform-consistent toggles and filters
* How to extend your segmented control to optionally use a **UIKit picker** for longer lists or accessibility scenarios

---

## Project Structure

```text
TrackBite/
├── Models/                  # Codable models for Supabase and local data (e.g., DeliveryDestination.swift, User.swift)
├── Resources/               # Dummy data files (JSON), images, and other assets
├── UIKitRepresentables/     #  UIKit components exposed to SwiftUI
├── Utils/                   # General-purpose utilities and extensions
├── ViewModels/              # Business logic for data fetching, syncing, filtering, auth, and role management
├── Views/                   # SwiftUI views including maps, lists, user profiles, and detail screens
├── Assets.xcassets/         # App icons and images
└── TrackBiteApp.swift       # Application entry point
```

---

## Final Thoughts

TrackBite serves as a comprehensive learning platform for iOS developers who want to build sophisticated, production-ready apps. Combining local data management, cloud synchronization, interactive map experiences, and 
multi-user role management, this project helps you sharpen skills in SwiftUI, MapKit, backend integration, and offline-first design. Whether you are building prototypes or full-fledged applications, TrackBite provides a 
solid foundation to grow from.

