//
//  DataRequest+Decodable.swift
//  Idea and code from: https://github.com/Otbivnoe/CodableAlamofire
//

import Foundation
import Alamofire

public extension DataRequest {
    
    /// Be aware it does double encoding/decoding which can lead to poor performance.
    /// In case of bigger JSON responses (e.g. paginated response) consider using container object.
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

final class DataKeyPathSerializer<SerializedObject: Decodable>: ResponseSerializer {

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
        
        guard let data = data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }
            throw AFError.responseSerializationFailed(reason: .decodingFailed(error: AlamofireDecodableError.invalidKeyPath))
        }

        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)

        if let nestedData = (json as AnyObject).value(forKeyPath: keyPath) {
            if JSONSerialization.isValidJSONObject(nestedData) {
                let data = try JSONSerialization.data(withJSONObject: nestedData)
                let object = try decoder.decode(SerializedObject.self, from: data)
                return object
            } else if let nestedObject = nestedData as? SerializedObject {
                return nestedObject
            } else {
                throw AFError.responseSerializationFailed(reason: .decodingFailed(error: AlamofireDecodableError.invalidJSON))
            }
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
        case .invalidKeyPath: return "Nested object doesn't exist by this keyPath."
        case .emptyKeyPath: return "KeyPath can not be empty."
        case .invalidJSON: return "Invalid nested json."
        }
    }
}
