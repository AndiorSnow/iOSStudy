//
//  Day 4.swift
//  iOSStudy
//
//  Created by LMC60018 on 2024/1/3.
//

import Foundation

// 1. Optional Chaining
func OptionalChaining() {
    class Person {
        // a instance of "Person", its "residence" property is default initialized to nil
        var residence: Residence?
    }
    class Residence {
        var numberOfRooms = 1
    }
    
    let john = Person()
    //let roomCount = john.residence!.numberOfRooms
    // this triggers a runtime error
    
    // if "residence" exists, the value of numberOfRooms retrieves with "Int?"
    if let roomCount = john.residence?.numberOfRooms {
        print("John's residence has \(roomCount) room(s).")
    } else {
        print("Unable to retrieve the number of rooms.")
    }
    // Prints "Unable to retrieve the number of rooms."
    
    john.residence = Residence()
    // use optional chaining to access a property/method/subscript on an optional value, and to check if that property access is successful.
    if let roomCount = john.residence?.numberOfRooms {
        print("John's residence has \(roomCount) room(s).")
    } else {
        print("Unable to retrieve the number of rooms.")
    }
    // Prints "John's residence has 1 room(s)."
    
    
    // Accessing Subscripts of Optional Type
    var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
    testScores["Dave"]?[0] = 91
    testScores["Bev"]?[0] += 1
    testScores["Brian"]?[0] = 72
    // the "Dave" array is now [91, 82, 84] and the "Bev" array is now [80, 94, 81], no "Brian" array
}

// 2. 表示和抛出错误
func ErrorHandling() {
    // Representing Errors
    enum VendingMachineError: Error {
        case invalidSelection
        case insufficientFunds(coinsNeeded: Int)
        case outOfStock
    }
    // Throwing Errors
    //throw VendingMachineError.insufficientFunds(coinsNeeded: 5)
    
    // Handling Errors
    // Propagating Errors Using Throwing Functions
    struct Item {
        var price: Int
        var count: Int
    }
     
    class VendingMachine {
        var inventory = [
            "Candy Bar": Item(price: 12, count: 7),
            "Chips": Item(price: 10, count: 4),
            "Pretzels": Item(price: 7, count: 11)
        ]
        var coinsDeposited = 0
        
        // The defined function can throw an error
        func vend(itemNamed name: String) throws {
            guard let item = inventory[name] else {
                throw VendingMachineError.invalidSelection
            }
            
            guard item.count > 0 else {
                throw VendingMachineError.outOfStock
            }
            
            guard item.price <= coinsDeposited else {
                throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
            }
            
            coinsDeposited -= item.price
            
            var newItem = item
            newItem.count -= 1
            inventory[name] = newItem
            
            print("Dispensing \(name)")
        }
    }
    
    let favoriteSnacks = [
        "Alice": "Chips",
        "Bob": "Licorice",
        "Eve": "Pretzels",
    ]
    // The defined function can throw an error
    func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
        let snackName = favoriteSnacks[person] ?? "Candy Bar"
        // The called function can throw an error
        try vendingMachine.vend(itemNamed: snackName)
    }
    
    // Handling Errors Using Do-Catch
    var vendingMachine = VendingMachine()
    vendingMachine.coinsDeposited = 8
    do {
        try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
        print("Success! Yum.")
    } catch VendingMachineError.invalidSelection {
        print("Invalid Selection.")
    } catch VendingMachineError.outOfStock {
        print("Out of Stock.")
    } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
        print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
    } catch {
        print("Unexpected error: \(error).")
    }
    // Prints "Insufficient funds. Please insert an additional 2 coins."
    
    // Converting Errors to Optional Values
//    func fetchData() -> Data? {
//        // If fetchDataFromDisk() throws an error, the value of data is nil
//        if let data = try? fetchDataFromDisk() { return data }
//        if let data = try? fetchDataFromServer() { return data }
//        return nil
//    }
    
    // Disabling Error Propagation
//    let photo = try! loadImage("./Resources/John Appleseed.jpg")
    
    // Specifying Cleanup Actions
    // execute a set of statements just before code execution leaves the current block of code
//    func processFile(filename: String) throws {
//        if exists(filename) {
//            let file = open(filename)
//            // A defer statement defers execution until the current scope is exited
//            defer {
//                close(file)
//            }
//            while let line = try file.readline() {
//                // Work with the file.
//            }
//            // close(file) is called here, at the end of the scope.
//        }
//    }
}

// 3. Type Casting
func TypeCasting() {
    class MediaItem {
        var name: String
        init(name: String) {
            self.name = name
        }
    }
    class Movie: MediaItem {
        var director: String
        init(name: String, director: String) {
            self.director = director
            super.init(name: name)
        }
    }
    class Song: MediaItem {
        var artist: String
        init(name: String, artist: String) {
            self.artist = artist
            super.init(name: name)
        }
    }
    // the type of "library" is inferred to be [MediaItem]
    // the type of items in "library" is inferred to be MediaItem
    let library = [
        Movie(name: "Casablanca", director: "Michael Curtiz"),
        Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
        Movie(name: "Citizen Kane", director: "Orson Welles"),
        Song(name: "The One And Only", artist: "Chesney Hawkes"),
        Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
    ]
    
    // Checking Type
    var movieCount = 0
    var songCount = 0
    for item in library {
        if item is Movie {
            movieCount += 1
        } else if item is Song {
            songCount += 1
        }
    }
    print("Media library contains \(movieCount) movies and \(songCount) songs")
    // Prints "Media library contains 2 movies and 3 songs"
    
    // Downcasting
    for item in library {
        if let movie = item as? Movie {
            // the type of movie is Movie?
            print("Movie: \(movie.name), dir. \(movie.director)")
        } else if let song = item as? Song {
            print("Song: \(song.name), by \(song.artist)")
        }
    }
}

// 4. Nested Types
func NestedTypes () {
    struct BlackjackCard {
        // nested Suit enumeration
        enum Suit: Character {
            case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
        }
        // nested Rank enumeration
        enum Rank: Int {
            case two = 2, three, four, five, six, seven, eight, nine, ten
            case jack, queen, king, ace
            // nested Values struct
            struct Values {
                let first: Int, second: Int?
            }
            var values: Values {
                switch self {
                case .ace:
                    // the Ace cards have a value of either one or eleven
                    return Values(first: 1, second: 11)
                case .jack, .queen, .king:
                    return Values(first: 10, second: nil)
                default:
                    return Values(first: self.rawValue, second: nil)
                }
            }
        }
     
        // BlackjackCard properties and methods
        let rank: Rank, suit: Suit
        var description: String {
            var output = "suit is \(suit.rawValue),"
            output += " value is \(rank.values.first)"
            if let second = rank.values.second {
                output += " or \(second)"
            }
            return output
        }
    }

    let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
    print("theAceOfSpades: \(theAceOfSpades.description)")
    // Prints "theAceOfSpades: suit is ♠, value is 1 or 11"
}

// 5. Extensions
func Extensions() {
    // Computed Properties
    let oneInch = 25.4.mm
    print("One inch is \(oneInch) meters")
    // Prints "One inch is 0.0254 meters"
    let threeFeet = 3.ft
    print("Three feet is \(threeFeet) meters")
    // Prints "Three feet is 0.914399970739201 meters"

    // Initializers
    let defaultRect = Rect()
    let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
                              size: Size(width: 5.0, height: 5.0))

    // Methods
    3.repetitions {
        print("Hello!")
    }
    // Hello!
    // Hello!
    // Hello!
    
    // Mutating Instance Methods
    var someInt = 3
    someInt.square()
    // someInt is now 9
    
    // Subscripts
    746381295[0]
    // returns 5
    746381295[9]
    // returns 0, as if you had requested
}

// Computed Properties
// extension Double in Swift
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}

// Initializers
struct Size {
    // Default Initializers
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

// Methods
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

// Mutating Instance Methods
extension Int {
    mutating func square() {
        self = self * self
    }
}

// Subscripts
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
