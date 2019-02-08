//
//  Data+FormattedJsonString.swift
//  Pods
//
//  Created by Filip Beć on 05/05/2017.
//
//

import UIKit

extension Data {

    public var formattedJsonString: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) else {
            return nil
        }
        guard let formattedBody = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
            return nil
        }
        return String(data: formattedBody, encoding: .utf8)
    }

}
