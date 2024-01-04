//
//  main.swift
//  iOSStudy
//
//  Created by LMC60018 on 2023/12/28.
//

import Foundation

private func TheBasics() {
    // 1. Constants and Variables
    let maximumNumberOfLoginAttempts: Int = 10
    var currentLoginAttempt: UInt = 0

    // 2. Types
    // typy Annotations，Type Inference
    let three = 3
    let pointOneFourOneFiveNine = 0.14159
    let pi = Double(three) + pointOneFourOneFiveNine

    // Type Aliases
    typealias AudioSample = UInt16
    var maxAmplitudeFound = AudioSample.min
    // maxAmplitudeFound is now 0
    
    // Tuples
    let http404Error = (404, "Not Found")
    let (justTheStatusCode, _) = http404Error  //忽略不需要的元素
    print("The status code is \(justTheStatusCode)")
    // Prints "The status code is 404"
    print("The status code is \(http404Error.0)")
    
    
    // 3. Optional
    let possibleNumber = "123"
    let convertedNumber = Int(possibleNumber)
    // The type of convertedNumber is "optional Int"

    // Nil
    var serverResponseCode: Int? = 404
    // serverResponseCode contains an actual Int value of 404
    serverResponseCode = nil
    // serverResponseCode now contains no value
    
    // Optional Binding
    let myNumber = Int(possibleNumber)
    // Here, myNumber is an optional integer
    if let myNumber {
        // Here, myNumber is a non-optional integer
        print("My number is \(myNumber)")
    }
    
    // Fallback Value
    let name: String? = nil
    let greeting = "Hello, " + (name ?? "friend") + "!"
    print(greeting)
    // Prints "Hello, friend!"
    
    //Force Unwrapping
    let possibleString: String? = "An optional string."
    let forcedString: String = possibleString! // Requires explicit unwrapping
    
    //Implicitly Unwrapped Optionals
    let assumedString: String! = "An implicitly unwrapped optional string."
    let implicitString: String = assumedString // Unwrapped automatically
    
    
    // 4.Error Handling
    func canThrowAnError() throws {
        // this function may or may not throw an error
    }
    do {
        try canThrowAnError()
        // no error was thrown
    } catch {
        // an error was thrown
    }
    
    // Assertions
    let age = -3
    assert(age >= 0, "A person's age can't be less than zero.")

    // Preconditions
    var index = 1
    precondition(index > 0, "Index must be greater than zero.")
}

private func BasicOperators() {
    // 1. Nil-Coalescing Operator
    // ??  like a != nil ? a! : b
    let defaultColorName = "red"
    var userDefinedColorName: String?   // defaults to nil
    var colorNameToUse = userDefinedColorName ?? defaultColorName
    // userDefinedColorName is nil, so colorNameToUse is set to the default of "red"
    
    // 2.Range Operators
    // Closed Range Operator: a...b
    // Half-Open Range Operator: a..<b
    // One-Sided Ranges: a... || ...b
}

private func StringsAndChars() {
    // 1.Multiline String Literals
    let softWrappedQuotation = """
    The White Rabbit put on his spectacles.  "Where shall I begin, \
    please your Majesty?" he asked.

    "Begin at the beginning," the King said gravely, "and go on \
    till you come to the end; then stop."
    """
    
    //String Delimiters
    let threeDoubleQuotationMarks = """
    Escaping the first quotation mark \"""
    Escaping all three quotation marks \"\"\"
    """
    let threeMoreDoubleQuotationMarks = #"""
    Here are three more double quotes: """
    """#
    
    // 2.Special Characters
    let sparklingHeart = "\u{1F496}" // 💖, Unicode scalar U+1F496
    
    // 3.Initialize
    var emptyString = ""
    var anotherEmptyString = String()
    
    // 4. Concatenating
    let string1 = "hello"
    let string2 = " there"
    var welcome = string1 + string2
    // welcome now equals "hello there"
    
    var instruction = "look over"
    instruction += string2
    // instruction now equals "look over there"
    
    let exclamationMark: Character = "!"
    welcome.append(exclamationMark)
    // welcome now equals "hello there!"
    
    // 5.Accessing and Modifying a String
    // String Indices
    let greeting = "Guten Tag!"
    greeting[greeting.startIndex]   //startIndex = 0
    // G
    greeting[greeting.index(before: greeting.endIndex)]   //endIndex = n, before = -1
    // !
    greeting[greeting.index(after: greeting.startIndex)]   //after = +1
    // u
    let index = greeting.index(greeting.startIndex, offsetBy: 7)
    greeting[index]
    // a
    
    // insert
    var welcome2 = "hello"
    welcome2.insert("!", at: welcome2.endIndex)
    // welcome now equals "hello!"
    
    // remove
    let range = welcome2.index(welcome2.endIndex, offsetBy: -7)..<welcome2.endIndex
    welcome2.removeSubrange(range)
    // welcome now equals "hello"
    
    
    // 6.Substrings
    let greeting2 = "Hello, world!"
    let index2 = greeting2.firstIndex(of: ",") ?? greeting2.endIndex
    let beginning = greeting2[..<index2]
    // beginning is "Hello"
    
    // Convert the result to a String for long-term storage.
    let newString = String(beginning)
    
    // 7.Prefix and Suffix Equality
    let romeoAndJuliet = [
        "Act 1 Scene 1: Verona, A public place",
        "Act 1 Scene 2: Capulet's mansion",
        "Act 1 Scene 3: A room in Capulet's mansion",
        "Act 1 Scene 4: A street outside Capulet's mansion",
        "Act 1 Scene 5: The Great Hall in Capulet's mansion",
        "Act 2 Scene 1: Outside Capulet's mansion",
        "Act 2 Scene 2: Capulet's orchard",
        "Act 2 Scene 3: Outside Friar Lawrence's cell",
        "Act 2 Scene 4: A street in Verona",
        "Act 2 Scene 5: Capulet's mansion",
        "Act 2 Scene 6: Friar Lawrence's cell"
    ]
    var act1SceneCount = 0
    for scene in romeoAndJuliet {
        if scene.hasPrefix("Act 1 ") {
            act1SceneCount += 1
        }
    }
    print("There are \(act1SceneCount) scenes in Act 1")
    // Prints "There are 5 scenes in Act 1"
    var mansionCount = 0
    for scene in romeoAndJuliet {
        if scene.hasSuffix("Capulet's mansion") {
            mansionCount += 1
        }
    }
    print("\(mansionCount) mansion scenes")
    // Prints "6 mansion scenes"
}

private func CollectionTypes() {
    // 1.Array
    // Creating an Empty Array
    var someInts: [Int] = []
    
    // Initialing
    var threeDoubles = Array(repeating: 0.0, count: 3)
    var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
    // anotherThreeDoubles is of type [Double], and equals [2.5, 2.5, 2.5]
    var sixDoubles = threeDoubles + anotherThreeDoubles
    // sixDoubles is inferred as [Double], and equals [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]
    
    // 2.Set
    // Creating a Set
    var letters = Set<Character>()
    var favoriteGenres: Set = ["Rock", "Classical", "Hip hop"]
    
    //Set Operations
    let oddDigits: Set = [1, 3, 5, 7, 9]
    let evenDigits: Set = [0, 2, 4, 6, 8]
    let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

    oddDigits.union(evenDigits).sorted()
    // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    oddDigits.intersection(evenDigits).sorted()
    // []
    oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
    // [1, 9]
    oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
    // [1, 2, 9]
    
    let houseAnimals: Set = ["🐶", "🐱"]
    let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
    let cityAnimals: Set = ["🐦", "🐭"]
    houseAnimals.isSubset(of: farmAnimals)
    // true
    farmAnimals.isSuperset(of: houseAnimals)
    // true
    farmAnimals.isDisjoint(with: cityAnimals)
    // true
    
    // 3.Dictionary
    // Creating a Dictionary
    var namesOfIntegers: [Int: String] = [:]
    var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
    
    // modify a Dictionary
    airports["DUB"] = "Dublin Airport"
    if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
        print("The old value for DUB was \(oldValue).")
    }
    //forKey 可以返回旧值，若不存在旧值则返回空
    
    airports["DUB"] = nil
    // DUB has now been removed from the dictionary
    if let removedValue = airports.removeValue(forKey: "DUB") {
        print("The removed airport's name is \(removedValue).")
    } else {
        print("The airports dictionary doesn't contain a value for DUB.")
    }
    
    //iterating
    for (airportCode, airportName) in airports {
        print("\(airportCode): \(airportName)")
    }
}

private func ControlFlow() {
    // 1. Loop
    // for-in with step
    let minuteInterval = 5
    let minutes = 60
    for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
        // render the tick mark every 5 minutes (0, 5, 10, 15 ... 45, 50, 55)
    }
    for tickMark in stride(from: 0, through: minutes, by: minuteInterval) {
        // render the tick mark every 5 minutes (0, 5, 10, 15 ... 45, 50, 55, 60)
    }
    
    // 2.Condition
    // branch’s value is used as the value for the whole if expression, same for switch-case-default statesment
    let temperatureInCelsius = 25
    let weatherAdvice = if temperatureInCelsius <= 0 {
        "It's very cold. Consider wearing a scarf."
    } else if temperatureInCelsius >= 30 {
        "It's really warm. Don't forget to wear sunscreen."
    } else {
        "It's not that cold. Wear a T-shirt."
    }
    
    //tuple
    let somePoint = (1, 1)
    switch somePoint {
    case (0, 0):
        print("\(somePoint) is at the origin")
    case (_, 0):
        print("\(somePoint) is on the x-axis")
    case (0, _):
        print("\(somePoint) is on the y-axis")
    case (-2...2, -2...2):
        print("\(somePoint) is inside the box")
    default:
        print("\(somePoint) is outside of the box")
    }
    // Prints "(1, 1) is inside the box"
    
    // Value Bindings
    let anotherPoint = (2, 0)
    switch anotherPoint {
    case (let x, 0):
        print("on the x-axis with an x value of \(x)")
    case (0, let y):
        print("on the y-axis with a y value of \(y)")
    case let (x, y):
        print("somewhere else at (\(x), \(y))")
    }
    // Prints "on the x-axis with an x value of 2"
    
    // where
    let yetAnotherPoint = (1, -1)
    switch yetAnotherPoint {
    case let (x, y) where x == y:
        print("(\(x), \(y)) is on the line x == y")
    case let (x, y) where x == -y:
        print("(\(x), \(y)) is on the line x == -y")
    case let (x, y):
        print("(\(x), \(y)) is just some arbitrary point")
    }
    
    // Labeled Statements
//    gameLoop: while square != finalSquare {
//        ...
//        switch square + diceRoll {
//        case finalSquare:
//            break gameLoop
//        case let newSquare where newSquare > finalSquare:
//            continue gameLoop
//        default:
//            ...
//        }
//    }
    
    // guard   Exit earlier if not meet the condition
    let person = ["name": "John"]
    guard let name = person["name"] else {
        return
    }
    print("Hello \(name)!")
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")
    
    //defer
    var score = 1
    if score < 10 {
        defer {
            print(score)
        }
        defer {
               print("The score is:")
           }
        score += 5
    }
    // Prints "The score is:"
    // Prints "6"

    //Checking API Availability
    if #available(iOS 10, macOS 10.12, *) {
        // Use iOS 10 APIs on iOS, and use macOS 10.12 APIs on macOS
    } else {
        // Fall back to earlier iOS and macOS APIs
    }
    
    if #unavailable(iOS 10) {
        // Fallback code
    }
    
}


// Test 1
func Plalindrome() {
    let str = "asdfds"
    guard (str != String(str.reversed())) else {
        print("The string is a plalindrome.")
        return
    }
    print("The string is not a plalindrome.")
}

func SumFilteredArray() {
    let someInts = [9, 2, 3, 7, 5, 6, 4, 8, 1]
    let sumFiltered = someInts.filter{ $0 != someInts.max() }.filter{ $0 != someInts.min() }.filter { $0 % 2 != 0 }.reduce(0, +)
    print (sumFiltered)
}

VehicleProgram()
