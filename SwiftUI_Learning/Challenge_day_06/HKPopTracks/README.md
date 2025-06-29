# Challenge Day 6 - HKPopTracks

---

## Features

- Fetch and display albums and tracks in the Cantopop/HK-Pop genre using the iTunes Search API  
- Filter and sort results by genre and release date to highlight the latest music  
- Drill down from albums to individual track lists with smooth navigation  
- Handle multilingual (e.g., Chinese) artist and album names gracefully  
- Practice asynchronous networking and JSON decoding in SwiftUI  
- Clean, simple UI focused on user-friendly exploration of music content  

---

## Why This Challenge?

This challenge provides an excellent opportunity to deepen your understanding of working with real-world APIs, especially those that require data filtering, linking, and multilingual support. HKPopTracks combines 
networking, data parsing, and SwiftUI skills in a focused domain — Cantopop and HK-Pop music — making it both educational and culturally enriching. 

By completing this challenge, I'll gain practical experience in building scalable, data-driven apps that fetch and present complex related data smoothly, a vital skill for modern app development.

---

## What I Learned

---


## Challenges and Problems Encountered

### **1. JSON Decoding Issues**

* Mismatched property names in model vs. JSON keys (e.g., `resultCount` typo).
* Non-optional properties for sometimes missing JSON fields (e.g., `amgArtistId`, `collectionType`).
* Missing or incorrect `CodingKeys` mapping caused decode failures.
* Resolved by aligning property names, marking all fields (except `id`) as optional, and customizing decoding logic as needed.

> ✅ **Key Lesson:** APIs often return incomplete or mixed-type data structures—defensive decoding using optional properties prevents crashes and ensures smoother parsing.


### **2. Missing Data in UI Despite Successful Fetch**

* Even though valid JSON was fetched and printed in debug logs, the data wasn't displayed in the UI.
* Root cause: decoding failed silently due to required non-optional fields missing for some items in a mixed-type JSON response (`artist` and `collection` objects).
* Fix: Changed all properties in `ArtistDetailModel` to optional (except `artistId`) to allow decoding of both object types reliably.
* After this, the detail view populated correctly and UI updated as expected.

> ✅ **Key Lesson:** Swift’s `Decodable` fails hard on missing fields—when dealing with flexible or inconsistent APIs like iTunes, optional properties offer a resilient solution.


### **3. Class vs. Struct for `ArtistModel`**

* Using a **class** led to:

  * No automatic initializer — manual one had to be written.
  * No synthesized `Codable` conformance — required custom encoding/decoding.
  * Increased boilerplate and cognitive load.
* Switching to a **struct** resolved this:

  * Enabled memberwise initializer and automatic `Codable`.
  * Better fit for immutable data and SwiftUI rendering.
  * Improved maintainability and clarity.

> ✅ **Conclusion:** Classes are ideal for view models (mutable state), but data models should be structs to leverage Swift’s automatic synthesis, value semantics, and safer immutability.


### **4. Preview and ViewModel Binding Issues**

* Initial previews showed empty lists due to incorrect view model instantiation.
* Problem: Creating or passing a new instance directly inside a view or failing to mark it as `@Bindable` or `@State` caused the view to not observe state changes.
* Solution:

  * In previews: used `@Previewable @State var viewModel = ArtistViewModel()`.
  * Passed view model as a direct instance (not a new one or binding) to `ArtistsView`.
  * Ensured consistent and observable data flow in both previews and runtime.

> ✅ **Key Lesson:** SwiftUI previews require shared state and properly scoped view models to reflect real behavior. Use `@State` or `@Observable` carefully and consistently.


### **5. List Duplication Due to Incorrect Identifiable ID**

* The `List` initially showed repeated or incorrect `trackName` values across rows.

* **Problem:** The `ArtistDetailModel` conformed to `Identifiable` using `artistId` as the unique identifier:

  ```swift
  var id: Int { artistId }
  ```

  Since all tracks shared the same `artistId`, SwiftUI treated every row as the same item, causing view reuse and incorrect data display.

* **Solution:**

  * I updated the identifier to use `trackId`, which is unique to each track:

    ```swift
    var id: Int { trackId ?? artistId }
    ```

  * This change ensured that SwiftUI could differentiate each item in the `ForEach` loop and render them accurately.

> ✅ **Key Lesson:** Always ensure `id` values in `Identifiable` models are truly unique within lists. Reusing IDs causes SwiftUI to incorrectly recycle views, leading to UI bugs and duplicated content.

