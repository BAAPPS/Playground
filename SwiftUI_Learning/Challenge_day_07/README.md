# Red Flag Lingo

**Red Flag Lingo** is a SwiftUI + SwiftData challenge project that detects potentially scammy or suspicious language based on user-entered messages. It uses simple keyword detection to flag terms commonly associated with 
scams, such as **"bitcoin"**, **"crypto"**, and similar high-risk phrases. If such language is detected, the app alerts the user that they might be a potential victim of a scam attempt.

---


## What You’ll Build

A lightweight SwiftUI app that lets users send messages to each other while automatically flagging risky or suspicious content. You’ll implement:

- **Keyword detection logic** to identify scam-related terms in messages.

- A **visual message interface** that displays flagged content with contextual warnings.

- **SwiftData-based persistence** to store users, messages, and alert data locally.

- An **alert system** that warns users when a message contains high-risk terms, promoting safer communication.

- A **one-to-one `@Relationship`** between each message and its associated scam alert for clean, queryable data modeling.

- A **user-to-user messaging flow**, where each message is linked to a sender and recipient via user IDs, enabling targeted detection and history tracking.

- A reactive SwiftData **@Query** integration that automatically keeps your UI synced with your message data, removing the need for manual fetch requests and improving reliability across state changes.

- Customization of the app’s navigation bar appearance using UIColor and UINavigationBarAppearance to match your app’s theme, including background color and text/button tint colors.
---

## What You’ll Learn

- How to use `SwiftData` for local data persistence in SwiftUI.

- How to implement keyword-based scam detection for user input in real time.

- How to design and trigger user alerts when high-risk content is detected.

- How to use `@Relationship` to model one-to-one links between messages and their scam alerts.

- How to structure linked user data using user IDs to associate messages with individual users.

- How to use `@Bindable` to create reactive form inputs and enable two-way binding across views.

- How to filter and organize conversation threads based on `sender` and `recipient` **IDs** using computed properties.

- How to use `@Query` to automatically fetch and update model data, eliminating boilerplate fetch logic and making your views reactive by default.

- Best practices for managing user-specific message flows and dynamically filtering data with SwiftData’s `@Query`.

- How to customize the navigation bar appearance in SwiftUI by bridging UIKit’s `UINavigationBarAppearance` and `UIColor`, allowing for control over background colors, title colors, and back button tint colors.

- Clean architectural strategies using MVVM and modular SwiftUI views.

---

## Project Structure

```text
RedFlagLingo/       
├── Models/
│   └── MessageModel.swift    
│   └── ScamAlertModel.swift   
│   └── ScamDefinitionModel.swift 
│   └── UserModel.swift               
├── Resources/
│   └── alertMessages.json 
│   └── scamKeywords.json    
├── Utils/
│   └── Bundle-Decodeable.swift 
│   └── HexColor.swift 
│   └── setupNavigationBarAppearance.swift
├── ViewModels/
│   └── MessageViewModel.swift  
│   └── ScamScannerViewModel.swift   
│   └── UserViewModel.swift    
├── Views/
│   └── ContentView.swift   
│   └── MessageView.swift 
│   └── UserListView.swift   
│   └── UserView.swift          
├── Assets.xcassets/              
└── RedFlagLingoApp.swift        
````

---


## Final Thoughts

This app offers a hands-on introduction to **SwiftData**, **scam keyword detection**, and **user-to-user messaging** in SwiftUI. You’ll see how even simple natural language logic can be used to build tools that promote 
safer communication.

Along the way, you’ll learn how to:

* Model and manage **linked data** using one-to-one `@Relationship`s between messages and alerts.
* Associate messages with users via **ID-based relationships**, enabling targeted conversations and message filtering.
* Use `@Bindable` to create reactive, user-driven interfaces that stay in sync with user input.
* Leverage ** `@Query` to simplify and automate data fetching**, so your message views always stay up to date with no manual fetch logic.
* Customize the navigation bar appearance by bridging UIKit’s `UINavigationBarAppearance` and `UIColor` for precise control over background colors, title text, and back button tint — ensuring a cohesive app theme.
* Use **.tint(_:)** to customize the color of system UI elements like the back navigation button to match your app's color theme, ensuring visual consistency across views.

By combining these techniques, you’ll build a modular SwiftUI architecture that stays robust even as your app’s state evolves — and gain confidence in building scalable, reactive interfaces with **SwiftData and SwiftUI** 
together.
