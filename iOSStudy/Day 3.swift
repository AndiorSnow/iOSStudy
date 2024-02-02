//
//  Day 3.swift
//  iOSStudy
//
//  Created by LMC60018 on 2024/1/2.
//

import Foundation

// 1. Properties
func Properties() {
    // Stored Properties
    struct FixedLengthRange {
        var firstValue: Int
        let length: Int
    }
    var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
    // the range represents integer values 0, 1, and 2
    rangeOfThreeItems.firstValue = 6
    // the range now represents integer values 6, 7, and 8
    
    
    // Computed Properties
    struct Point {
        var x = 0.0, y = 0.0
    }
    struct Size {
        var width = 0.0, height = 0.0
    }
    struct Rect {
        var origin = Point()
        var size = Size()
        var center: Point {
            get {
                // another version: Point(x: origin.x + (size.width / 2), y: origin.y + (size.height / 2))
                let centerX = origin.x + (size.width / 2)
                let centerY = origin.y + (size.height / 2)
                return Point(x: centerX, y: centerY)
            }
            set(newCenter) {
                // If the name for the new value never be set (newCenter), a default name of 'newValue' is used.
                origin.x = newCenter.x - (size.width / 2)
                origin.y = newCenter.y - (size.height / 2)
            }
        }
    }
    var square = Rect(origin: Point(x: 0.0, y: 0.0),
        size: Size(width: 10.0, height: 10.0))
    let initialSquareCenter = square.center
    // initialSquareCenter is at (5.0, 5.0)
    square.center = Point(x: 15.0, y: 15.0)
    print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
    // Prints "square.origin is now at (10.0, 10.0)"
    
    // Read-Only Computed Properties
    struct Cuboid {
        var width = 0.0, height = 0.0, depth = 0.0
        var volume: Double {
            // can remove the get keyword
            return width * height * depth
        }
    }
    let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
    print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")
    // Prints "the volume of fourByFiveByTwo is 40.0"
    
    
    // Property Observers
    class StepCounter {
        var totalSteps: Int = 0 {
            willSet(newTotalSteps) {
                // willSet is called just before the value is stored
                print("About to set totalSteps to \(newTotalSteps)")
            }
            didSet {
                // didSet is called immediately after the new value is stored, the default name of the old value is oldValue
                if totalSteps > oldValue  {
                    print("Added \(totalSteps - oldValue) steps")
                }
            }
        }
    }
    let stepCounter = StepCounter()
    stepCounter.totalSteps = 200
    // About to set totalSteps to 200
    // Added 200 steps
    stepCounter.totalSteps = 360
    // About to set totalSteps to 360
    // Added 160 steps
    stepCounter.totalSteps = 896
    // About to set totalSteps to 896
    // Added 536 steps
    
    
    // Property Wrappers
    @propertyWrapper
    struct TwelveOrLess {
        private var number = 0
        var wrappedValue: Int {
            get { return number }
            set { number = min(newValue, 12) }
        }
    }
    
    struct SmallRectangle {
        // apply the wrapper to a property by writing the wrapper’s name before the property
        @TwelveOrLess var height: Int
        @TwelveOrLess var width: Int
    }
    var rectangle = SmallRectangle()
    print(rectangle.height)
    // Prints "0"
    rectangle.height = 10
    print(rectangle.height)
    // Prints "10"
    rectangle.height = 24
    print(rectangle.height)
    // Prints "12"
    
    // Setting Initial Values for Wrapped Properties
    @propertyWrapper
    struct SmallNumber {
        private var maximum: Int
        private var number: Int
        var wrappedValue: Int {
            get { return number }
            set { number = min(newValue, maximum) }
        }

        // initializers
        init() {
            maximum = 12
            number = 0
        }
        init(wrappedValue: Int) {
            maximum = 12
            number = min(wrappedValue, maximum)
        }
        init(wrappedValue: Int, maximum: Int) {
            self.maximum = maximum
            number = min(wrappedValue, maximum)
        }
    }
    
    // initializer with no parameter
    struct ZeroRectangle {
        @SmallNumber var height: Int
        @SmallNumber var width: Int
    }
    var zeroRectangle = ZeroRectangle()
    print(zeroRectangle.height, zeroRectangle.width)
    // Prints "0 0"

    // initializer with one parameter
    struct UnitRectangle {
        @SmallNumber var height: Int = 1
        @SmallNumber var width: Int = 1
    }
    var unitRectangle = UnitRectangle()
    print(unitRectangle.height, unitRectangle.width)
    // Prints "1 1"
    
    // initializer with two parameters
    struct NarrowRectangle {
        @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
        @SmallNumber(maximum: 4) var width: Int = 3
    }
    var narrowRectangle = NarrowRectangle()
    print(narrowRectangle.height, narrowRectangle.width)
    // Prints "2 3"
    narrowRectangle.height = 100
    narrowRectangle.width = 100
    print(narrowRectangle.height, narrowRectangle.width)
    // Prints "5 4"
    
    // Projecting a Value From a Property Wrapper
    // expose additional functionality by defining a projected value
    @propertyWrapper
    struct SmallNumber2 {
        private var number = 0
        var projectedValue = false
        var wrappedValue: Int {
            get { return number }
            set {
                if newValue > 12 {
                    number = 12
                    projectedValue = true
                } else {
                    number = newValue
                    projectedValue = false
                }
            }
        }
    }
    struct SomeStructure {
        @SmallNumber2 var someNumber: Int
    }
    var someStructure = SomeStructure()
     
    someStructure.someNumber = 4
    print(someStructure.someNumber)
    // The name of the projected value begins with $
    print(someStructure.$someNumber)
    // Prints "4" "false"
     
    someStructure.someNumber = 55
    print(someStructure.someNumber)
    print(someStructure.$someNumber)
    // Prints "12" "true"
    
    
    // Type Property
    struct SomeStructure2 {
        static var storedTypeProperty = "Some value."
        static var computedTypeProperty: Int {
            return 1
        }
    }
    enum SomeEnumeration {
        static var storedTypeProperty = "Some value."
        static var computedTypeProperty: Int {
            return 6
        }
    }
    class SomeClass {
        static var storedTypeProperty = "Some value."
        static var computedTypeProperty: Int {
            return 27
        }
        class var overrideableComputedTypeProperty: Int {
            return 107
        }
    }
    // type properties are queried and set on the type, not on an instance of that type
    print(SomeStructure2.storedTypeProperty)
    // Prints "Some value."
    SomeStructure2.storedTypeProperty = "Another value."
    print(SomeStructure2.storedTypeProperty)
    // Prints "Another value."
    print(SomeEnumeration.computedTypeProperty)
    // Prints "6"
    print(SomeClass.computedTypeProperty)
    // Prints "27"
}


// 2. Methods
func Methods() {
    // Instance Methods
    class Counter {
        var count = 0
        func increment() {
            count += 1
            // equivalent to  self.count += 1
            // self property equivalent to the instance itself
            // self can be omitted unless the property has the same name with the parameter
        }
        func increment(by amount: Int) {
            count += amount
        }
        func reset() {
            count = 0
        }
    }
    let counter = Counter()
    // the initial counter value is 0
    counter.increment()
    // the counter's value is now 1
    counter.increment(by: 5)
    // the counter's value is now 6
    counter.reset()
    // the counter's value is now 0
    
    // Modifying Value Types from Within Instance Methods
    struct Point {
        var x = 0.0, y = 0.0
        mutating func moveBy(x deltaX: Double, y deltaY: Double) {
            x += deltaX
            y += deltaY
        }
    }
    // another version
//    struct Point {
//        var x = 0.0, y = 0.0
//        mutating func moveBy(x deltaX: Double, y deltaY: Double) {
//            self = Point(x: x + deltaX, y: y + deltaY)
//        }
//    }
    var somePoint = Point(x: 1.0, y: 1.0)
    somePoint.moveBy(x: 2.0, y: 3.0)
    print("The point is now at (\(somePoint.x), \(somePoint.y))")
    // prints "The point is now at (3.0, 4.0)"
    
    // Type Methods
    struct LevelTracker {
        static var highestUnlockedLevel = 1
        var currentLevel = 1
        static func unlock(_ level: Int) {
            if level > highestUnlockedLevel { highestUnlockedLevel = level }
        }
        static func isUnlocked(_ level: Int) -> Bool {
            return level <= highestUnlockedLevel
        }
        @discardableResult
        // discard the warn
        mutating func advance(to level: Int) -> Bool {
            if LevelTracker.isUnlocked(level) {
                currentLevel = level
                return true
            } else {
                return false
            }
        }
    }
}


// 3. Subscripts
func Subscripts() {
    // define subscript for a type
    struct TimesTable {
        let multiplier: Int
        subscript(index: Int) -> Int {
            return multiplier * index
        }
    }
    let threeTimesTable = TimesTable(multiplier: 3)
    print("six times three is \(threeTimesTable[6])")
    // Prints "six times three is 18"
    
    // Subscript Options
    struct Matrix {
        let rows: Int, columns: Int
        var grid: [Double]
        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            grid = Array(repeating: 0.0, count: rows * columns)
        }
        func indexIsValid(row: Int, column: Int) -> Bool {
            return row >= 0 && row < rows && column >= 0 && column < columns
        }
        // subscripts can take a varying number of parameters and provide default values for their parameters
        // subscript overloading
        subscript(row: Int, column: Int) -> Double {
            get {
                assert(indexIsValid(row: row, column: column), "Index out of range")
                return grid[(row * columns) + column]
            }
            set {
                assert(indexIsValid(row: row, column: column), "Index out of range")
                grid[(row * columns) + column] = newValue
            }
        }
    }
    var matrix = Matrix(rows: 2, columns: 2)
    matrix[0, 1] = 1.5
    matrix[1, 0] = 3.2
}

// 4. Inheritance
func Inheritance() {
    class Vehicle {
        var currentSpeed = 0.0
        var description: String {
            return "traveling at \(currentSpeed) miles per hour"
        }
        func makeNoise() {
            // do nothing - an arbitrary vehicle doesn't necessarily make a noise
        }
    }
    
    // override
    class Car: Vehicle {
        var gear = 1
        override var description: String {
            return super.description + " in gear \(gear)"
        }
    }
    
    let car = Car()
    car.currentSpeed = 25.0
    car.gear = 3
    print("Car: \(car.description)")
    // Car: traveling at 25.0 miles per hour in gear 3
    
    // Overriding Property Observers
    class AutomaticCar: Car {
        override var currentSpeed: Double {
            didSet {
                gear = Int(currentSpeed / 10.0) + 1
            }
        }
    }
    
    let automatic = AutomaticCar()
    automatic.currentSpeed = 35.0
    print("AutomaticCar: \(automatic.description)")
    // AutomaticCar: traveling at 35.0 miles per hour in gear 4
}

// 5. Initialization
func Initialization() {
    // Customizing Initialization
    struct Celsius {
        var temperatureInCelsius: Double
        // provide initialization parameters as part of an initializer’s definition
        init(fromFahrenheit fahrenheit: Double) {
            temperatureInCelsius = (fahrenheit - 32.0) / 1.8
        }
        init(fromKelvin kelvin: Double) {
            temperatureInCelsius = kelvin - 273.15
        }
        // Initializer Parameters Without Argument Labels
        init(_ celsius: Double) {
            temperatureInCelsius = celsius
        }
    }
    let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
    // boilingPointOfWater.temperatureInCelsius is 100.0
    let freezingPointOfWater = Celsius(fromKelvin: 273.15)
    // freezingPointOfWater.temperatureInCelsius is 0.0
    let bodyTemperature = Celsius(37.0)
    // bodyTemperature.temperatureInCelsius is 37.0
    
    // Parameter Names and Argument Labels
    struct Color {
        let red, green, blue: Double
        init(red: Double, green: Double, blue: Double) {
            self.red   = red
            self.green = green
            self.blue  = blue
        }
    }
    // argument labels cannot be ommited
    let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
    
    // Optional Property Types
    class SurveyQuestion {
        var text: String
        // perhaps the value cannot be set during initialization
        // Properties of optional type are automatically initialized with a value of nil
        var response: String?
        init(text: String) {
            self.text = text
        }
        func ask() {
            print(text)
        }
    }
    let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
    cheeseQuestion.ask()
    // Prints "Do you like cheese?"
    cheeseQuestion.response = "Yes, I do like cheese."
    
    // Default Initializers
    class ShoppingListItem {
        var name: String?
        var quantity = 1
        var purchased = false
    }
    // item is initialized automatically by the default values in ShoppingListItem
    var item = ShoppingListItem()
    
    
    // Initializer Delegation for Value Types
    struct Size {
        var width = 0.0, height = 0.0
    }
    struct Point {
        var x = 0.0, y = 0.0
    }
    struct Rect {
        var origin = Point()
        var size = Size()
        // = default initializer
        init() {}
        // = memberwise initializer
        init(origin: Point, size: Size) {
            self.origin = origin
            self.size = size
        }
        // delegate init(origin:, size:) initializer
        init(center: Point, size: Size) {
            let originX = center.x - (size.width / 2)
            let originY = center.y - (size.height / 2)
            self.init(origin: Point(x: originX, y: originY), size: size)
        }
    }
    
    
    // Class Inheritance and Initialization
    // Initializer Inheritance and Overriding
    class Vehicle {
        var numberOfWheels = 0
        var description: String {
            return "\(numberOfWheels) wheel(s)"
        }
    }
    let vehicle = Vehicle()
    print("Vehicle: \(vehicle.description)")
    // Vehicle: 0 wheel(s)
    class Bicycle: Vehicle {
        override init() {
            // calls the default initializer for the superclass
            super.init()
            numberOfWheels = 2
        }
    }
    let bicycle = Bicycle()
    print("Bicycle: \(bicycle.description)")
    // Bicycle: 2 wheel(s)
    
    
    // Failable Initializers
    struct Animal {
        let species: String
        init?(species: String) {
            if species.isEmpty { return nil }
            self.species = species
        }
    }
    let someCreature = Animal(species: "Giraffe")
    // someCreature is of type Animal?, not Animal
    if let giraffe = someCreature {
        print("An animal was initialized with a species of \(giraffe.species)")
    }
    // prints "An animal was initialized with a species of Giraffe"
    
    let anonymousCreature = Animal(species: "")
    // anonymousCreature is of type Animal?, not Animal
    if anonymousCreature == nil {
        print("The anonymous creature could not be initialized")
    }
    // prints "The anonymous creature could not be initialized"
    
    // Failable Initializers for Enumerations
//    enum TemperatureUnit {
//        case Kelvin, Celsius, Fahrenheit
//        init?(symbol: Character) {
//            switch symbol {
//            case "K":
//                self = .Kelvin
//            case "C":
//                self = .Celsius
//            case "F":
//                self = .Fahrenheit
//            default:
//                return nil
//            }
//        }
//    }
    // Failable Initializers for Enumerations with Raw Values
    // automatically receive a failable initializer
    enum TemperatureUnit: Character {
        case Kelvin = "K", Celsius = "C", Fahrenheit = "F"
    }
     
    let fahrenheitUnit = TemperatureUnit(rawValue: "F")
    if fahrenheitUnit != nil {
        print("This is a defined temperature unit, so initialization succeeded.")
    }
    // prints "This is a defined temperature unit, so initialization succeeded."
     
    let unknownUnit = TemperatureUnit(rawValue: "X")
    if unknownUnit == nil {
        print("This is not a defined temperature unit, so initialization failed.")
    }
    // prints "This is not a defined temperature unit, so initialization failed."
    
    // Propagation of Initialization Failure
    // if another initializer fails, the entire initialization process fails immediately
    class Product {
        let name: String
        init?(name: String) {
            if name.isEmpty { return nil }
            self.name = name
        }
    }
    class CartItem: Product {
        let quantity: Int
        init?(name: String, quantity: Int) {
            if quantity < 1 { return nil }
            self.quantity = quantity
            super.init(name: name)
        }
    }
    
    // Overriding a Failable Initializer
    // override a failable initializer with a nonfailable initializer
    class Document {
        var name: String?
        init() {}
        init?(name: String) {
            if name.isEmpty { return nil }
            self.name = name
        }
    }
    // The class copes with the empty string case in a different way than its superclass, so its initializer doesn’t need to fail.
    class AutomaticallyNamedDocument: Document {
        override init() {
            super.init()
            self.name = "[Untitled]"
        }
        override init(name: String) {
            super.init()
            if name.isEmpty {
                self.name = "[Untitled]"
            } else {
                self.name = name
            }
        }
    }
    
    // Setting a Default Property Value with a Closure or Function
    struct Chessboard {
        let boardColors: [Bool] = {
            var temporaryBoard: [Bool] = []
            var isBlack = false
            for i in 1...8 {
                for j in 1...8 {
                    temporaryBoard.append(isBlack)
                    isBlack = !isBlack
                }
                isBlack = !isBlack
            }
            return temporaryBoard
        }()     // () is necessery
        func squareIsBlackAt(row: Int, column: Int) -> Bool {
            return boardColors[(row * 8) + column]
        }
    }
    let board = Chessboard()
    print(board.squareIsBlackAt(row: 0, column: 1))
    // Prints "true"
}


// 6. Deinitialization
func Deinitialization() {
//    deinit {
//        // perform the deinitialization automatically
//    }
}

protocol Vehicle {
    var currentSpeed : Double { get set }
    var wheels : Int { get }
    var gear : Int { get }
    var power: PowerSource { get }
    var size: CarSize { get }
}
extension Vehicle {
    func getWheels() -> String{
        "Car has \(self.wheels) wheels."
    }
    func description() -> String{
        return "Car is traveling at \(self.currentSpeed) miles per hour" + " in gear \(self.gear)"
        + " with size of length:\(self.size.length), width:\(self.size.width), height:\(self.size.height)"
        + " and power source of \(self.power)."
    }
}

class Car: Vehicle {
    var currentSpeed: Double
    let wheels : Int
    var gear = 1
    let power: PowerSource
    var size = CarSize()
    init (power: PowerSource, currentSpeed: Double, wheels: Int) {
        self.power = power
        self.currentSpeed = currentSpeed
        self.wheels = wheels
    }
}
    
struct CarSize {
    var length = 0.0
    var width = 0.0
    var height = 0.0
}

enum PowerSource: CaseIterable {
    case ICE, MHEV, HEV, REV, BEV, PHEV, FCEV
}

class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

func VehicleProgram() {
    let wheels = 4
    let currentSpeed = 20.0
    let carSize = CarSize(length: 5.0, width: 1.9, height: 1.5)
    let carPower = PowerSource.ICE
    let car = Car(power: carPower, currentSpeed: currentSpeed, wheels: wheels)
    car.size = carSize
    car.currentSpeed = 40.0
    print(car.description())
    
    let automaticCarsize = CarSize(length: 4.0, width: 1.8, height: 1.4)
    let automaticCarPower = PowerSource.BEV
    let automaticCar = AutomaticCar(power: automaticCarPower, currentSpeed: currentSpeed, wheels: wheels)
    automaticCar.size = automaticCarsize
    automaticCar.currentSpeed = 35.0
    print(automaticCar.getWheels())
}
