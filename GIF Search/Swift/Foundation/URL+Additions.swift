//
//  URL+Additions.swift
//  GIF Search
//
//  Created by Anon on 6/5/20.
//

import Foundation

extension URL {
    /// Factory method to create a Giphy search URL given a query
    /// - Parameter query: the query
    /// - Returns: The URL if it can be created
    static func makeGiphySearchURL(query: String) -> URL? {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        
        let string = "https://api.giphy.com/v1/gifs/search?api_key=229ac3e932794695b695e71a9076f4e5&limit=25&offset=0&rating=G&lang=en&q=" +  encodedQuery
        return URL(string: string)
    }
}
