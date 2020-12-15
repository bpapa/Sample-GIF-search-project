//
//  GIF.swift
//  GIF Search
//
//  Created by Anon on 6/5/20.
//

import Foundation

struct SearchResult: Codable {
    let data: [GIF]
}

/// Model of a GIF from the Giphy API
struct GIF: Codable {
    let images: Images
    
    /// The recommended file to display per the GIPHY Rendition Guide. May not be available for certain GIFs according to their documentation
    var fixedWidthMP4URL: URL? {
        return images.fixedWidth?.mp4
    }
}

struct Images: Codable {
    let fixedWidth: FixedWidth?
}

struct FixedWidth: Codable {
    let mp4: URL
}
