# Moonshot

Moonshot is an educational iOS app that introduces users to the missions and astronauts of NASA’s iconic Apollo space program. Built with SwiftUI, this project blends beautiful layouts with practical functionality, 
providing a great learning opportunity for anyone looking to deepen their iOS development skills.

---

## What You'll Learn

* **Working with Codable** to decode JSON data cleanly.
* Using **ScrollView** and **NavigationStack** for dynamic content presentation.
* Building custom **layout structures** and composing smaller views into larger ones.
* Handling **image resizing** and view scaling effectively.
* Organizing code with **computed properties** and **custom components**.

---

## What the App Does

* Displays detailed information about each Apollo mission.
* Shows profiles for all Apollo astronauts.
* Provides a smooth, scrollable interface with rich visuals and text.
* Allows users to navigate between mission summaries and crew member details.

---

## Project Structure
```text
Moonshot/
├── Data/
│   ├── astronauts.json
│   └── missions.json
├── Models/
│   ├── Astronaut.swift
│   └── Mission.swift
├── Utils/
│   └── Bundle-Decodable.swift
|   └── Color-Theme.swift
├── ViewModels/
│   └── MissionViewModel.swift
├── Views/
|   └── AstronautView.swift
│   └── ContentView.swift
|   └── CrewMembersView.swift
|   └── GridLayoutView.swift
|   └── ListLayoutView.swift
|   └── MissionView.swift
|   └── RectangleDivider.swift
├── Assets.xcassets/
│   └── [Images from NASA]

```

---

## Final Thoughts

This project is more than just a history app — it’s a hands-on deep dive into solving real SwiftUI problems. From improving layout management to organizing your code effectively, **Moonshot** helps lay a solid foundation 
for building clean, scalable iOS apps.

### Switching from MV to MVVM: A Real-World Pitfall

While transitioning from a Model-View (MV) structure to a Model-View-ViewModel (MVVM) approach, I encountered a classic SwiftUI type mismatch issue.

After updating layout views (like `GridLayoutView` and `ListLayoutView`) to work with `MissionViewModel` instead of plain `Mission`, I forgot that **`MissionView` was still expecting a raw `Mission` model**. 
This caused the compiler error:

```
Cannot convert value of type 'MissionViewModel' to expected argument type 'Mission'
```

### Solution: Pass the Underlying Model

The fix was to **extract the original model from the ViewModel** when navigating to `MissionView`.

#### ✅ Corrected MVVM Usage (Grid View)

```swift
let missions: [MissionViewModel]
let astronauts: [String: Astronaut]

let columns = [GridItem(.adaptive(minimum: 150))]

var body: some View {
    ScrollView {
        LazyVGrid(columns: columns) {
            ForEach(missions, id: \.mission.id) { missionViewModel in
                NavigationLink {
                    // ✅ Pass raw model into the detail view
                    MissionView(mission: missionViewModel.mission, astronauts: astronauts)
                } label: {
                    VStack {
                        Image(missionViewModel.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                        
                        VStack {
                            Text(missionViewModel.displayName)
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text(missionViewModel.formattedLaunchDate)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(.lightBackground)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.lightBackground)
                    )
                    .padding(.bottom, 10)
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}
```

#### Corrected MVVM Usage (List View)

Just like with the grid, using `MissionViewModel` in the `List` layout also required passing the underlying `Mission` model to the `MissionView` detail screen. Failing to do so originally will cause the same error!

```swift
struct ListLayoutView: View {
    let missions: [MissionViewModel]
    let astronauts: [String: Astronaut]
    
    var body: some View {
        List {
            ForEach(missions, id: \.mission.id) { missionViewModel in
                NavigationLink {
                    // ✅ Pass raw model into the detail view
                    MissionView(mission: missionViewModel.mission, astronauts: astronauts)
                } label: {
                    HStack {
                        Image(missionViewModel.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                        
                        VStack {
                            Text(missionViewModel.displayName)
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text(missionViewModel.formattedLaunchDate)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(.lightBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .listRowBackground(Color.darkBackground)
            }
        }
        .scrollContentBackground(.hidden)
    }
}
```

### Why It Matters

The key takeaway here is **don’t forget what your destination views are expecting**. Even in an MVVM setup, **your detail views might not use the ViewModel** — and that’s okay. In this case, `MissionView` relies on the raw 
`Mission` model to remain focused on data display only.

This structure maintains:

* A clean MVVM separation
* Easier preview/test data injection
* Improved modularity between layout and detail views
