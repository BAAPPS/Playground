# Challenge Day 6 - RedFlagLingo

**RedFlagLingo** is a SwiftUI + SwiftData learning challenge where the goal is to detect scam-related keywords in user-entered messages. The app parses text input, flags potential scams, and alerts the user based on a 
categorized keyword system, complete with severity levels. It also saves messages locally using SwiftData for review and analysis.

---
## Features

- **Real-Time Keyword Detection**  
  Automatically scans user-entered text for scam-related terms across multiple scam categories.

- **User Alerts for Risky Content**  
  If a message contains high-risk terms, the app displays an alert warning the user of potential danger.

- **Scam Type Classification**  
  Keywords are organized into scam categories such as `financial_scam`, `romance_scam`, `pig_butchering_scam`, etc.

- **Severity Levels**  
  Each scam type includes a severity level (`low`, `medium`, `high`) to prioritize alerts and UI treatment.

- **SwiftData Persistence**  
  Messages (and their flagged status) are stored using SwiftData, allowing users to review past entries locally.

- **One-to-One @Relationship Linking Messages and Alerts**  
  The app models a clean one-to-one relationship between each message and its corresponding scam alert, enabling efficient data querying and integrity.

- **JSON-Driven Keyword Source**  
  Uses a structured `scamKeywords.json` file to easily manage and extend scam definitions.

---

## Why This Challenge?

This challenge is designed to explore:

- **SwiftData Basics**  
  Learn how to model, store, and query persistent data locally in a SwiftUI app.

- **Binding Data to UI**  
  Display live feedback in the UI when risky language is detected.

- **Defensive UX**  
  Practice building real-world features like user warnings, message filters, and keyword-based validation.

- **Modular & Scalable Design**  
  Categorized keyword loading allows for future expansion, including dynamic updates, severity scoring, or AI-based detection.

- **Modeling One-to-One Relationships**  
  Understand how to implement and use SwiftData’s `@Relationship` macro to create clean, linked data models that mirror real-world connections.

---

## What I Learned

---

## Challenges and Problems Encountered
