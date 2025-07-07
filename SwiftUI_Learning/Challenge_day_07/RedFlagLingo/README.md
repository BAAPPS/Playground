# Challenge Day 7 - RedFlagLingo

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

### 🛑 1. **Picker Not Showing Options on Simulator**

While developing the `UserView`, the recipient `Picker` component worked perfectly in **Xcode Previews** but appeared empty (with no selectable options) when tested on a physical device or Simulator.

#### 🔍 Cause

In `UserListView`, I created users as an array of new `UserModels` but I didn’t insert them into the model context:

```swift
@State private var users: [UserModel] = {
    let addUsers = ["Angel", "Bobbie", "Rob", "Tim", "Durkin"]
    return addUsers.map { UserModel(username: $0) }
}()

```

These are just plain UserModel instances in memory, not saved to your persistence context (modelContext). 

That means:

When I passed users to `MessageViewModel`, it only knows these in-memory objects, not persisted ones.

But `UserViewModel(context: modelContext)` inside each NavigationLink will load users from the empty persistence context — so its users array is empty!

Hence the picker’s data source (`userVM.users.filter { $0.id != user.id }`) is empty → no picker options.

```swift
Picker("Recipient", selection: $selectedRecipient) {
    ForEach(userVM.users.filter { $0.id != user.id }) { otherUser in
        Text(otherUser.username).tag(otherUser as UserModel?)
    }
}
```

* Thus, in the **Simulator**, no users were inserted into the SwiftData context at app startup, so `userVM.users` was empty — resulting in an empty Picker.


* In **Previews**, users were inserted into the model context manually before rendering the view, so `userVM.users` had data.

```swift
context.insert(tim)
context.insert(bob)
```

```swift
#Preview {
    let container = try! ModelContainer(for: UserModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    
    // Create mock users
    let tim = UserModel(username: "TimDurkn")
    let bob = UserModel(username: "Bobbie")
    
    context.insert(tim)
    context.insert(bob)
    
    let userVM = UserViewModel(context: context)
    
    // Initialize your scanner (customize if needed)
    let scanner = ScamScannerViewModel()
    
    // Initialize MessageViewModel with users loaded from userVM
    let messageVM = MessageViewModel(context: context, scanner: scanner, users: userVM.users)
    
    
    
    return NavigationView {
        UserView(user: tim, userVM: userVM, messageVM: messageVM)
            .modelContainer(container)
    }
}
```

#### ✅ Solution

The fix was:

1. **Insert default users into the model context** when the app runs (only if no users exist yet):

```swift
.task {
    if (try? modelContext.fetch(FetchDescriptor<UserModel>()).isEmpty) ?? true {
        let addUsers = ["Angel", "Bobbie", "Rob", "Tim", "Durkin"]
        for name in addUsers {
            modelContext.insert(UserModel(username: name))
        }
        try? modelContext.save()
    }

    users = (try? modelContext.fetch(FetchDescriptor<UserModel>())) ?? []
}
```

With this change, the Picker correctly showed available recipients both in the preview and on actual devices.

### 🛑 2. **Messages Not Showing Full Conversation History**

Initially, the chat feature only showed the **latest message** between two users. Earlier messages seemed to disappear when new ones were sent.

#### 🔍 Cause

In the `sendMessage(from:to:content:)` method, the code incorrectly searched for an existing message between the same sender-receiver pair and **updated its content**, rather than creating a new message each time:

```swift
if let existingMessage = sender.sentMessages.first(where: { $0.receiver?.id == receiver.id }) {
    existingMessage.content = trimmedContent
    existingMessage.date = Date()
    existingMessage.isFlagged = ...
}
```

This meant that each new message **overwrote** the previous one, leaving only one message in storage per conversation.

#### ✅ Solution

The fix was to **always create a new `MessageModel`** for every message sent:

```swift
let newMessage = MessageModel(
    content: trimmedContent,
    date: Date(),
    isFlagged: scanResult != nil,
    sender: sender,
    receiver: receiver
)
context.insert(newMessage)
```

With this change, all messages were persisted individually and could be fetched in order, restoring full chat history.
