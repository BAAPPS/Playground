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

---

## What You’ll Learn

- How to use SwiftData for local data persistence in SwiftUI.

- How to implement keyword-based scam detection for user input in real time.

- How to design and trigger user alerts when high-risk content is detected.

- How to use @Relationship to model one-to-one links between messages and their scam alerts.

- How to structure linked user data using user IDs to associate messages with individual users.

- How to use @Bindable to create reactive form inputs and enable two-way binding across views.

- Best practices for managing user-specific message flows, including filtering messages by sender or recipient.

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

Along the way, you’ll learn how to model and manage **linked data** using one-to-one relationships, associate messages with users via **ID-based relationships**, and use `@Bindable` to create reactive, user-driven 
interfaces — all within a clean, modular SwiftUI architecture.

