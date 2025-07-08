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

## Filtering and Managing Users

### Model Setup

We define a `User` model using the `@Model` macro:

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
````

### Displaying Data

In `ContentView`, we use SwiftData’s `@Query` and `modelContext` to display users in a list:

```swift
@Environment(\.modelContext) var modelContext
@Query(sort: \User.name) var users: [User]
```

This loads users sorted by name, and displays them in a list. A toolbar button inserts sample users:

```swift
Button("Add Samples", systemImage: "plus") {
    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
    // ...additional users...
    modelContext.insert(first)
    // ...
}
```

### Deleting All Users Before Inserting

Before adding sample users, it's helpful to clear any existing data. As of iOS 18 / SwiftData 2.0+, this can be done with:

```swift
try? modelContext.delete(model: User.self)
```

This removes all `User` entries from the database before inserting new ones.

#### ⚠️ Important: Previews Will Crash Without Manual Container Injection

The above deletion will crash **in SwiftUI previews** if SwiftData isn’t properly configured. This happens because Previews **don’t run the full app**, and therefore don’t inherit the `.modelContainer(for:)` modifier from your `@main App`.

To fix this, inject the model container manually in your preview like this:

```swift
#Preview {
    ContentView()
        .modelContainer(for: User.self)
}
```

Without this, Xcode will crash with:

> `NSFetchRequest could not locate an NSEntityDescription for entity name 'User'`

### Filtering with @Query and #Predicate

SwiftData supports powerful filtering via `@Query` and `#Predicate`.

Basic filter example:

```swift
@Query(filter: #Predicate<User> { user in
    user.name.contains("R")
}, sort: \User.name) var users: [User]
```

This includes only users whose names contain a capital **R**. For a more flexible, case-insensitive search, use:

```swift
@Query(filter: #Predicate<User> { user in
    user.name.localizedStandardContains("r")
}, sort: \User.name) var users: [User]
```

You can combine multiple conditions:

```swift
@Query(filter: #Predicate<User> { user in
    user.name.localizedStandardContains("r") && user.city == "London"
}, sort: \User.name) var users: [User]
```

Or we can write it like this as these predicates support a limited subset of Swift expressions 

```swift
@Query(filter: #Predicate<User> { user in
    if user.name.localizedStandardContains("R") {
        if user.city == "London" {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}, sort: \User.name) var users: [User]
```

This filters for users who live in London **and** have an "r" in their name.

> Note: Although `#Predicate` looks like regular Swift, it gets converted into lower-level database instructions. Avoid complex branching like nested `if`/`else`, as they may not compile or behave as expected.

### Understanding #Predicate Limitations

Although you can write:

```swift
if user.name.localizedStandardContains("R") {
    if user.city == "London" {
        return true
    }
}
return false
```

SwiftData might not allow this structure because `#Predicate` is not interpreted as plain Swift — it's compiled into a database query expression. Prefer simple boolean expressions using `&&`.

### Recap

This project demonstrates key SwiftData features:

* `@Model` for defining data
* `@Query` with sorting and filtering
* `modelContext` for inserting and deleting data
* Handling Previews with `.modelContainer(...)`
* Building predicates using `#Predicate`

These tools make it easy to build powerful data-driven SwiftUI apps while keeping UI and model logic in sync.

---

## Day 58 – Project 12, part two

---

## SwiftData Dynamic Filtering & Sorting Example

This SwiftUI + SwiftData project demonstrates how to:

- Dynamically filter model data using `#Predicate`
- Dynamically sort model data using `SortDescriptor`
- Use custom SwiftData queries with user input
- Handle SwiftUI Previews with SwiftData

### UsersView: Dynamic SwiftData Queries

We extract our `List` to a new view called `UsersView`, which accepts:

* A `minimumJoinDate` to filter for upcoming users
* A `[SortDescriptor<User>]` array to control sorting

```swift
struct UsersView: View {
    @Query var users: [User]

    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(
            filter: #Predicate<User> { user in
                user.joinDate >= minimumJoinDate
            },
            sort: sortOrder
        )
    }

    var body: some View {
        List(users) { user in
            Text(user.name)
        }
    }
}
```


### ContentView: Toggling Filter and Sort

In `ContentView`, we pass in two values to `UsersView`:

* A Boolean toggle to switch between showing **all users** or **future joiners**
* A `Picker` or `Menu` to switch between sorting by **name** or **join date**

```swift
@State private var showingUpcomingOnly = false
@State private var sortOrder = [
    SortDescriptor(\User.name),
    SortDescriptor(\User.joinDate)
]

var body: some View {
    NavigationStack {
        UsersView(
            minimumJoinDate: showingUpcomingOnly ? .now : .distantPast,
            sortOrder: sortOrder
        )
        .navigationTitle("Users")
        .toolbar {
            Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
                showingUpcomingOnly.toggle()
            }

            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                Picker("Sort", selection: $sortOrder) {
                    Text("Sort by Name")
                        .tag([
                            SortDescriptor(\User.name),
                            SortDescriptor(\User.joinDate)
                        ])
                    Text("Sort by Join Date")
                        .tag([
                            SortDescriptor(\User.joinDate),
                            SortDescriptor(\User.name)
                        ])
                }
            }
        }
    }
}
```

### Sample Data with SwiftData Deletion

When working with test data, you may want to reset all users before inserting:

```swift
try? modelContext.delete(model: User.self)
```

This clears all `User` objects from the persistent store.

#### ⚠️ Previews Will Crash Without Model Injection

Xcode previews do **not** run the `@main` app struct, which normally injects the model container. If you don’t inject it manually, the `@Query` property will crash with:

> `NSFetchRequest could not locate an NSEntityDescription for entity name 'User'`

✅ To fix this, always inject your container explicitly in the preview:

```swift
#Preview {
    UsersView(
        minimumJoinDate: .now,
        sortOrder: [SortDescriptor(\User.name)]
    )
    .modelContainer(for: User.self)
}
```

---

### Recap

This project demonstrates:

* Using `@Query` with dynamic `#Predicate` filters
* Custom sort orders using `[SortDescriptor<User>]`
* Passing user-driven values into SwiftData queries
* Correctly handling `.modelContainer(...)` in Previews to avoid crashes

SwiftData is still evolving, and its query API — especially dynamic predicates — is complex but powerful when used right.

---

## SwiftData Relationships: Users and Jobs

This section demonstrates how to define, use, and manage **relationships** between models in SwiftData — specifically a one-to-many relationship between `User` and `Job`.

### Model Relationships

We define two SwiftData models: `User` and `Job`.

- A `User` can have **many jobs** (`[Job]`)
- A `Job` belongs to **one owner** (`User?`)

#### User.swift

```swift
@Model
class User {
    var name: String
    var city: String
    var joinDate: Date

    @Relationship(deleteRule: .cascade) var jobs = [Job]()

    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
````

#### Job.swift

```swift
@Model
class Job {
    var name: String
    var priority: Int
    var owner: User?

    init(name: String, priority: Int, owner: User? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}
```

### Automatic Relationships & Migration

* You **don’t need to register `Job.self`** in `.modelContainer(for:)` — SwiftData will detect it from the relationship with `User`.
* When new properties (like `jobs`) are added, SwiftData **automatically migrates** the model schema and applies changes to existing data.

### Listing Users and Job Counts

To display all users and how many jobs they have:

```swift
List(users) { user in
    HStack {
        Text(user.name)
        Spacer()
        Text(String(user.jobs.count))
            .fontWeight(.black)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(.capsule)
    }
}
```

This works automatically — no changes to `@Query` are needed.


### Sample Data Creation

To insert users and assign jobs for testing:

```swift
@Environment(\.modelContext) var modelContext

func addSample() {
    let user = User(name: "Piper Chapman", city: "New York", joinDate: .now)
    let job1 = Job(name: "Organize sock drawer", priority: 3)
    let job2 = Job(name: "Make plans with Alex", priority: 4)

    modelContext.insert(user)

    user.jobs.append(contentsOf: [job1, job2])
}
```

SwiftData automatically establishes the relationship — just append the jobs to the user's array.

### Delete Behavior

By default, deleting a `User` does **not delete their jobs** — the relationship is set to `.nullify`, meaning jobs remain but have no owner.

To change this and delete all related jobs when a user is deleted, add a delete rule:

```swift
@Relationship(deleteRule: .cascade) var jobs = [Job]()
```

This ensures a **cascade delete**: when a `User` is deleted, all their `Job` objects are deleted too. Prevents orphaned data.


### Recap

* SwiftData supports relationships between models with little setup.
* Use `@Relationship(deleteRule:)` to control what happens when objects are deleted.
* SwiftData handles schema migrations automatically when new properties are added.
* Use `.cascade` to automatically delete related records and prevent data leaks.
* You don’t need to manually register related models if they’re linked through properties.

* Start simple — work with SwiftData like it's `@Observable`.
* Only use `@Relationship(deleteRule:)` when you're sure how deletion should behave.
* Use `modelContext.insert()` and let relationships form via appending objects.
* Always test relationships in Previews or sample runs to confirm behavior.

---

## iCloud Syncing with SwiftData

SwiftData supports syncing user data with **iCloud**, allowing seamless data persistence across devices. This guide walks through enabling iCloud sync, configuring your models correctly, and avoiding common pitfalls.


### ⚠️ Requirements

> ❗ iCloud syncing **requires** an active Apple Developer account.  
> ❗ Simulator is unreliable for iCloud testing – always test on a **real device**.

### Enabling iCloud Sync in Xcode

1. **Open the Project Settings**
   - In the **Project Navigator (⌘1)**, click the **blue project icon** at the top (e.g., `SwiftDataTest`).
   - In the center panel, under **TARGETS**, select your app (e.g., `SwiftDataTest`).

2. **Enable iCloud**
   - Select the **Signing & Capabilities** tab.
   - Click the **+ Capability** button.
   - Choose **iCloud**.
   - Under iCloud options, **check "CloudKit"**.
   - Click the **+ button** in the CloudKit container section and create a new container.
     - Suggested format: `iCloud.com.yourdomain.appname`

3. **Enable Background Modes**
   - Click **+ Capability** again.
   - Choose **Background Modes**.
   - Check **Remote Notifications**.


### Model Requirements for iCloud

To sync with iCloud, SwiftData **requires**:

- All **non-relationship properties** must be:
  - Optional **or**
  - Have default values
- All **relationships** must be optional

#### ✅ Updated `User` Model

```swift
@Model
class User {
    var name: String = "Anonymous"
    var city: String = "Unknown"
    var joinDate: Date = .now

    @Relationship(deleteRule: .cascade)
    var jobs: [Job]? = [Job]()

    var unwrappedJobs: [Job] {
        jobs ?? []
    }
}
````

#### ✅ Updated `Job` Model

```swift
@Model
class Job {
    var name: String = "None"
    var priority: Int = 1
    var owner: User?
}
```

### Code Changes for Optionals

Since relationships and some properties are now optional, you must use:

#### Optional chaining

```swift
user.jobs?.append(job)
```

#### Nil coalescing

```swift
Text("Jobs: \(user.jobs?.count ?? 0)")
```

#### Recommended: Use Computed Properties

Instead of repeating optional-handling logic everywhere, define helper properties:

```swift
var unwrappedJobs: [Job] {
    jobs ?? []
}
```

### Testing Tips

* **Use a real device.** The iOS Simulator struggles with CloudKit performance and reliability.
* **Check Xcode logs.** CloudKit errors (e.g., schema mismatches, property issues) are logged at runtime.
* **Use `print()` generously** to confirm sync triggers, especially in production.


### Recap

| Feature                               | Required                   |
| ------------------------------------- | -------------------------- |
| Apple Developer Account               | ✅                          |
| CloudKit Enabled                      | ✅ via + Capability         |
| Background Mode: Remote Notifications | ✅                          |
| Optional/default properties           | ✅ Required for iCloud sync |
| Optional relationships                | ✅ Required for iCloud sync |
| Simulator testing                     | 🚫 Not reliable            |
| Real device testing                   | ✅ Recommended              |

✅ To get CloudKit working in **development mode**, here’s what you need:

#### Steps to Use CloudKit in Development Mode

| Requirement                        | Why it Matters                                                                               |
| ---------------------------------- | -------------------------------------------------------------------------------------------- |
| 🔹 **Real device (not simulator)** | iCloud sync only works on physical devices with an iCloud account signed in.                 |
| 🔹 **Signed in to iCloud**         | The device must be logged into an Apple ID with iCloud enabled.                              |
| 🔹 **iCloud Capability Enabled**   | Add the `iCloud` and `Background Modes → Remote Notifications` capabilities in Xcode.        |
| 🔹 **CloudKit checked**            | Under the iCloud capability, ensure **CloudKit** is enabled and a container is created.      |
| 🔹 **Running a development build** | Run from Xcode with your dev team selected so data syncs to the **development** environment. |


##### Why the Simulator Fails for CloudKit

* No iCloud sign-in
* CloudKit doesn’t initialize properly
* Can’t create or sync records
* Xcode previews use fake contexts

> So while you can test **local SwiftData** in simulator or #Preview, CloudKit syncing **only works** with real devices.

---

##### Tip: How to Confirm It’s Working

1. Run your app on your device from Xcode
2. Insert some data (e.g., add a `User` or `Job`)
3. Leave the app open for a bit (or switch out and back in)
4. Go to [CloudKit Dashboard](https://icloud.developer.apple.com/dashboard)
5. Select your container
6. Make sure **Environment = Development**
7. Look under “Records” → You should see data appearing!

SwiftData + iCloud is powerful and automatic — once your models and capabilities are configured correctly. Just remember: optionality isn't a suggestion, it’s a **requirement** for iCloud sync.

---

## Day 59 – Project 12, part three

---


## iExpense - Challenge 1: SwiftData Integration

This project is an upgraded version of the iExpense app, refactored to use **SwiftData** for data persistence instead of manual Codable + UserDefaults. The app tracks expense items and groups them by type ("Personal" and "Business").


### What was done in Challenge 1

- Converted the data model from using a separate `Expenses` class with `@Observable` and UserDefaults to using a single `@Model` class `ExpenseItem` powered by SwiftData.
- Updated the `iExpenseApp` entry point to use `.modelContainer(for: ExpenseItem.self)` for SwiftData persistence.
- Refactored `ContentView` to use `@Query` to automatically fetch all `ExpenseItem` objects.
- Implemented filtered expense lists by type ("Personal" and "Business") using SwiftData query results.
- Provided proper deletion support using `modelContext.delete()` on filtered expenses.
- Connected the add expense flow through a NavigationLink to `AddView`.


### Key SwiftData Code Highlights

#### iExpenseApp.swift

```swift
import SwiftUI
import SwiftData
@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}

```

#### ExpenseItem.swift

```swift
import SwiftData
import SwiftUI

@Model
class ExpenseItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var type: String
    var amount: Double
    
    init(id: UUID = UUID(), name: String, type: String, amount: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
    }
}

extension ExpenseItem {
    var amountColor: Color {
        if amount < 10 {
            return .green
        } else if amount < 100 {
            return .orange
        } else {
            return .blue
        }
    }
}
````

#### iExpenseApp.swift

```swift
import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
```


#### ContentView\.swift

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var expenses: [ExpenseItem]
    
    func removeItems(at offsets: IndexSet, filterType: String) {
        let filtered = expenses.filter { $0.type == filterType }
        let itemsToDelete = offsets.map { filtered[$0] }
        for item in itemsToDelete {
            modelContext.delete(item)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    let personalExpenses = expenses.filter { $0.type == "Personal" }
                    ForEach(personalExpenses, id: \.id) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, filterType: "Personal")
                    }
                }
                
                Section("Business") {
                    let businessExpenses = expenses.filter { $0.type == "Business" }
                    ForEach(businessExpenses, id: \.id) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, filterType: "Business")
                    }
                }
            }
            .navigationTitle("iExpense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink(destination: AddView()) {
                    Label("Add Expenses", systemImage: "plus")
                }
            }
        }
    }
}
```

#### AddView.swift

```swift
import SwiftUI
import SwiftData

struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Type of Expense") {
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Amount of Expense") {
                    TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                }
                
                Section("Name of Expense") {
                    TextField("Name", text: $name)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = ExpenseItem(name: name, type: type, amount: amount)
                        modelContext.insert(item)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
```

---

## Challenge 2: Sorting Expenses

**Goal:**
Allow users to sort their expenses by different criteria such as Name or Amount.

**Implementation Details:**

* Added a `SortType` enum representing the sorting options (`Name` and `Amount`).
* Each case provides an array of `SortDescriptor<ExpenseItem>` to define the sorting behavior.
* The `ContentView` uses a toolbar menu to let users pick the sort option.
* The selected sort descriptors are passed down to `ExpenseListView` to update the query.

### Code Snippet (Sorting)

```swift
enum SortType: String, CaseIterable, Identifiable {
    case name = "Name"
    case amount = "Amount"
    
    var id: String { rawValue }
    
    var descriptors: [SortDescriptor<ExpenseItem>] {
        switch self {
        case .name:
            return [SortDescriptor(\ExpenseItem.name)]
        case .amount:
            return [SortDescriptor(\ExpenseItem.amount)]
        }
    }
}

struct ContentView: View {
    @State private var sortType: SortType = .name
    
    var body: some View {
        NavigationStack {
            ExpenseListView(sortOrder: sortType.descriptors)
                .navigationTitle("iExpense")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort by", selection: $sortType) {
                                ForEach(SortType.allCases) { sort in
                                    Text(sort.rawValue).tag(sort)
                                }
                            }
                        }
                    }
                }
        }
    }
}
```

---

## Challenge 3: Filtering Expenses and Sectioned Display

**Goal:**
Add filtering to display only Personal, Business, or All expenses. When showing All, display expenses in two separate sections: Personal and Business.

**Implementation Details:**

* Added a `FilterType` enum that includes an optional `Predicate<ExpenseItem>` to filter expenses by type.
* The `ContentView` uses a toolbar menu for filtering options (`All`, `Personal`, `Business`).
* The predicate is passed to `ExpenseListView` to update the SwiftData query.
* When filtering is `.all` (no predicate), expenses are displayed in two sections: Personal and Business.
* When filtered by one type, expenses are shown as a flat list.

### Code Snippet (Filtering and Sectioned List)

```swift
enum FilterType: String, CaseIterable, Identifiable {
    case all = "All"
    case personal = "Personal"
    case business = "Business"
    
    var id: String { rawValue }
    
    var predicate: Predicate<ExpenseItem>? {
        switch self {
        case .all:
            return nil
        case .personal:
            return #Predicate<ExpenseItem> { $0.type == "Personal" }
        case .business:
            return #Predicate<ExpenseItem> { $0.type == "Business" }
        }
    }
}

struct ExpenseListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var expenses: [ExpenseItem]
    
    let sortOrder: [SortDescriptor<ExpenseItem>]
    
    init(
        predicate: Predicate<ExpenseItem>? = nil,
        sortOrder: [SortDescriptor<ExpenseItem>] = []
    ) {
        self.sortOrder = sortOrder
        _expenses = Query(filter: predicate, sort: sortOrder)
    }
    
    func delete(at offsets: IndexSet, forType type: String) {
        let filtered = expenses.filter { $0.type == type }
        let itemsToDelete = offsets.map { filtered[$0] }
        for item in itemsToDelete {
            modelContext.delete(item)
        }
    }
    
    var body: some View {
        List {
            Section("Personal") {
                let personal = expenses.filter { $0.type == "Personal" }
                ForEach(personal) { item in
                    ExpenseRow(item: item)
                }
                .onDelete { offsets in
                    delete(at: offsets, forType: "Personal")
                }
            }
            
            Section("Business") {
                let business = expenses.filter { $0.type == "Business" }
                ForEach(business) { item in
                    ExpenseRow(item: item)
                }
                .onDelete { offsets in
                    delete(at: offsets, forType: "Business")
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}
```

---

## Combined ContentView with Sorting and Filtering Menus

```swift
struct ContentView: View {
    @State private var filterType: FilterType = .all
    @State private var sortType: SortType = .name
    
    var body: some View {
        NavigationStack {
            ExpenseListView(
                predicate: filterType.predicate,
                sortOrder: sortType.descriptors
            )
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: AddView()) {
                        Label("Add Expenses", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Menu("Filter", systemImage:"line.horizontal.3.decrease.circle") {
                        Picker("Filter", selection: $filterType) {
                            ForEach(FilterType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort by", selection: $sortType) {
                            ForEach(SortType.allCases) { sort in
                                Text(sort.rawValue).tag(sort)
                            }
                        }
                    }
                }
            }
        }
    }
}
```

