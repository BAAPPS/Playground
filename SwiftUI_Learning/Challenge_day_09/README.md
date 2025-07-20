# SplashEdit

A full-featured SwiftUI challenge project combining Core Image, Supabase, and the Unsplash API. Users can browse high-quality images, apply real-time filters, store edits locally and in the cloud, and curate a personal collection with likes and favorites — all with offline-first functionality.

---

## What You’ll Build

You’ll develop an iOS app that allows users to:

* **Browse or search** images using the Unsplash API
* **Like** images and save them to a **personal collection**
* **Apply Core Image filters** with real-time previews
* **Save original and filtered images** to local storage with SwiftData
* **Authenticate** using Supabase and sync data to the cloud
* **Work offline** with background sync when the device reconnects

---

## What You’ll Learn

* How to integrate and work with the **Unsplash API** to fetch and display remote image data
* How to apply image processing using **Core Image** (`CIFilter`, `CIImage`, `CIContext`)
* How to use **Supabase Auth** for secure user sign-in and session management
* How to structure and persist offline-capable data using **SwiftData**
* How to upload files to **Supabase Storage** and record metadata in **Supabase Database**
* How to model **user-photo relationships** (e.g., likes, filtered versions, ownership)
* How to build modern async/await-based workflows for syncing and data handling

---

## Project Structure

```text
SplashEdit/       
├── Models/                  # SwiftData & Supabase data models
|   └── NetworkMonitorModel.swift 
|   └── PhotoModel.swift 
|   └── SupabaseClientModel.swift 
|   └── SupabaseUserModel.swift
|   └── UnsplashPhotosModel.swift 
|   └── UsersModel.swift 
├── Utils/
|   └── HexColor.swift 
|   └── MockData.swift
|   └── NetworkFetcher.swift
|   └── ReusableViews.swift
|   └── SecretsManager.swift
|   └── Supabase-JSONDecoder.swift
├── ViewModels/              # Handles filtering, syncing, and auth logic
|   └── SupabaseAuthViewModel.swift 
|   └── SupabaseManager.swift
|   └── TinderStackButtonsVM.swift  
|   └── UnsplashPhotosVM.swift 
├── Views/                   # All SwiftUI views
│   └── AuthSwicherView.swift
│   └── ContentView.swift
│   └── LoggedInView.swift
│   └── LoginAuthView.swift
│   └── PhotoDetailView.swift
│   └── PhotoSwipeView.swift
│   └── PreviewBindingsView.swift
│   └── SignUpAuthView.swift
│   └── TinderStackButtonsView.swift
│   └── TinderStackView.swift
│   └── TogglePromptView.swift
├── Assets.xcassets/         
└── SplashEditApp.swift      # App entry point
```

---

## Final Thoughts

**SplashEdit** is designed as a well-rounded, real-world challenge project for SwiftUI developers interested in combining creative image manipulation, modern cloud backends, and offline-first principles. Whether you're 
learning for fun, portfolio, or practice — this project will push your skills in architecture, data flow, async development, and UI/UX design.

