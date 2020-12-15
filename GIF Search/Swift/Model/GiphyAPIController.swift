//
//  GiphyAPIController.swift
//  GIF Search
//
//  Created by Anon on 6/5/20.
//

import Foundation

enum GiphyAPIError: Error {
    case noDataError
    case invalidQueryError(String)
    
    var localizedDescription: String {
        switch self {
        case .noDataError:
            return "No Data in response"
            
        case .invalidQueryError(let query):
            return "Could not create URL with query \(query)"
        }
    }
}

/// Interacts with the Giphy API
class GiphyAPIController {
    /// Uses the Giphy search API to retrieve GIFs
    /// - Parameters:
    ///   - query: a search query
    ///   - completion: contains a result parameter with an array of `GIF` instances or an array. The GIF array is filtered for GIFs that do not contain the recommended format and size
    func searchGIFs(query: String, completion: @escaping (Result<[GIF], Error>) -> Void) {
        guard let url = URL.makeGiphySearchURL(query: query) else {
            completion(.failure(GiphyAPIError.invalidQueryError(query)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(GiphyAPIError.noDataError))
                return
            }
            
            let jsonDecoder = GIFSearchJSONDecoder()
            do {
                let GIFs = try jsonDecoder.decode(SearchResult.self, from: data)
                let GIFsWithFixedWidth = GIFs.data.filter { $0.fixedWidthMP4URL != nil }
                completion(.success(GIFsWithFixedWidth))
            } catch {
                completion(.failure(error))
            }
            
            
        }.resume()
    }
}
