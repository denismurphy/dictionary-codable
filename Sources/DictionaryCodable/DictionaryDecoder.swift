import Foundation

public enum DictionaryDecoderError: Error {
    case missingValueForKey(String)
    case mismatchingType(String)
    case error(String)
}

public final class DictionaryDecoder {
    
    public init(){}
    
    private func _decode<T: Decodable>(dictionary : [String: Any], reusableDecoder: _DictionaryDecoder? = nil ) throws -> T?{
        if !dictionary.isEmpty {
            let reusable = reusableDecoder != nil
            let decoder = reusable ? reusableDecoder : _DictionaryDecoder(dictionary)
            if let decoder = decoder {
                if reusable {
                    decoder.dictionary = dictionary
                }
                return try T.init(from:decoder)
            }
        }
        return nil
    }
    
    
    public func decode<T: Decodable>(dictionary : [String: Any]) throws -> T?{
        return try self._decode(dictionary:dictionary)
    }
    
    public func decode<T: Decodable>(dictionarys : Array<[String: Any]>) throws ->  Array<T>{
        var array = Array<T>()
        if !dictionarys.isEmpty {
            let decoder = _DictionaryDecoder()
            for dictionary in dictionarys {
                decoder.dictionary = dictionary
                let optionalTypeValue : T? = try self._decode(dictionary: dictionary,reusableDecoder:decoder)
                if let typeValue = optionalTypeValue {
                    array.append(typeValue)
                }
            }
        }
        return array
    }
}

fileprivate class _DictionaryDecoder : Decoder {
    
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    var dictionary : [String: Any]?
    
    init(_ dictionary: [String:Any]? = nil){
        self.dictionary = dictionary
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        guard let dictionary = self.dictionary else { throw DictionaryDecoderError.error("Dictionary can't be nil")}
        return KeyedDecodingContainer(_DictionaryKeyedDecodingContainer<Key>(dictionary))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError("_DictionaryDecoder doesn't support unkeyed decoding")
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError("_DictionaryDecoder doesn't support single value decoding")
    }
}

fileprivate class _DictionaryKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    
    var codingPath: [CodingKey] = []
    
    var dictionary : [String:Any]
    
    var allKeys: [Key] { return dictionary.keys.compactMap { Key(stringValue: $0) } }
    
    init(_ dictionary: [String:Any]){
        self.dictionary = dictionary
    }
    
    func contains(_ key: Key) -> Bool {
        return dictionary[key.stringValue] != nil
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        return dictionary[key.stringValue] == nil
    }
    
    func _decode<T>(forKey key: Key) throws -> T {
        guard let value = dictionary[key.stringValue] else {
            throw DictionaryDecoderError.missingValueForKey(key.stringValue)
        }
        if let typeValue = value as? T {
            return typeValue
        }
        else {
            throw DictionaryDecoderError.mismatchingType(key.stringValue)
        }
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        return try _decode(forKey: key)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("_DictionaryKeyedDecodingContainer does not support nested containers.")
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError("_DictionaryKeyedDecodingContainer does not support nested containers.")
    }
    
    func superDecoder() throws -> Decoder {
        fatalError("_DictionaryKeyedDecodingContainer does not support nested containers.")
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError("_DictionaryKeyedDecodingContainer does not support nested containers.")
    }
    
}
