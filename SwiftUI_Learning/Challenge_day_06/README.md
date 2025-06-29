# HKPopTracks

HKPopTracks is a simple and elegant learning app focused on the dynamic Cantopop and HK-Pop music scene.

---

## What You’ll Build

In this project, you'll create an app that fetches and displays albums and songs specifically in the Cantopop/HK-Pop genre using the iTunes Search API. Users will be able to browse through the latest releases, explore 
detailed album contents, and enjoy a seamless navigation experience — all while practicing real-world networking, data filtering, and JSON linking techniques.

---

## What You’ll Learn

* How to perform network requests using the iTunes Search API  
* Filtering and sorting JSON data based on genre and release date  
* Linking related data: albums to their tracks using API calls  
* Handling non-English (e.g., Chinese) text and data encoding  
* Building a SwiftUI interface that updates dynamically with network data  
* Managing asynchronous data loading and error handling  
* Structuring your project for clarity and scalability  

---

## Project Structure

```text
HKPopTracks/
├── Models/
│   └── ArtistDetailModel.swift 
│   └── ArtistModel.swift 
├── Utils/
│   └──NetworkFetcher.swift 
├── ViewModels/
│   └── ArtistDetailViewModel.swift 
│   └── ArtistViewModel.swift 
├── Views/
│   └── ArtistDetailView.swift 
│   └── ArtistRowView.swift 
│   └── ArtistView.swift 
│   └── ContentView.swift           
├── Assets.xcassets/              
````

---

## Final Thoughts

HKPopTracks is a great beginner-to-intermediate project for diving into real-world networking and data linking challenges, especially when working with music APIs and handling multilingual data. This app will help you 
build a solid foundation in SwiftUI and API integration, while also sharpening your skills in working with JSON and asynchronous operations.
