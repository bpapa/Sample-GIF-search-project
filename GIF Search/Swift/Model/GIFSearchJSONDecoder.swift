//
//  GIFSearchJSONDecoder.swift
//  GIF Search
//
//  Created by Anon on 6/5/20.
//

import Foundation

/// Subclass usable across app code/tests, etc. for consistent parsing
class GIFSearchJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
