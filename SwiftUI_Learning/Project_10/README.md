# Cupcake Corner

A multi-screen SwiftUI app for ordering cupcakes online. Built to demonstrate form handling, data validation, network communication, and the power of Swift’s `Codable` protocol.

---

## What You'll Learn

* Building multi-screen SwiftUI apps with `NavigationStack`
* Creating and validating user input forms
* Sending and receiving data over the internet
* Encoding and decoding data using `Codable`
* Comparing modern data handling with legacy tools like `UserDefaults`

---

## What the App Does

* Lets users customize and place cupcake orders
* Collects delivery and payment details
* Validates user input before allowing orders
* Submits order data to a test web service and shows confirmation

---

## Project Structure

```text
CupecakeCorner/
├── Models/
│   └── OrderModel.swift
|── Views/
│   └── AddressView.swift
│   └── CheckoutView.swift
│   └── ContentView.swift
├── Assets.xcassets/
```
---

## Final Thoughts

This project offered a great opportunity to go beyond the tutorial and solve real-world SwiftUI and networking issues. 

Here's a reflection on the key problems encountered and how they were addressed:

### Problem 1: JSON Encoding with Underscored Properties

When using the `@Observable` macro, the properties in the `OrderModel` were automatically rewritten with leading underscores (e.g., `_type`, `_quantity`). This caused issues when encoding the order into JSON — the keys didn't match what the server expected.

**Solution:**  
A custom `CodingKeys` enum was added to map the internal underscored property names to clean, expected JSON keys. This ensured compatibility with the server API.

### Problem 2: Server Response Fails Without API Key

Initially, all requests to the `reqres.in` API failed with a decoding error:

> "The data couldn’t be read because it is missing."

This error was misleading — the real issue was that the server was returning an error JSON due to a missing API key.

**Solution:**  
We inspected the raw server response using **LLDB** and debug print statements. Once the API key was added to the request headers via:

```swift
request.setValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
````

— the server began responding correctly.


### Problem 3: Network Failures Silently Failing

Without proper error handling, failed network requests (like when offline or using invalid configuration) would simply show decoding errors with no feedback to the user.

**Solution:**
We added a second alert for network errors, so users get clear, actionable feedback if something goes wrong during checkout.

### Problem 4: User Input Not Saved

By default, SwiftUI does not persist form input (like name and address) between views or launches. Losing data like this would frustrate real users.

**Solution:**
We implemented manual save/load logic using `UserDefaults` and `Codable`. The order is saved when the user taps “Check out,” ensuring that delivery info is preserved.

### Outcome

By solving these real-world issues — from decoding failures and API miscommunication to input persistence and navigation — the CupcakeCorner app became more robust, more user-friendly, and closer to what you'd build in a production environment.

This exercise was a valuable deep dive into **networking, validation, error handling, persistence, and debugging**, all while working in the SwiftUI and iOS 17+ ecosystem.
