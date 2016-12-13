//
//  MoviesURLSession.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/10/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation

let moviesUrlSession = URLSession(configuration: URLSessionConfiguration.default)

let apiKey = "1419277c31b39f8ca591b8da5d77b5f8"

enum HTTPResponseCode: Int {
    
    case OK = 200
    case Unauthorized = 401
    case NotFound = 404
    
}


enum MovieApi {

    enum Errors: Error {
        
        case invalidSearchQuery
        case httpError(code: HTTPResponseCode)
        case jsonError
        case unknown(reason: String)
    }
    
    typealias SearchResponseHandler = (SearchResults?, Error?) -> Void
    
    func search(query: String, responseHandler:@escaping SearchResponseHandler) throws {
        guard let searchUrl = searchUrl(query: query) else {
            throw Errors.invalidSearchQuery
        }
        
        let task = moviesUrlSession.dataTask(with: searchUrl) { data, response, error in
            
            guard let urlResponse = response as? HTTPURLResponse else {
                let error = Errors.unknown(reason: "Response did not exist")
                responseHandler(nil, error)
                return
            }
            
            guard let code = HTTPResponseCode(rawValue: urlResponse.statusCode) else {
                let error = Errors.unknown(reason: "No response code")
                responseHandler(nil, error)
                return
            }
            
            if (code != .OK) {
                let error = Errors.httpError(code: code)
                responseHandler(nil, error)
                return
            }
            
            guard let data = data,
                let _json = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = _json as? [String: Any] else {
                
                let error = Errors.jsonError
                responseHandler(nil, error)
                return
            }
            
            let mapper = SearchResultsMapper()
            guard let results = try? mapper.searchResponseFromJson(json: json) else {
                let error = Errors.jsonError
                responseHandler(nil, error)
                return

            }
                
            responseHandler(results, error)
        }
        
        task.resume()
    }
    
    private func searchUrl(query: String) -> URL? {
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)8&language=star&query=\(encodedQuery))&page=1&include_adult=false"
        
        
        return URL(string: searchUrl)
        
    }
    
}
