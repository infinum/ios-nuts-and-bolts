//
//  DataRequest+Decodable.swift
//  Idea and code from: https://github.com/Otbivnoe/CodableAlamofire
//

import Foundation
import Alamofire

public extension DataRequest {

    @discardableResult
    func responseDecodable<T: Decodable>(
        queue: DispatchQueue = .main,
        keyPath: String?,
        decoder: JSONDecoder = JSONDecoder(),
        completionHandler: @escaping (AFDataResponse<T>) -> Void
    ) -> Self {
        return response(
            queue: queue,
            responseSerializer: DataKeyPathSerializer<T>(keyPath: keyPath, decoder: decoder),
            completionHandler: completionHandler
        )
    }
}

final class DataKeyPathSerializer<SerializedObject: Decodable>: DataResponseSerializerProtocol {

    private let keyPath: String?
    private let decoder: JSONDecoder

    init(keyPath: String?, decoder: JSONDecoder = JSONDecoder()) {
        self.keyPath = keyPath
        self.decoder = decoder
    }

    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> SerializedObject {
        // If there is an error, throw immediately
        if let error = error {
            throw error
        }
        
        // In case there is no keypath fallback to default Alamofire parsing
        guard let keyPath = keyPath else {
            let data = try DataResponseSerializer().serialize(request: nil, response: response, data: data, error: nil)
            let object = try self.decoder.decode(SerializedObject.self, from: data)
            return object
        }
        
        if keyPath.isEmpty {
            throw AFError.responseSerializationFailed(reason: .decodingFailed(error: AlamofireDecodableError.emptyKeyPath))
        }
        
        let json = try JSONResponseSerializer().serialize(request: nil, response: response, data: data, error: nil)
        if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
            guard JSONSerialization.isValidJSONObject(nestedJson) else {
                throw AFError.responseSerializationFailed(reason: .decodingFailed(error: AlamofireDecodableError.invalidJSON))
            }
            let data = try JSONSerialization.data(withJSONObject: nestedJson)
            let object = try decoder.decode(SerializedObject.self, from: data)
            return object
        } else {
            throw AFError.responseSerializationFailed(reason: .decodingFailed(error: AlamofireDecodableError.invalidKeyPath))
        }
    }
}

public enum AlamofireDecodableError: Error {
    case invalidKeyPath
    case emptyKeyPath
    case invalidJSON
}

extension AlamofireDecodableError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidKeyPath:   return "Nested object doesn't exist by this keyPath."
        case .emptyKeyPath:     return "KeyPath can not be empty."
        case .invalidJSON:      return "Invalid nested json."
        }
    }
}
