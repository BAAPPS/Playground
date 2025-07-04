# Red Flag Lingo

**Red Flag Lingo** is a SwiftUI + SwiftData challenge project that detects potentially scammy or suspicious language based on user-entered messages. It uses simple keyword detection to flag terms commonly associated with 
scams, such as **"bitcoin"**, **"crypto"**, and similar high-risk phrases. If such language is detected, the app alerts the user that they might be a potential victim of a scam attempt.

---

## What You’ll Build

A lightweight SwiftUI app that allows users to enter messages and immediately flags content that contains risky or suspicious keywords. You’ll implement:

- ✅ Keyword detection logic for scam-related terms.
- ✅ A visual interface to show flagged messages.
- ✅ **SwiftData-based persistence** to store and review past entries.
- ✅ An **alert system** to warn users if a message contains high-risk terms, helping raise awareness and encourage caution.
- ✅ A **one-to-one @Relationship** between the message and its corresponding scam alert, enabling clean, linked data modeling and easy data querying.

---

## What You’ll Learn

- How to use **SwiftData** for local data persistence in SwiftUI.
- How to implement keyword-based scanning for user input.
- How to design and trigger **user alerts** based on flagged content.
- How to model **one-to-one relationships** with SwiftData’s `@Relationship` macro to link related data cleanly.
- Best practices for handling simple data models, form input, and message lists.
- How to structure SwiftUI apps in a clean, modular way.

---

## Project Structure

```text
RedFlagLingo/       
├── Models/
│   └── MessageModel.swift    
│   └── ScamAlertModel.swift               
├── Resources/
│   └── alertMessages.json 
│   └── scamKeywords.json    
├── Views/
│   └── ContentView.swift        
├── Assets.xcassets/              
└── RedFlagLingoApp.swift        
````

---

## Final Thoughts

This app is a hands-on introduction to **SwiftData** and **natural language detection** with SwiftUI. It demonstrates how simple logic can be used to create tools that improve awareness and promote safety in digital 
communication — while showcasing how to build and manage **linked data** with one-to-one relationships in a modern SwiftUI app.

