# SwiftDataProject Summary

---

## Day 57 – Project 12, part one

---

## SwiftDataProject – User Editing Example

This project demonstrates how to build a simple user editing app using **SwiftData**. It highlights how SwiftData integrates seamlessly with SwiftUI through Swift’s observation system, enabling automatic UI updates and 
persistent storage with minimal code.

### Features

* Uses `@Model` to define persistable data models
* Live UI updates using `@Bindable` and `@Query`
* Programmatic navigation to detail views
* On-the-fly user creation and editing
* Preview support using in-memory model containers


### Data Model

We define a `User` class using the `@Model` macro:

```swift
@Model
class User {
    var name: String
    var city: String
    var joinDate: Date

    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
```


### App Setup

In `SwiftDataProjectApp.swift`, SwiftData is configured manually:

```swift
WindowGroup {
    ContentView()
}
.modelContainer(for: User.self)
```

### Editing Users

The `EditUserView` uses `@Bindable` to create two-way bindings to `User` properties:

```swift
struct EditUserView: View {
    @Bindable var user: User

    var body: some View {
        Form {
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join Date", selection: $user.joinDate)
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
    }
}
```

### ContentView Logic

The main view loads users and handles navigation:

```swift
@Environment(\.modelContext) var modelContext
@Query(sort: \User.name) var users: [User]
@State private var path = [User]()

var body: some View {
    NavigationStack(path: $path) {
        List(users) { user in
            NavigationLink(value: user) {
                Text(user.name)
            }
        }
        .navigationTitle("Users")
        .navigationDestination(for: User.self) { user in
            EditUserView(user: user)
        }
        .toolbar {
            Button("Add User", systemImage: "plus") {
                let user = User(name: "", city: "", joinDate: .now)
                modelContext.insert(user)
                path = [user]
            }
        }
    }
}
```

### Xcode Previews

To use previews with SwiftData, configure an in-memory container:

```swift
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        let user = User(name: "Taylor Swift", city: "Nashville", joinDate: .now)
        return EditUserView(user: user)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
```

### Recap

SwiftData provides an elegant and powerful way to persist and observe data. By combining `@Model`, `@Bindable`, and `@Query`, you can build responsive, data-driven SwiftUI apps with minimal boilerplate.

This example showcases how user creation and editing can be implemented smoothly, backed by persistent storage — just like real-world Apple apps.

---
