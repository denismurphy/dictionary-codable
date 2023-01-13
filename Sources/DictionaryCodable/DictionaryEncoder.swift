import Foundation

public final class DictionaryEncoder {
    
    public init(){}
    
    private func _encode<T: Encodable>(_ value: T, reusableEncoder: _DictionaryEncoder? = nil ) throws -> [String: Any] {
        var dictionary : [String: Any] = [:]
        let reusable = reusableEncoder != nil
        let encoder = reusable ? reusableEncoder : _DictionaryEncoder()
        if let encoder = encoder {
            try value.encode(to: encoder)
            dictionary = encoder.dictionary
        }
        return dictionary
    }
    
    public func encode<T: Encodable>(_ value: T) throws -> [String: Any] {
        return try self._encode(value)
    }
    
    public func encode<T: Encodable>(_ values: Array<T>) throws ->  Array<[String: Any]>{
        var array = Array<[String: Any]>()
        if !values.isEmpty {
            let encoder = _DictionaryEncoder()
            for value in values {
                let dictionary = try self._encode(value,reusableEncoder:encoder)
                array.append(dictionary)
            }
        }
        return array
    }
}


fileprivate class _DictionaryEncoder: Encoder {
    
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    private var dictionaryWrapper = _DictionaryWrapper()
    
    var dictionary: [String: Any] { return dictionaryWrapper.dictionary }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        dictionaryWrapper.reset()
        return KeyedEncodingContainer(_DictionaryKeyedEncodingContainer<Key>(dictionaryWrapper))
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("_DictionaryEncoder doesn't support unkeyed encoding")
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError("_DictionaryEncoder doesn't support single value encoding")
    }
    
    
}

fileprivate class _DictionaryKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    
    var codingPath: [CodingKey] = []
    
    var dictionaryWrapper : _DictionaryWrapper
    
    init(_  dictionaryWrapper : _DictionaryWrapper) {
        self.dictionaryWrapper = dictionaryWrapper
    }
    
    func encodeNil(forKey key: Key) throws {
        // pass
    }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        self.dictionaryWrapper[key.stringValue] = value
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("_DictionaryKeyedEncodingContainer does not support nested containers.")
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError("_DictionaryKeyedEncodingContainer does not support nested containers.")
    }
    
    func superEncoder() -> Encoder {
        fatalError("_DictionaryKeyedEncodingContainer does not support nested containers.")
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        fatalError("_DictionaryKeyedEncodingContainer does not support nested containers.")
    }
}

fileprivate class _DictionaryWrapper {
    
    var dictionary : [String: Any] = [:]

    func reset() {
        if !dictionary.isEmpty {
            dictionary = [:]
        }
    }

    subscript(key: String) -> Any {
        get {
            return dictionary[key] as Any
        }
        set {
            dictionary[key] = newValue
        }
    }
}
