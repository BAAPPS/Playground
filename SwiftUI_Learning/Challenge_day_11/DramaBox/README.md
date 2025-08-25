# Challenge Day 11 – DramaBox

---

## Project Overview

**DramaBox** is a challenge project focused on retrieving and managing a library of TVB drama data. The project begins with scraping TVB show data and storing it in a Supabase database. From there, the app uses SwiftUI to present the shows in an organized tab-based layout with advanced features such as filtering, sorting, and offline access.

This project serves as a practical exercise in **full-stack development** using Xcode — from data retrieval to user interface design and local caching.

---

## Technologies Used

* **SwiftUI** – For building the app’s UI and navigation flow.
* **Supabase** – Backend database and API for storing TVB show data.
* **SwiftData** – For local persistence and offline mode.
* **FileManager** – For saving and retrieving local files.
* **Result Type** – For handling success/failure responses from network calls.
* **Custom TabView** – For tab-based navigation between views.
* **Swipe Actions** – For quick actions in list rows.
* **Local Notifications** – For user alerts about new shows or updates.
* **Web Scraping Tool** – External script (e.g., Puppeteer/Playwright) for initial data extraction from TVB Anywhere.

---

## Features

* **TVB Drama Library** – Browse a full list of shows with posters, genres, and descriptions.
* **Tab Navigation** – Organized sections like *All Shows*, *Favorites*, and *Recently Watched*.
* **Real-time Fetching from Supabase** – Keep data synced with the backend.
* **Offline Mode** – Access previously saved data without an internet connection.
* **Filtering & Sorting** – Quickly find shows by genre, release year, or alphabetical order.
* **Swipe Actions** – Mark as favorite, delete, or share directly from the list.
* **Notifications** – Alerts when new shows are available in the library.

---

## Why This Challenge?

This challenge is designed to:

* Practice **integrating a backend service** (Supabase) with SwiftUI.
* Learn **offline-first development** using SwiftData and FileManager.
* Explore **modern UI patterns** like tab bars, swipe actions, and local notifications.
* Understand **data flow** between external APIs, local storage, and the UI.
* Simulate a **real-world media library app** from scratch.

---
## What I Learned

**Problem 1: Episodes embedded in show inserts caused encoding errors**  
- **Solution:** Decoupled episodes from shows and inserted them separately. This fixed JSON serialization issues and allowed proper Swift `Codable` handling.

**Problem 2: Slow uploads when inserting episodes one by one**  
- **Solution:** Implemented batch inserts for episodes after filtering out duplicates. This reduced network requests and significantly improved performance.

**Problem 3: Duplicate key errors in the database**  
- **Solution:** Checked for existing shows and episode titles before inserting. Only new records are uploaded to avoid violating unique constraints.

**Problem 4: Difficulty decoding Supabase responses**  
- **Solution:** Used strongly-typed structs (`ShowDetailsResponse`, episode arrays) to reliably decode `Data` returned from Supabase, rather than trying unsafe casts.

**Problem 5: Managing async workflows with multiple network calls**  
- **Solution:** Used `async/await` with structured error handling to ensure sequential, reliable uploads while keeping the UI responsive.



---

## What I Would Do Differently


---

