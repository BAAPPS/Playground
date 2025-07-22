# BucketList

BucketList is an iOS app that lets users build a private, personalized map of places they want to visit. Users can add custom notes for each location, explore nearby points of interest, and securely save their list for 
future use.

---

## What You'll Learn

* How to embed and interact with maps in SwiftUI
* How to present sheets, use forms, and handle user input
* Storing data securely on-device for authenticated users
* Using `Codable` and `URLSession` to handle data encoding/decoding
* Saving and loading data outside of `UserDefaults`

---

## What the App Does

* Allows users to select locations on a map and save them
* Adds a custom description or notes for each saved place
* Uses the user’s location to search for nearby interesting spots
* Saves the place list securely to the device, available only to authenticated users

---

## Project Structure

```text
BucketList/
├──ContentView.swift       # Main interface for map interaction and saved places
├──ContentView-ViewModel.swift  
├──EditView.swift    
├──Location.swift    
├──Result.swift    
├── Assets.xcassets/            # App assets and icons
├── BucketListApp.swift         # App entry point
```

---

## Final Thoughts

This project brings together many core iOS development skills—forms, maps, networking, secure storage—and introduces you to real-world concepts like location-based services and user data privacy. By the end, you'll have a 
powerful app that mixes functionality with meaningful user personalization.

