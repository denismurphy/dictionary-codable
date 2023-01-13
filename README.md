# DictionaryCodable

A simple utility library for encoding and decoding Swift `Codable` types to and from dictionaries.

## Installation

To install `DictionaryCodable`, simply add the following line to your `Podfile`:
pod 'DictionaryCodable'
                                
Then run `pod install` to install the library.

## Usage

`DictionaryCodable` provides two methods for encoding and decoding `Codable` types: `toDictionary` and `fromDictionary`.

```swift
import DictionaryCodable
                                
struct MyCodableType: Codable {
let name: String
let age: Int
}

let codable = MyCodableType(name: "John", age: 30)

// Encode to a dictionary
let dictionary = codable.toDictionary()
// Output: ["name": "John", "age": 30]
// Decode from a dictionary
let decoded = MyCodableType.fromDictionary(dictionary)
// Output: MyCodableType(name: "John", age: 30)
```

## License

DictionaryCodable is released under the MIT license. See LICENSE for more information.
