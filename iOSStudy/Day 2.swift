//
//  Day 2.swift
//  iOSStudy
//
//  Created by LMC60018 on 2023/12/28.
//

import Foundation

// 1. Functions
func greet(person: String) -> String {
    return "Hello, " + person + "!"
}

// Multiple Return Values
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array.min()
    var currentMax = array.max()
    return (currentMin!, currentMax!)
}

// "from" is a function argument label
func greet(person: String, from hometown: String) -> String {
    // If the entire body of the function is a single expression, “return” can be hidden.
   "Hello \(person)!  Glad you could visit from \(hometown)."
}

// _ Omitting Argument Labels; ... Variadic Parameters
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}

// In-Out Parameters: modify a parameter’s value
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

// Function Types as Parameter Types
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}

// Function Types as Return Types
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}

// Nested Functions
func chooseStepFunction2(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}

private func Functions() {
    // Calling Functions
    print(greet(person: "Anna"))
    // Prints "Hello, Anna!"
    
    // Multiple Return Values
    let bounds = minMax(array: [8, -6, 2, 109, 3, 71])
    print("min is \(bounds.min) and max is \(bounds.max)")
    
    // function argument labels
    print(greet(person: "Bill", from: "Cupertino"))
    
    // Variadic Parameters
    print(arithmeticMean(1, 2, 3, 4, 5))
    print(arithmeticMean(3, 8.25, 18.75))
    
    // In-Out Parameters
    var someInt = 3
    var anotherInt = 107
    swapTwoInts(&someInt, &anotherInt)
    
    //Function Types as Parameter Types
    printMathResult(addTwoInts, 3, 5)
    
    // Function Types as Return Types
    var currentValue = 3
    let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
}


// 2. Closures
private func Closures() {
    // Closure Expression
    let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    var reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
        return s1 > s2
    })
    // reversedNames is equal to ["Ewa", "Daniella", "Chris", "Barry", "Alex"]
    // Inferring Type From Context
    var reversedNames2 = names.sorted(by: { s1, s2 in return s1 > s2 })
    
    // Implicit Returns from Single-Expression Closures
    var reversedNames3 = names.sorted(by: { (s1, s2) in s1 > s2 })
    
    // Shorthand Argument Names
    var reversedNames4 = names.sorted(by: { $0 > $1 } )
    
    // Operator Methods
    var reversedNames5 = names.sorted(by: >)
    
    // Trailing Closures, place closure after method
    var reversedNames6 = names.sorted() { $0 > $1 }
    // () can be omitted when the closure expression is provided as the method’s only argument
    var reversedNames7 = names.sorted { $0 > $1 }
    
    // multiple closures
    // omit the argument label for the first trailing closure and label the remaining trailing closures
//    func loadPicture(from: someServer) { picture in
//        someView.currentPicture = picture
//    } onFailure: {
//        print("Couldn't download the next picture.")
//    }
    
    // Capturing Values
    let incrementByTen = makeIncrementer(forIncrement: 10)
    incrementByTen()
    // returns a value of 10
    incrementByTen()
    // returns a value of 20
    incrementByTen()
    // returns a value of 30
    let incrementBySeven = makeIncrementer(forIncrement: 7)
    incrementBySeven()
    // returns a value of 7
    incrementByTen()
    // returns a value of 40, incrementByTen doesn’t affect the variable captured by incrementBySeven
    
    // Closures Are Reference Types
    let alsoIncrementByTen = incrementByTen
    alsoIncrementByTen()
    // returns a value of 50
    incrementByTen()
    // returns a value of 60
    
    // Escaping Closures
    let instance = SomeClass()
    instance.doSomething()
    print(instance.x)
    // Prints "200"
    completionHandlers.first?()
    print(instance.x)
    // Prints "100"
    
    
    // Autoclosures, automatically created to wrap an expression that’s being passed as an argument to a function, doesn’t take any arguments
    // Autoclosure delays evaluation, because the code inside isn’t run until the closure is called
    var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    print(customersInLine.count)
    // Prints "5"
    // the type of customerProvider is ()->String
    let customerProvider = { customersInLine.remove(at: 0) }
    print(customersInLine.count)
    // Prints "5"
    print("Now serving \(customerProvider())!")
    // Prints "Now serving Chris!"
    print(customersInLine.count)
    // Prints "4"
    
    // Autoclosure as argument to a function
    // version 1
    func serve1(customer customerProvider: () -> String) {
        print("Now serving \(customerProvider())!")
    }
    serve1(customer: { customersInLine.remove(at: 0) } )
    // version 2
    func serve2(customer customerProvider: @autoclosure () -> String) {
        print("Now serving \(customerProvider())!")
    }
    serve2(customer: customersInLine.remove(at: 0))
}

// Capturing Values
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        // The nested incrementer() function captures two values, runningTotal and amount, from its surrounding context
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

// Escaping Closures, using in asynchronous operations
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    //the closure is passed as an argument to the function
    completionHandlers.append(completionHandler)
}
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}
class SomeClass {
    var x = 10
    func doSomething() {
        // the function with closure refers to self explicitly
        someFunctionWithEscapingClosure { self.x = 100 }
        // someFunctionWithEscapingClosure { [self] in x = 100 }    // another version with capturing self
        someFunctionWithNonescapingClosure { x = 200 }
    }
}


// 3. Enumerations
private func Enumerations() {
    // Syntax
    // CaseIterable enables enum to iterate
    enum CompassPoint: CaseIterable {
        case north
        case south
        case east
        case west
    }
    var directionToHead = CompassPoint.west
    // type inferring
    directionToHead = .east
    // Matching Enumeration Values with a Switch Statement
    switch directionToHead {
    case .north:
        print("Lots of planets have a north")
    case .south:
        print("Watch out for penguins")
    case .east:
        print("Where the sun rises")
    case .west:
        print("Where the skies are blue")
    }
    // iterate an enum
    let numberOfChoices = CompassPoint.allCases.count
    
    // Associated Values with enum (or initial the case with =)
    enum Barcode {
        case upc(Int, Int, Int, Int)
        case qrCode(String)
    }
    var productBarcode = Barcode.upc(8, 85909, 51226, 3)
    // check the instance with a switch statement
    switch productBarcode {
    case .upc(let numberSystem, let manufacturer, let product, var check):
        print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
    case let .qrCode(productCode):
        print("QR code: \(productCode).")
    }
    
    // Implicitly Assigned Raw Values
    enum Planet: Int {
        case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    }
    let earthsOrder = Planet.earth.rawValue
    // earthsOrder is 3
    
    // Initializing from a Raw Value
    let possiblePlanet = Planet(rawValue: 7)
    // possiblePlanet is of type Planet? and equals Planet.uranus
    
    // Recursive Enumerations, the enumeration as the associated value for one or more of the enumeration case
    // indirect can also be written before the enum
    enum ArithmeticExpression {
        case number(Int)
        indirect case addition(ArithmeticExpression, ArithmeticExpression)
        indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
    }
}

// 4. Structures and Classes
// Definition Syntax
struct Resolution {
  var width = 0
  var height = 0
}
class VideoMode {
  var resolution = Resolution()
  var interlaced = false
  var frameRate = 0.0
  var name: String?
}

private func StructuresAndClasses() {
    // Memberwise Initializers for Structure Types
    let vga = Resolution(width: 640, height: 480)
    // Structures and Enumerations Are Value Types, cinema and vga are two different instances without impacting on each other
    var cinema = vga
    cinema.width = 2048
    // cinema is now 2048 , hd is still 1920
    
    // Classes Are Reference Types
    let tenEighty = VideoMode()
    tenEighty.resolution = vga
    tenEighty.interlaced = true
    tenEighty.name = "1080i"
    tenEighty.frameRate = 25.0
    let alsoTenEighty = tenEighty
    alsoTenEighty.frameRate = 30.0
    // tenEighty.frameRate now 30.0
    
    //Identity Operators, to find out whether two constants or variables refer to exactly the same instance of a class
    if tenEighty === alsoTenEighty {
        print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
    }
}
