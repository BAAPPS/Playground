# Summary

### Day 5 – If, switch, and the ternary operator

---

#### `if` / `else`
- Best for simple, readable branching.
- Supports `else if` to handle multiple conditions.
- Use when logic is linear or straightforward.

```swift
if age >= 18 {
    print("You can vote")
} else {
    print("Too young")
}
````

---

#### Combining Conditions (`&&` and `||`)

* `&&`: All conditions must be true.
* `||`: Any one condition can be true.
* Tip: No need to write `== true` — just use the Boolean directly.

```swift
if age >= 18 || hasParentalConsent {
    print("Access granted")
}
```

---

#### Enums with `if / else if`

* Enums define a set of named cases.
* Use `.case` shorthand after assigning the enum once.
* Improves clarity when comparing options.

```swift
enum Transport { case bike, car, plane }
let option = Transport.plane

if option == .plane {
    print("Flying high")
}
```

---

#### `switch` Statements

* Best for handling many specific values (e.g. enums, strings).
* Must cover all cases or include `default`.
* More structured and safer than multiple `if` checks.

```swift
switch option {
case .bike:
    print("Pedal power")
case .car:
    print("Drive safe")
case .plane:
    print("Airborne!")
}
```

---

#### Ternary Conditional Operator

* Compact `if` / `else` for value assignment or short expressions.
* Format: `condition ? trueValue : falseValue`
* Especially useful inside SwiftUI views or expressions.

```swift
let voteStatus = age >= 18 ? "Yes" : "No"
```

---

#### Summary Tips:

* Use `if / else` for simple logic.
* Combine checks efficiently with `&&` and `||`.
* Prefer `switch` for multiple clean, exhaustive branches.
* Use enums to represent known states clearly.
* Apply the ternary operator for concise, inline decisions.
