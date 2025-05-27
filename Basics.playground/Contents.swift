import Cocoa

/* MARK: - Variables and Constants Creation */

// Use `var` to declare variables (mutable values)
var name = "Alex"
name = "Ken"
name = "David"

/*
 Use `let` to declare a constant (immutable value)
 Prefer using constants (`let`) unless mutation is necessary
*/

let character = "Kevin"

// Uncommenting the next line will cause an error:
// Error: Cannot assign to value: 'character' is a 'let' constant
// character = "Alex"

// Console log statement
print(character)

/* MARK: - Strng Creation */

// Assigning text to a constant or variable, we call that a string

var nameVariable = "Alex"
let characterConstant = "Kevin"

// Use double quotes inside your string, must put a backslash
let quote = "Then he tapped a sign saying \"Believe\" and walked away."

// Multiple lines string

// Use three quotes on either side of your string
let movie = """
    A day in
    the life of an
    Apple engineer
    """

/* MARK: Read String Length (.count)*/

// Strings are case-sensitive in Swift

// 4
print(nameVariable.count)

/* MARK: Uppercase Entire String Length (.uppercased())*/

// KEVIN
print(characterConstant.uppercased())

/* MARK: Does String Start With Some Letter (.hasPrefix())*/

// true
print(characterConstant.hasPrefix("K"))

/* MARK: Does String End With Some Letter (.hasSuffix())*/

// true
print(characterConstant.hasSuffix("vin"))

// false: no "o" at the end of kevin
print(characterConstant.hasSuffix("ovin"))

/* MARK: - Whole Number Creation */

/*
 Making a new integer works just like making a string:
 - Use 'let' or 'var' depending on whether you want a constant or variable
 - Provide a name
 - Then give it a value
*/

var score = 10

// Use underscores, _, to break up numbers however you want
// Swift doesn’t actually care about the underscores

// 100,000,000
let reallyBig = 100_000_000

// 100,000,000
let reallyBigUnderScores = 10__0_000_00__0

/*
 Can also create integers from other integers, using the kinds of arithmetic operators:
 - '+' for addition
 - '-' for subtraction
 - '*' for multiplication
 - '/' for division
*/

let lowerScore = score - 2
let higherScore = score + 10
let doubledScore = score * 2
let squaredScore = score * score
let halvedScore = score / 2

/* MARK: Compound Assigment Operators */

print(score)
score *= 2
print(score)
score -= 10
print(score)
score /= 2
print(score)

/* MARK: Check is Integer a Multiple of Another Integer (.isMultiple())*/

let number = 120
print(number.isMultiple(of: 3))


/* MARK: - Decimal Number Creation */

/*
 Working with decimal numbers such as 3.1, 5.56, or 3.141592654
 We’re working with what Swift calls floating-point numbers
 Stored in a complexed way by computer
*/

/*
 Floating-point numbers are complex is because computers are trying to use binary to store complicated numbers.
 For example, if you divide 1 by 3 we know you get 1/3,
 but that can’t be stored in binary so the system is designed to create very close approximations.
*/

// 0.30000000000000004
let numberFloat = 0.1 + 0.2
print(numberFloat)

/* MARK: Double (double-precision floating-point number)*/

/*
 when you create a floating-point number, Swift considers it to be a Double.
 That’s short for “double-precision floating-point number”
 Swift allocates twice the amount of storage as some older languages would do, meaning a Double can store absolutely massive numbers
*/

/* MARK: Type Safety */

// Swift won’t let us mix different types of data by accident.

/*
 Swift considers decimals to be a wholly different type of data to integers
 which means you can’t mix them together. After all, integers are always 100% accurate
 Whereas decimals are not, so Swift won’t let you put the two of them together unless you specifically ask for it to happen
*/
let a = 1
let b = 2.0

// Next line of code produces and error
// Error: Binary operator '+' cannot be applied to operands of type 'Int' and 'Double'
// let c = a + b

/*
 To fix: Tell Swift explicitly that it should either:
 - Treat the Double inside b as an Int
 - Treat the Int inside a as a Double
*/

let bInt = a + Int(b)
let aDouble = Double(a) + b


/*
 Swift decides whether you wanted to create a Double or an Int based on the number you provide:
 – If there’s a dot in there, you have a Double
 - Otherwise it’s an Int
 Even if the numbers after the dot are 0.
*/
let double1 = 3.1
let double2 = 3131.3131
let double3 = 3.0
let int1 = 3

// Once Swift has decided what data type a constant or variable holds, it must always hold that same data type
var nameString = "Nicolas Cage"

// Next line of code produces an error
// Error: Cannot assign value of type 'Int' to type 'String'
// nameString = 57

// Decimal numbers have the same range of operators and compound assignment operators as integers
var rating = 5.0
rating *= 2

/* MARK: Older APIs */

/*
 Many older APIs use a slightly different way of storing decimal numbers, called CGFloat.
 Fortunately, Swift lets us use regular Double numbers everywhere a CGFloat is expected
 So, although you will see CGFloat appear from time to time you can just ignore it.
*/

/* MARK: - Booleans Creation */

// Booleans were named after George Boole, an English mathematician who spent a great deal of time researching and writing about logic


/*
 Both hasSuffix() and isMultiple(of:) return a new value based on their check:
 - Either the string has the suffix or it doesn’t,
 - Either 120 is a multiple of 3 or it isn’t.
*/
let filename = "paris.jpg"
print(filename.hasSuffix(".jpg"))

let checkNumber = 120
print(checkNumber.isMultiple(of: 3))


/*
 Booleans do have one special operator: '!', which means “not”.
 This flips a Boolean’s value from true to false, or false to true.
*/
var isAuthenticated = false
isAuthenticated = !isAuthenticated
isAuthenticated = !isAuthenticated

/* MARK: Flips Values from False to True / True to False (.toggle())*/

var gameOver = false
gameOver.toggle()

/* MARK: - String Joining */

/*
 Swift gives us two ways to combine strings together:
 - Joining them using +
 - String interpolation technique that can place variables of any type directly inside strings.
*/

/* MARK: Joining them using '+' */

let firstPart = "Hello, "
let secondPart = "world!"
let greeting = firstPart + secondPart

let people = "Haters"
let action = "hate"
let lyric = people + " gonna " + action
print(lyric)

// Operator Overloading

// Use Int and Double will add numbers together
// Never use this technique as much, as it makes new strings each time its being concatenated

let luggageCode = "1" + "2" + "3" + "4" + "5"

/*
 Swift can’t join all those strings in one go. Instead:
 it will join the first two to make “12”,
 then join “12” and “3” to make “123”,
 then join “123” and “4” to make “1234”,
 and finally join “1234” and “5” to make “12345”
 
 It makes temporary strings to hold “12”, “123”, and “1234” even though they aren’t ultimately used when the code finishes.
*/

/* MARK: String Interpolation */

/*  Write a backslash inside your string, then place the name of a variable or constant inside parentheses.*/

let nameT = "Taylor"
let age = 26
let message = "Hello, my name is \(nameT) and I'm \(age) years old."
print(message)

/*
 String interpolation is much more efficient than using + to join strings one by one,
 but there’s another important benefit too: you can pull in integers, decimals, and more with no extra work.

 Using '+' lets us add strings to strings, integers to integers, and decimals to decimals
 but doesn’t let us add integers to strings
*/

let number11 = 11
// Next line produces an error
// Error: Cannot convert value of type 'Int' to expected argument type 'String'
// let missionMessage = "Apollo " + number + " landed on the moon."

/*
To fix:
 - Treat the number like a string
 - Use string interpolation
*/

let missionMessageString = "Apollo " + String(number) + " landed on the moon."
let missionMessageStrInter = "Apollo \(number) landed on the moon."

// Can also put calculations inside string interpolation
print("5 x 5 is \(5 * 5)")


/* MARK: - Recap*/


/*
 - Swift lets us create constants using let, and variables using var.
 
 - If you don’t intend to change a value, make sure you use let so that Swift can help you avoid mistakes.
 
 - Swift’s strings contain text, from short strings up to whole novels. They work great with emoji and any world language, and have helpful functionality such as count and uppercased().
 
 - You create strings by using double quotes at the start and end, but if you want your string to go over several lines you need to use three double quotes at the start and end.
 
 - Swift calls its whole numbers integers, and they can be positive or negative. They also have helpful functionality, such as isMultiple(of:).
 
 - In Swift decimal numbers are called Double, short for double-length floating-point number. That means they can hold very large numbers if needed, but they also aren’t 100% accurate – you shouldn’t use them when 100% precision is required, such as when dealing with money.

 - There are lots of built-in arithmetic operators, such as +, -, *, and /, along with the special compound assignment operators such as += that modify variables directly.
 
 - You can represent a simple true or false state using a Boolean, which can be flipped using the ! operator or by calling toggle().
 
 - String interpolation lets us place constants and variables into our strings in a streamlined, efficient way.
*/


/* MARK: - Checkpoint*/

// Creates a constant holding any temperature in Celsius.

let celsius = 25.0

// Converts it to Fahrenheit by multiplying by 9, dividing by 5, then adding 32.

let fahrenheit = (celsius * 9.0 / 5.0) + 32.0

// Prints the result for the user, showing both the Celsius and Fahrenheit values.

print("\(celsius) degrees Celsius is equal to \(fahrenheit) degrees Fahrenheit.")
