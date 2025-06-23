# EntertainmentZone

`EntertainmentZone` is an app designed to reinforce and deepen my understanding of working with JSON data relationships, inspired by my previous `Moonshot` project. This app demonstrates linking data between two JSON 
files—media entries (TV shows and movies) and cast members—and displaying related content together using SwiftUI and MVVM architecture.

The app loads JSON data from the bundle, decodes it into Swift models, and maps cast members to the media they appear in, showcasing how to model, decode, and use linked data.

---

## What You’ll Build

In this project, you will build a SwiftUI app that:

* Loads and decodes multiple JSON datasets bundled within the app.

* Links related data from separate JSON files — connecting media items (movies and TV shows) with their respective cast members.

* Implements the MVVM architecture to manage and organize data flow.

* Displays media posters and cast member profile images using AsyncImage for smooth remote image loading.

* Presents media and cast information in a clean, scrollable list or grid with dynamic and responsive UI.

* Provides practical experience working with JSON parsing, data filtering, and view model creation in Swift.

* Implement navigation to detail views using NavigationLink for seamless user flow

---


## What You’ll Learn

* How to load and decode multiple `JSON` files bundled with the app.

* Applying the `MVVM` pattern: using `MediaViewModel` to link media entries with their cast members by matching IDs.

* Using `AsyncImage` to load remote images for media posters and cast profiles.

* Filtering and linking related data across separate `JSON` files efficiently.

* Displaying media information using `ForEach` with SwiftUI views, including images and text.

* Navigating between views using `NavigationLink` for smooth, user-driven flow.


---


## Project Structure

```text
EntertainmentZone/
├── Data/
│   ├── cast.json
│   └── media.json
├── Models/
│   ├── CastModel.swift
│   └── MediaModel.swift
├── Utils/
│   └── Bundle-Decodable.swift
├── ViewModels/
│   └── MediaViewModel.swift
├── Views/
│   └── ContentView.swift
├── Assets.xcassets/
```

---

## Final Thoughts


---

