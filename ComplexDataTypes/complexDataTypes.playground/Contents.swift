import Cocoa

/* MARK: - Arrays Creation */

/*
 Create three different arrays:
 - One holding strings of people’s names
 - One holding integers of important numbers
 - One holding decimals of temperatures in Celsius
*/
var beatles = ["John", "Paul", "George", "Ringo"]
let numbers = [4, 8, 15, 16, 23, 42]
var temperatures = [25.3, 28.2, 26.4]

/* MARK: Modify Variable Array (.append()) */

beatles.append("Allen")
beatles.append("Adrian")
beatles.append("Novall")
beatles.append("Vivian")

/* MARK: Type Safety */

/*
 Swift knows that the beatles array contains strings, so when you read one value out you’ll always get a string.
 If you try to do the same with numbers, you’ll always get an integer.
 Swift won’t let you mix these two different types together, so this kind of code isn’t allowed
*/

// beatles and numbers are both arrays, but they are specialized types of arrays: one is an array of strings, and one is an array of integers.

let firstBeatle = beatles[0]
let firstNumber = numbers[0]

// Next line of code will produce an error
// Error: Binary operator '+' cannot be applied to operands of type 'String' and 'Int'
//let notAllowed = firstBeatle + firstNumber

/* MARK: Different Ways to Customize Arrays */

/* MARK: Array<Int>() ==  [Int]() == [100] */

var scores = [Int]()
scores.append(100)
scores.append(80)
scores.append(85)
print(scores[1])

var score = [Int]()
score.append(100)
score.append(80)
score.append(85)
print(score[1])

var sc = [100]

/* MARK: Array<String>() == [String]() == ["Folklore"] */

/*
 Swift’s type safety means that it must always know what type of data an array is storing.
 That might mean being explicit by saying albums is an Array<String>,
 but if you provide some initial values Swift can figure it out for itself:
*/

var albums = [String]()
albums.append("Folklore")
albums.append("Fearless")
albums.append("Red")

var album = [String]()
album.append("Folklore")
album.append("Fearless")
album.append("Red")

var al = ["Folklore"]

/* MARK: - Useful Functionalities */

/* MARK: Counts All Items in Array (.count) */

albums.count

/* MARK: Remove an Item in Array (.remove(at:)) */

albums.remove(at: 2)

/* MARK: Remove All Item in Array (.removeAll()) */

albums.removeAll()

/* MARK: Check an Items Existence in Array (.contains()) */

album.contains("Red")

/* MARK: Sort Array in Ascending Ordering (.sorted()) */

// Alphabetically for strings but numerically for numbers – the original array remains unchanged.

album.sorted()

/* MARK: Reverse Array Remembered (.reversed()) */

/*
 When you reverse an array, Swift is very clever – it doesn’t actually do the work of rearranging all the items,
 but instead just remembers to itself that you want the items to be reversed.
*/
album.reversed()

/* MARK: Danger of Arrays Accessibility */

// Accessing data by its position in the array can be annoying or even dangerous.

var employee = ["Taylor Swift", "Singer", "Nashville"]

print("Name: \(employee[0])")
print("Job title: \(employee[1])")
print("Location: \(employee[2])")

/*
 First, you can’t really be sure that employee[2] is their location – maybe that’s their password.
 Second, there’s no guarantee that item 2 is even there, particularly because we made the array a variable.
 This kind of code would cause serious problems
*/

print("Name: \(employee[0])")
employee.remove(at: 1)
print("Job title: \(employee[1])")

// That now prints Nashville as the job title, which is wrong, and will cause our code to crash when it reads employee[2], which is just bad.
//print("Location: \(employee[2])")

/* MARK: - Dictionaries Creations */

//  Dictionaries don’t store items according to their position like arrays do, but instead let us decide where items should be stored.
let employee2 = [
    "name": "Taylor Swift",
    "job": "Singer",
    "location": "Nashville",
]

// The following print statements will throw a warning: Expression implicitly coerced from 'String?' to 'Any'
print(employee2["name"])
print(employee2["job"])
print(employee2["location"])

/*
 In short, it tell us “you might get a value back, but you might get back nothing at all.”
 Swift calls these "optionals" because the existence of data is optional - it might be there or it might not.
*/

// Thus, when reading from a dictionary, you can provide a default value to use if the key doesn’t exist.

print(employee2["name", default: "Unknown"])
print(employee2["job", default: "Unknown"])
print(employee2["location", default: "Unknown"])

/* We can also create an empty dictionary using whatever explicit types you want to store, then set keys one by one */

//  [String: Int] means a dictionary with strings for its keys and integers for its values
var heights = [String: Int]()
heights["Yao Ming"] = 229
heights["Shaquille O'Neal"] = 216
heights["LeBron James"] = 206

// [String: String] means a dictionary with strings for its keys and strings for its values

var archEnemies = [String: String]()
archEnemies["Batman"] = "The Joker"
archEnemies["Superman"] = "Lex Luthor"

// Can also modify the value
archEnemies["Batman"] = "Penguin"

/* MARK: - Useful Functionalities */

/* MARK: Counts All Items in Dictionary (.count) */

heights.count

/* MARK: Remove All Item in Dictionary (.removeAll()) */

archEnemies.removeAll()

/* MARK: - Fast Lookup Using Sets*/

// Sets store them in a highly optimized order that makes it very fast to locate items

// Can’t add duplicate items, and they don’t store their items in a particular order.

let people = Set([
    "Denzel Washington", "Tom Cruise", "Nicolas Cage", "Samuel L Jackson",
])

// Set will automatically remove any duplicate values, and it won’t remember the exact order that was used in the array.
// You might see the names in the original order, but you might also get a completely different order – the set just doesn’t care what order its items come in.

// ["Samuel L Jackson", "Denzel Washington", "Tom Cruise", "Nicolas Cage"]
print(people)

// The second important difference when adding items to a set is visible when you add items individually.

var actors = Set<String>()
actors.insert("Denzel Washington")
actors.insert("Tom Cruise")
actors.insert("Nicolas Cage")
actors.insert("Samuel L Jackson")

/* MARK: - Useful Functionalities */

/* MARK: Counts All Items in Set (.count) */

actors.count

/* MARK: Sort Set in Ascending Ordering (.sorted()) */

// Alphabetically for strings but numerically for numbers – the original array remains unchanged.

actors.sorted()

/* MARK: Check an Items Existence in Set (.contains()) */

actors.contains("Samuel L Jackson")

/* MARK: Add an Items to Set (.insert()) */

actors.insert("Jackie Chan")

print(actors)

/* MARK: - Enums (Enumeration) Creations and Usage */

// A set of named values we can create and use in our code. They don’t have any special meaning to Swift, but they are more efficient and safer

/* Problem */

// Say you wanted to write some code to let the user select a day of the week

var selected = "Monday"

// Later on in your code you change it, like so:

selected = "Tuesday"

// Now, we might accidentally typed a month instead of a certain day

selected = "January"

// Or leave a space after a string as “Friday ” with a space is different from “Friday” without a space in Swift’s eyes
selected = "Friday "

/* Solution */

// This is where enums come in: they let us define a new data type with a handful of specific values that it can have

enum Weekday {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
}

enum WeekdayOneLiner {
    case monday, tuesday, wednesday, thursday, friday
}

// Now rather than using strings, we would use the enum
// With that change you can’t accidentally use “Friday ” with an extra space in there, or put a month name instead
var day = Weekday.monday
day = Weekday.tuesday
day = Weekday.friday

/*
 Remember that once you assign a value to a variable or constant, its data type becomes fixed
 You can’t set a variable to a string at first, then an integer later on.
 Well, for enums this means you can skip the enum name after the first assignment
*/

var days = Weekday.monday
days = .tuesday
days = .friday

/*
 One major benefit of enums is that Swift stores them in an optimized form
 when we say Weekday.monday Swift is likely to store that using a single integer such as 0,
 Which is much more efficient to store and check than the letters M, o, n, d, a, y.
*/

/* MARK: - Type Annotations */

/*
 Swift can usually determine the type of a constant or variable based on the value you assign to it.
 However, there are times when you don’t assign a value right away, or when you want to specify a different type than what Swift would infer.
 In those cases, you can use type annotations to explicitly declare the type.
 */

// explicitly telling the compiler that cities is of type [String]
// Even though we're also initializing it with an empty array (which would be enough for Swift to infer the type on its own)
var cities: [String] = []

/* MARK: Explicit Data Types */

// Type annotations let us be explicit about what data types we want
let surnameAnnon: String = "Lasso"
var scoreAnnon: Int = 0
var scoreDouble: Double = 0

// String holds text
let playerName: String = "Roy"

// Int holds whole numbers
var luckyNumber: Int = 13

// Double holds decimal numbers:
let pi: Double = 3.141

// Bool holds either true or false:
var isAuthenticated: Bool = true

 
// Array holds lots of different values, all in the order you add them.
// This must be specialized, such as [String]
var albumsAnnon: [String] = ["Red", "Fearless"]

// Dictionary holds lots of different values, where you get to decide how data should be accessed.
// This must be specialized, such as [String: Int]
var user: [String: String] = ["id": "@twostraws"]

// Set holds lots of different values, but stores them in an order that’s optimized for checking what it contains.
// This must be specialized, such as Set<String>
var books: Set<String> = Set(["The Bluest Eye", "Foundation", "Girl, Woman, Other"])


// If you wanted to create an empty array of strings, you’d need to know the type:
var teams: [String] = [String]()

/* MARK: Invalid Type Annotation Example */

// Type annotations let us override Swift’s type inference,
// but the code must still be valid.
// The following line will cause an error:
// Error: Cannot convert value of type 'String' to specified type 'Int'
// let scoreInvalid: Int = "Zero"


/* MARK: - Type Inference*/

// Swift infers that `surname` is a `String` because it’s assigned a piece of text, and it infers that `score` is an `Int` because it’s assigned a whole number.
let surnameStr = "Lasso"
var scoreInt = 0

// Swift infers that clues is of type [String] (an array of strings) based on the initializer [] and the explicit element type String provided in [String]().
var clues = [String]()



/* MARK: - Golden Rule */

/*
 Whether you use type inference or type annotation, one rule always applies: Swift must always know the exact data type of every constant and variable.
 This is a fundamental part of Swift being a type-safe language
 It will prevents us from writing invalid code like '5 + true', where the types don’t make sense together.
 */

/* MARK: - Summary */

/*
 Arrays, dictionaries, and sets are Swift’s main ways to store collections of values, each with its own use case:

    - Arrays hold ordered values of a single type, accessed by integer indices, and provide handy methods like count, append(), and contains().

    - Dictionaries store values paired with unique keys, requiring a specific type for keys and values, and offer similar functionality to arrays.

    - Sets hold unique values without a defined order and are optimized for quickly checking membership.

 Enums let us define custom types with a fixed set of possible values, useful for representing things like user actions, file types, or notifications.

 Swift requires knowing the type of every constant or variable, mostly using type inference based on assigned values, but you can also specify types explicitly with type annotations.

 In practice, we'll use arrays most often, followed by dictionaries, with sets being more specialized but valuable when needed.
*/


/* MARK: Checkpoint 2 */

/*
 Create an array of strings (faveGames).

 Print the total number of items with faveGames.count.

 Convert the array to a Set to get unique items.

 Get the count of unique items with uniqueItems.count.
*/

let faveGames = ["Monster Hunters", "Elden Ring", "Dark Souls: Remastered", "Dark Souls: Remastered"]

print("Total items: \(faveGames.count)")

let uniqueItems = Set(faveGames)

print("Unique items: \(uniqueItems.count)")
