
# Dictionary Codable

The `DictionaryCodable` library is a lightweight utility for encoding and decoding Swift objects to and from dictionaries. This library provides a simple way to convert your Swift objects to dictionary.

## Usage

The `DictionaryEncoder` class provides a simple way to encode Swift objects to dictionaries. Here's an example of how to use it:

```
struct Person: Encodable {
    let name: String
    let age: Int
}

let person = Person(name: "John Doe", age: 30)
let encoder = DictionaryEncoder()
let dictionary = try encoder.encode(person)
print(dictionary) // prints ["name": "John Doe", "age": 30]
```

You can also encode an array of Swift objects using the `encode` method and it will return array of dictionaries:

```
let people = [Person(name: "John Doe", age: 30), Person(name: "Jane Doe", age: 25)]
let encoder = DictionaryEncoder()
let dictionaryArray = try encoder.encode(people)
print(dictionaryArray) // prints [["name": "John Doe", "age": 30], ["name": "Jane Doe", "age": 25]]
```

`DictionaryDecoder` class to decode a dictionary into a Swift object:

```
struct Person: Decodable {
    let name: String
    let age: Int
}

let dictionary = ["name": "John Doe", "age": 30]
let decoder = DictionaryDecoder()
let person = try decoder.decode(Person.self, from: dictionary)
print(person) // prints "Person(name: "John Doe", age: 30)"
```

You can also decode an array of dictionaries into an array of Swift objects using the decode method:

```
let dictionaryArray = [["name": "John Doe", "age": 30], ["name": "Jane Doe", "age": 25]]
let decoder = DictionaryDecoder()
let people = try decoder.decode([Person].self, from: dictionaryArray)
print(people) // prints "[Person(name: "John Doe", age: 30), Person(name: "Jane Doe", age: 25)]"
```

## Note

This encoder/decoder implementation is simple and straightforward, it does not support nested or complex object structures yet.

## Contributing

I welcome contributions and suggestions for improvements to this library. If you find a bug or want to propose a new feature, please open an issue or submit a pull request.

## Authors

-   **Denis Murphy**

## License
This code is licensed under the MIT License.
