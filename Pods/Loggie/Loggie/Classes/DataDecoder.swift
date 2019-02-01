//
//  ResponseDecoder.swift
//  Pods
//
//  Created by Filip Bec on 16/03/2017.
//
//

import UIKit

protocol DataDecoder: NSObjectProtocol {
    func canDecode(_ data: Data, contentType: String?) -> Bool
    func decode(_ data: Data, contentType: String?) -> LogDetailsItem
}

class JSONDataDecoder: NSObject, DataDecoder {

    func canDecode(_ data: Data, contentType: String?) -> Bool {
        if contentType == "application/json" {
            return true
        }
        if jsonObject(with: data) != nil {
            return true
        }
        return false
    }

    func decode(_ data: Data, contentType: String?) -> LogDetailsItem {
        return .text(data.formattedJsonString)
    }

    private func jsonObject(with data: Data) -> Any? {
        return (try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]))
    }
}

class PlainTextDataDecoder: NSObject, DataDecoder {

    func canDecode(_ data: Data, contentType: String?) -> Bool {
        if let _contentType = contentType, _contentType.hasPrefix("text") {
            return true
        }
        return false
    }

    func decode(_ data: Data, contentType: String?) -> LogDetailsItem {
        let text = String(data: data, encoding: .utf8)
        return .text(text)
    }
}

class ImageDataDecoder: NSObject, DataDecoder {

    func canDecode(_ data: Data, contentType: String?) -> Bool {
        if let _contentType = contentType, _contentType.hasPrefix("image") {
            return true
        }
        if UIImage(data: data) != nil {
            return true
        }
        return false
    }

    func decode(_ data: Data, contentType: String?) -> LogDetailsItem {
        let image = UIImage(data: data)
        return .image(image)
    }
}
