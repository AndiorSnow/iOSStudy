//
//  Day 5.swift
//  iOSStudy
//
//  Created by LMC60018 on 2024/1/3.
//

import Foundation

// 1. Protocols
func Protocols() {
    // Mutating Method Requirements
    var lightSwitch = OnOffSwitch.off
    lightSwitch.toggle()
    // lightSwitch is now equal to .on
    
    // Protocols as Types
    let d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
    for _ in 1...5 {
        print("Random dice roll is \(d6.roll())")
    }
    
    // Delegation
    let tracker = DiceGameTracker()
    let game = SnakesAndLadders()
    game.delegate = tracker
    game.play()
    // Started a new game of Snakes and Ladders
    // The game is using a 6-sided dice
    // Rolled a 3
    // Rolled a 5
    // Rolled a 4
    // Rolled a 5
    // The game lasted for 4 turns
    
    // Adding Protocol Conformance with an Extension
    let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
    print(d12.textualDescription)
    // Prints "A 12-sided dice"
    
    // Conditionally Conforming to a Protocol
    let myDice = [d6, d12]
    print(myDice.textualDescription)
    // Prints "[A 6-sided dice, A 12-sided dice]"
    
    // Adopting a Protocol Using a Synthesized Implementation
    let twoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
    let anotherTwoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
    if twoThreeFour == anotherTwoThreeFour {
        print("These two vectors are also equivalent.")
    }
    // Prints "These two vectors are also equivalent."
    
    // Collections of Protocol Types
//    let things: [TextRepresentable] = [game, d12, simonTheHamster]
//    for thing in things {
//        print(thing.textualDescription)
//    }
    
    //Protocol Composition
    let birthdayPerson = Person2(name: "Malcolm", age: 21)
    wishHappyBirthday(to: birthdayPerson)
    // Prints "Happy birthday, Malcolm, you're 21!"
    
    // Checking for Protocol Conformance
    // the instances of classes must conform the protocol of AnyObject
    let objects: [AnyObject] = [
        Circle1(radius: 2.0),
        Country(area: 243_610),
        Animal(legs: 4)
    ]
    for object in objects {
        // check if the object conform to the protocol of HasArea
        if let objectWithArea = object as? HasArea {
            print("Area is \(objectWithArea.area)")
        } else {
            print("Something that doesn't have an area")
        }
    }
    // Area is 12.5663708
    // Area is 243610.0
    // Something that doesn't have an area
    
    // Optional Protocol Requirements
    let counter = Counter()
    counter.dataSource = ThreeSource()
    for _ in 1...4 {
        counter.increment()
        print(counter.count)
    }
    // 3
    // 6
    // 9
    // 12
    
    // Protocol Extensions
    let generator = LinearCongruentialGenerator()
    print("Here's a random number: \(generator.random())")
    // Prints "Here's a random number: 0.37464991998171"
    // all conforming types automatically gain this method implementation without any additional modification
    print("And here's a random Boolean: \(generator.randomBool())")
    // Prints "And here's a random Boolean: true"
    
    // Adding Constraints to Protocol Extensions
    let murrayTheHamster = Hamster(name: "Murray")
    let morganTheHamster = Hamster(name: "Morgan")
    let mauriceTheHamster = Hamster(name: "Maurice")
    let hamsters = [murrayTheHamster, morganTheHamster, mauriceTheHamster]
    // arrays conform to Collection and integers conform to TextRepresentable
    print(hamsters.textualDescription)
    // Prints "[A hamster named Murray, A hamster named Morgan, A hamster named Maurice]"
}

// Property Requirements
// Property requirements are always declared as variable properties
protocol SomeProtocol {
    // Gettable and settable properties
    var mustBeSettable: Int { get set }
    // gettable properties
    var doesNotNeedToBeSettable: Int { get }
}
// type property requirements with the static keyword
protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}

// adopts and conforms to the protocol
protocol FullyNamed {
    var fullName: String { get }
}
// adopts the protocol
struct Person: FullyNamed {
    var fullName: String
}
// conforms to the protocol: fullName
let john = Person(fullName: "John Appleseed")
// john.fullName is "John Appleseed"


// Method Requirements
protocol SomeProtocol2 {
    // type method requirements with the static keyword
    static func someTypeMethod()
}
protocol RandomNumberGenerator {
    func random() -> Double
}
// a pseudorandom number generator algorithm
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}
let generator = LinearCongruentialGenerator()
// generate a random number: 0.37464991998171


// Mutating Method Requirements
protocol Togglable {
    // the method is expected to mutate the state of a conforming instance when it’s called
    mutating func toggle()
}
enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}


// Initializer Requirements
protocol SomeProtocol3 {
    init()
}
class SomeSuperClass {
    init() {
        // initializer implementation goes here
    }
}
class SomeSubClass: SomeSuperClass, SomeProtocol3 {
    // "required" from SomeProtocol conformance; "override" from SomeSuperClass
    required override init() {
        // initializer implementation goes here
    }
}

// Protocols as Types
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}


// Delegation
protocol DiceGame {
    var dice: Dice { get }
    func play()
}
protocol DiceGameDelegate {
    // tracking the progress of a game
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

// track of the number of turns a game has taken and adopt the protocol
class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        // the type of "game" is "DiceGame", so it can only access methods that implemented as part of the DiceGame protocol
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}


// Adding Protocol Conformance with an Extension
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}

// Conditionally Conforming to a Protocol
// Array instances conform to the TextRepresentable protocol whenever they store elements of a type that conforms to TextRepresentable
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}


// Declaring Protocol Adoption with an Extension
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}


// Adopting a Protocol Using a Synthesized Implementation
// After complying with protocol "Equatable", it is possible to compare whether the instances of this method are equal with == and !=
struct Vector3D: Equatable {
    var x = 0.0, y = 0.0, z = 0.0
}


// Protocol Inheritance
// limit protocol adoption to class types only by adding the AnyObject protocol to inheritance list
protocol PrettyTextRepresentable: AnyObject, TextRepresentable {
    var prettyTextualDescription: String { get }
}


// Protocol Composition
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person2: Named, Aged {
    var name: String
    var age: Int
}
// a type conforms to both of the two required protocols
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}


// Checking for Protocol Conformance
protocol HasArea {
    var area: Double { get }
}
class Circle1: HasArea {
    let pi = 3.1415927
    var radius: Double
    // conform the protocol of HasArea with a computed property
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}
class Country: HasArea {
    // conform the protocol of HasArea with a stored property
    var area: Double
    init(area: Double) { self.area = area }
}
class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}


// Optional Protocol Requirements
@objc protocol CounterDataSource {
    // the type of "increment" will turn to ((Int) -> Int)?
    // only class can conform to the protocol with @objc
    // the class which conform to the protocol can choose one of the optional requirement to conform
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}
class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}
// NSObject, the root class of most Objective-C class hierarchies
class ThreeSource: NSObject, CounterDataSource {
    // the class conform to the optional "fixedIncrement" property requirement
    // why "fixedIncrement" can turn to let?
    let fixedIncrement = 3
}


// Protocol Extensions
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

// Providing Default Implementations
// if the instance implement the requirement by itself, the implementation will replace the default implementation in the extension
extension PrettyTextRepresentable  {
    var prettyTextualDescription: String {
        return textualDescription
    }
}

// Adding Constraints to Protocol Extensions
// the protocol extension only works when the "where" constraint is satisfied
extension Collection where Iterator.Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}


// 2. Generics
func Generics() {
    // Generic Functions
    // T in parameters can be inferred to any same type
    func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    var someInt = 3
    var anotherInt = 107
    swapTwoValues(&someInt, &anotherInt)
    // someInt is now 107, and anotherInt is now 3
    var someString = "hello"
    var anotherString = "world"
    swapTwoValues(&someString, &anotherString)
    // someString is now "world", and anotherString is now "hello"
    
    // Generic Types
    var stackOfStrings = Stack<String>()
    stackOfStrings.push("uno")
    stackOfStrings.push("dos")
    let fromTheTop = stackOfStrings.pop()
    
    
    // Type Constraints
    // the type T needs to conform to the Equatable protocol otherwise cannot calculate with "=="
    func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }
    let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
    // doubleIndex is an optional Int with no value, because 9.3 is not in the array
    let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
    // stringIndex is an optional Int containing a value of 2
    
    
    // Generic Where Clauses
    /* Requirements:
     1. C1 must conform to the Container1 protocol (written as C1: Container1).
     -> someContainer1 is a Container1 of type C1.
     2. C2 must also conform to the Container1 protocol (written as C2: Container1).
     -> anotherContainer1 is a Container1 of type C2. && C1 and C2 don’t have to be the same type of Container1
     3. The Item for C1 must be the same as the Item for C2 (written as C1.Item == C2.Item).
     -> someContainer1 and anotherContainer1 contain the same type of items.
     4. The Item for C1 must conform to the Equatable protocol (written as C1.Item: Equatable).
     -> The items in someContainer1 can be checked with the not equal operator (!=) to see if they’re different from each other.
     -> The items in anotherContainer1 can also be checked with the not equal operator (!=) since the two Container1s contain the same type of items.
     */
    func allItemsMatch<C1: Container1, C2: Container1>
        (_ someContainer1: C1, _ anotherContainer1: C2) -> Bool
        where C1.Item == C2.Item, C1.Item: Equatable {
            // Check that both Container1s contain the same number of items.
            if someContainer1.count != anotherContainer1.count {
                return false
            }
            // Check each pair of items to see if they are equivalent.
            for i in 0..<someContainer1.count {
                if someContainer1[i] != anotherContainer1[i] {
                    return false
                }
            }
            // All items match, so return true.
            return true
    }
    
//    var stackOfStrings = Stack<String>()
//    stackOfStrings.push("uno")
    stackOfStrings.push("dos")
    stackOfStrings.push("tres")
    let arrayOfStrings = ["uno", "dos", "tres"]
    if allItemsMatch(stackOfStrings, arrayOfStrings) {
        print("All items match.")
    } else {
        print("Not all items match.")
    }
    // Prints "All items match."
    
    // Extensions with a Generic Where Clause
    if stackOfStrings.isTop("tres") {
        print("Top element is tres.")
    } else {
        print("Top element is something else.")
    }
    // Prints "Top element is tres."
    
    print([1260.0, 1200.0, 98.6, 37.0].average())
    // Prints "648.9"
    
    // Contextual Where Clauses
    let numbers = [1260, 1200, 98, 37]
    print(numbers.average())
    // Prints "648.75"
    print(numbers.endsWith(37))
    // Prints "true"
}

// Generic Types
struct Stack<Element>: Container1 {
    var items: [Element] = []
    // “push“ is a mutating function as it modify the structure’s items array
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    // conformance to the Container1 protocol
    // Swift can infer that Element is the appropriate type to use as the Item for "Container1" protocol
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

// Extending a Generic Type
// do not provide a type parameter list as part of the extension’s definition
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}


// Associated Types
protocol Container1 {
    // the protocol doesn't specify what type the items in the Container1 allowed to be
    associatedtype Item
    // Adding Constraints to an Associated Type
//    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

// Extending an Existing Type to Specify an Associated Type
// Array can use the function in Container1
extension Array: Container1 {}

// Using a Protocol in Its Associated Type’s Constraints
protocol SuffixableContainer1: Container1 {
    // Suffix has two constraints: It must conform to the SuffixableContainer1 protocol, and its Item type must be the same as the Container1’s Item type.
    // Where is used to certain type parameters and associated types must be the same
    associatedtype Suffix: SuffixableContainer1 where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}
// adds conformance to the SuffixableContainer1 protocol in an extension of the Stack type
extension Stack: SuffixableContainer1 {
    // Inferred that Suffix is Stack
    func suffix(_ size: Int) -> Stack {
        var result = Stack()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
}

// Extensions with a Generic Where Clause
// "isTop" can be extended to "Stack" only when "Element" in "Stack" conforms to Equatable
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}
// "average" can be extended to "Container1" only when "Item" in "Container1" is the type of "Double"
extension Container1 where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}


// Contextual Where Clauses
extension Container1 {
    // if the context is already generic types(Item), generic where clause can transfer from extension to part of a function's declaration
    func average() -> Double where Item == Int {
        var sum = 0.0
        for index in 0..<count {
            sum += Double(self[index])
        }
        return sum / Double(count)
    }
    func endsWith(_ item: Item) -> Bool where Item: Equatable {
        return count >= 1 && self[count-1] == item
    }
}


// Generic Subscripts
extension Container1 {
    // generic parameter "Indices" has to be a type that conforms to "Sequence" protocol from the Swift standard library
    // The subscript takes a single parameter, "indices", which is an instance of "Indices" type.
    // The generic where clause requires that the iterator for the sequence must traverse over elements of type Int. This ensures that the indices in the sequence are the same type as the indices used for a Container1.
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
            where Indices.Iterator.Element == Int {
        var result: [Item] = []
        for index in indices {
            result.append(self[index])
        }
        return result
    }
}


// 3. Automatic Reference Counting
func ARC() {
    // How ARC Works
    class Person {
        let name: String
        init(name: String) {
            self.name = name
            print("\(name) is being initialized")
        }
        deinit {
            print("\(name) is being deinitialized")
        }
    }
    // The references automatically initialized with a value of nil, and don’t currently reference a Person instance.
    var reference1: Person?
    var reference2: Person?
    var reference3: Person?
    // create a new Person instance and assign it to one of these three variables
    reference1 = Person(name: "John Appleseed")
    // Prints "John Appleseed is being initialized"
    // There’s now a strong reference from reference1 to the new Person instance. ARC makes sure that Person is kept in memory and isn’t deallocated.
    reference2 = reference1
    reference3 = reference1
    // There are now three strong references to this single Person instance.
    reference1 = nil
    reference2 = nil
    // Break part of these strong references, the Person instance isn’t deallocated.
    reference3 = nil
    // Prints "John Appleseed is being deinitialized"
    // Now the Person instance is deallocated by ARC.

    
    // Weak References: one method to resolve strong reference cycles between class instances
    class Person2 {
        let name: String
        init(name: String) { self.name = name }
        // The apartment property is optional, because a person may not always have an apartment.
        var apartment: Apartment?
        deinit { print("\(name) is being deinitialized") }
    }
    class Apartment {
        let unit: String
        init(unit: String) { self.unit = unit }
        // Weak References
        // The tenant property is optional, because an apartment may not always have a tenant.
        weak var tenant: Person2?
        deinit { print("Apartment \(unit) is being deinitialized") }
    }
    
    var john: Person2?
    var unit4A: Apartment?
    john = Person2(name: "John Appleseed")
    unit4A = Apartment(unit: "4A")
    john!.apartment = unit4A
    unit4A!.tenant = john
    // The Person instance has a strong reference to the Apartment instance, but the Apartment instance has a weak reference to the Person instance.
    john = nil
    // prints "John Appleseed is being deinitialized"
    // Because there are no more strong references to the Person instance, it’s deallocated and the tenant property is set to nil.
    unit4A = nil
    // Prints "Apartment 4A is being deinitialized"
    // Because there are no more strong references to the Apartment instance, it too is deallocated.
    
    // Unowned References
    class Customer {
        let name: String
        // a customer may or may not have a credit card
        var card: CreditCard?
        init(name: String) {
            self.name = name
        }
        deinit { print("\(name) is being deinitialized") }
    }
     
    class CreditCard {
        let number: UInt64
        // a credit card will always be associated with a customer
        unowned let customer: Customer
        // the initializer for CreditCard takes a Customer instance, and stores this instance in its customer property.
        init(number: UInt64, customer: Customer) {
            self.number = number
            self.customer = customer
        }
        deinit { print("Card #\(number) is being deinitialized") }
    }
    var tom: Customer?
    tom = Customer(name: "John Appleseed")
    tom!.card = CreditCard(number: 1234_5678_9012_3456, customer: tom!)
    john = nil
    // prints "John Appleseed is being deinitialized"
    // prints "Card #1234567890123456 is being deinitialized"
    // Because there are no more strong references to the Customer instance, it’s deallocated.
    // After this happens, there are no more strong references to the CreditCard instance, and it too is deallocated.
    
    // Unowned Optional References
    class Department {
        var name: String
        // A department has some courses or not have any course.
        var courses: [Course]
        init(name: String) {
            self.name = name
            self.courses = []
        }
    }
    class Course {
        var name: String
        // A course must has a department.
        unowned var department: Department
        // A course may has a next course or not.
        unowned var nextCourse: Course?
        init(name: String, in department: Department) {
            self.name = name
            self.department = department
            self.nextCourse = nil
        }
    }
    
    // Unowned References and Implicitly Unwrapped Optional Properties
    class Country {
        let name: String
        // capitalCity is a implicitly unwrapped optional property
        // capitalCity has a default value of nil, but can be accessed without the need to unwrap its value
        var capitalCity: City!
        // The initializer for City is called from within the initializer for Country.
        // The initializer for Country can’t pass self to the City initializer until a new Country instance is fully initialized.
        init(name: String, capitalName: String) {
            self.name = name
            self.capitalCity = City(name: capitalName, country: self)
        }
    }
    class City {
        let name: String
        unowned let country: Country
        // The initializer for City takes a Country instance, and stores this instance in its country property.
        init(name: String, country: Country) {
            self.name = name
            self.country = country
        }
    }
    // the Country and City instances can be created in a single statement, without creating a strong reference cycle.
    // capitalCity can be accessed directly, without needing to use an exclamation point to unwrap its optional value
    var country = Country(name: "Canada", capitalName: "Ottawa")
    print("\(country.name)'s capital city is called \(country.capitalCity.name)")
    // prints "Canada's capital city is called Ottawa"
    
    
    // Closuer Capture List: one method to resolve strong reference cycles between a class instance and a closure
    class HTMLElement {
        let name: String
        let text: String?
        // The "asHTML" is "lazy" because it’s only needed if and when the element actually needs to be rendered as a string value for some HTML output target.
        lazy var asHTML: () -> String = {
            // A capture list defines the rules to use when capturing one or more reference types within the closure’s body.
            // "self" will never become nil, so it should be captured as an unowned reference
            [unowned self] in
            if let text = self.text {
                return "<\(self.name)>\(text)</\(self.name)>"
            } else {
                return "<\(self.name) />"
            }
        }
        init(name: String, text: String? = nil) {
            self.name = name
            self.text = text
        }
        deinit {
            print("\(name) is being deinitialized")
        }
    }
    // the strong reference cycle when there is no Closuer Capture List: paragraph -> HTMLElement instance.asHTML() -> self.name -> HTMLElement instance.name
    var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
    print(paragraph!.asHTML())
    // prints"hello, world"
    paragraph = nil
    // prints "p is being deinitialized"
    // If the paragraph variable is set to nil, the HTMLElement instance is deallocated.
}

// 4. Access Control
public class SomePublicClass {                          // explicitly public class
    public var somePublicProperty = 0               // explicitly public class member
    var someInternalProperty = 0                      // implicitly internal class member
    fileprivate func someFilePrivateMethod() {}   // explicitly file-private class member
    private func somePrivateMethod() {}           // explicitly private class member
}
class SomeInternalClass {                                 // implicitly internal class
    var someInternalProperty = 0                      // implicitly internal class member
    fileprivate func someFilePrivateMethod() {}   // explicitly file-private class member
    private func somePrivateMethod() {}            // explicitly private class member
}
fileprivate class SomeFilePrivateClass {            // explicitly file-private class
    func someFilePrivateMethod() {}                 // implicitly file-private class member
    private func somePrivateMethod() {}           // explicitly private class member
}
private class SomePrivateClass {                     // explicitly private class
    func somePrivateMethod() {}                     // implicitly private class member
}

// Subclassing
public class A {
    fileprivate func someMethod() {}
}
internal class B: A {
    override internal func someMethod() {
        super.someMethod()
    }
}

// Getters and Setters
struct TrackedString {
    // give a setter a lower access level than its corresponding getter
    private(set) var numberOfEdits = 0
    var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
}

// The structure’s members (including the numberOfEdits property) have an internal access level by default
public struct TrackedString2 {
    // assign an explicit access level for both a getter and a setter
    // make "numberOfEdits" property getter public, and its property setter private, by combining the public and private(set) access-level modifiers
    public private(set) var numberOfEdits = 0
    public var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
    public init() {}
}


// Test3
// 1. Define a protocol called 'Shape' that requires a method for calculating the area. Create two classes 'Circle' and 'Rectangle', implement this protocol separately, and calculate their areas.
protocol Shape {
    func area() -> Double
}
extension Shape {
    func show() -> String{
        return "\(self.area())"
    }
}

class Circle: Shape {
    let radius: Double
    func area() -> Double {
        return Double.pi * radius * radius
    }
    init(radius: Double) {
        self.radius = radius
    }
}

class Rectangle: Shape {
    let length: Double
    let width: Double
    func area() -> Double {
        return length * width
    }
    init(length: Double, width: Double) {
        self.length = length
        self.width = width
    }
}

func calculateArea() {
    let radius = 2.0
    let circle = Circle(radius: radius)
    print("The area of the circle is \(circle.show()).")
    
    let length = 2.0
    let width = 3.0
    let rectangle = Rectangle(length: length, width: width)
    let areaRectangle = rectangle.area()
    print("The area of the rectangle is \(areaRectangle).")
}

// 2. Define a generic protocol 'Container' that requires an associated type 'itemType' and two methods: 'addItem (_ item: itemType)' and 'getItem (at index: Int) ->itemType?'. Create a class 'Box', implement this protocol, store any type of element, and be able to add and retrieve elements.
protocol Container {
    associatedtype ItemType
    mutating func addItem (_ item: ItemType)
    func getItem (at index: Int) ->ItemType?
}

class Box<Element>: Container {
    var items: [Element] = []
    
    func addItem (_ item: Element) {
        items.append(item)
    }
    
    func getItem (at index: Int) ->Element? {
        guard index < items.count else {
            return nil
        }
        return items[index]
    }
}

func accessElement() {
    let boxOfInt = Box<Int>()
    boxOfInt.addItem(2)
    boxOfInt.addItem(4)
    boxOfInt.addItem(6)
    let index = 1
    guard let element = boxOfInt.getItem(at: index - 1) else {
        print("The element is not present in the box.")
        return
    }
    print("The element at index \(index) is \(element).")
    
    let boxOfMonth = Box<String>()
    boxOfMonth.addItem("Jan")
    boxOfMonth.addItem("Feb")
    boxOfMonth.addItem("Mar")
    boxOfMonth.addItem("Apr")
    let indexMonth = 3
    guard let month = boxOfMonth.getItem(at: indexMonth - 1) else {
        print("The month is not present in the box.")
        return
    }
    print("The No.\(indexMonth) month in a year is \(month).")
}
