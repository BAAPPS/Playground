# iExpense

iExpense is a multi-screen expense tracking app built using SwiftUI. This project helps you go beyond the basics by introducing techniques for data persistence, dynamic user interfaces, and app navigation.

---

## What You'll Learn

This project is designed to push your SwiftUI skills forward. By the end of it, you'll know how to:

- Present and dismiss secondary views using `.sheet`.
- Build and manage dynamic lists using `List` and `ForEach`.
- Use `.onDelete` to enable swipe-to-delete functionality.
- Save and load user data using `Codable` and `UserDefaults`.
- Differentiate between business and personal expenses.
- Style list items dynamically based on their values.
- Use `@State`, `@Binding`, `@Environment`, and custom `ObservableObject` models.
- Access and format values based on the user’s locale (`Locale.current`).
- Use reusable SwiftUI views to simplify complex layouts.
- Group list content into sections using `Section`.

---

## What the App Does

iExpense allows users to:

- Add new expenses with a form-based modal view.
- View expenses split into **Personal** and **Business** sections.
- See list items styled based on amount: green for cheap, orange for moderate, and red for expensive.
- Delete expenses with a swipe gesture.
- Automatically save all changes using `UserDefaults`, so data persists across app launches.

---

## Project Structure

```

iExpense/
│
├── Model/
│   └── ExpenseItem.swift      // Defines the ExpenseItem struct conforming to Codable & Identifiable
│
├── Views/
│   └── AddView.swift          // Modal sheet to add new expenses
│   └── ContentView.swift      // Main UI showing expense list & toolbar
│   └── ExpenseListView.swift  // Reusable view for expense list
│   └── ExpenseRow.swift       // Reusable view for styling each row
│
├── Assets.xcassets   
│  
└── iExpenseApp.swift          // Entry point of the app

```

---

## Final Thoughts

The **iExpense** app started as a simple expense tracker, but through guided challenges and improvements, it evolved into a well-structured, user-aware, and dynamic SwiftUI application. 

Here’s a recap of what was accomplished:

- **Challenge 1**: We enhanced currency formatting by using the device’s current locale.
- **Challenge 2**: We applied conditional styling to list items based on amount using a custom `Color` property and `.listRowBackground`.
- **Challenge 3**: We split the list into **Personal** and **Business** sections using `Section` and `filter`, along with a reusable row component.

Along the way, I learned essential app architecture patterns and SwiftUI-specific design practices, including:

- **Reactive data flows** using `@ObservedObject` and `@Published`.
- **Local data storage** with `UserDefaults` and `Codable`.
- **Environment-driven actions** like `.dismiss()` via `@Environment`.
- **SwiftUI layout composition** using `HStack`, `VStack`, `Spacer`, and reusable components.
- **Conditionally styling views** and list sections.

I now have a solid understanding of how SwiftUI handles data, state, layout, and persistence — all of which are foundational for building production-ready iOS apps.

