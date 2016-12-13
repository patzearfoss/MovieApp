//
//  MoviesURLSession.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/10/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation
import UIKit

private let moviesUrlSession = URLSession(configuration: URLSessionConfiguration.default)

private let imageCache = NSCache<NSURL, UIImage>()

private let apiKey = "1419277c31b39f8ca591b8da5d77b5f8"

private var config: MovieApiConfig?

extension MovieApiConfig {
    
    var preferredImageSize: PosterImageSize? {
        if posterSizes.contains(.w92) {
            return .w92
        }
        
        return nil
    }
    
}

enum HTTPResponseCode: Int {
    
    case OK = 200
    case Unauthorized = 401
    case NotFound = 404
    
}

enum MovieApi {

    /// Errors that can be thrown from the MovieApi
    ///
    /// - invalidSearchQuery: a search query wasn't valid
    /// - httpError: wraps an http response code
    /// - jsonError: there was an error with the json returned from the api
    /// - imageNotValid: the downloaded image wasn't valid
    /// - unknown: another error occurred
    enum Errors: Error {
        
        case invalidSearchQuery
        case httpError(code: HTTPResponseCode)
        case jsonError
        case imageNotValid
        case unknown(reason: String)
    }
    
    static func setup() {
        do {
            try loadConfiguration { configOpt, error in
                config = configOpt
            }
        } catch {
            print(error)
        }
    }
    
    /// A response from the search api
    typealias SearchResponseHandler = (SearchResults?, Error?) -> Void
    
    /// A response from the movie api
    typealias MovieDetailsResposeHandler = (Movie?, Error?) -> Void
    
    /// A response when downloading an image
    typealias ImageDownloadResponseHandler = (Movie?, Error?) -> Void
    
    /// A response when the config is retreived
    typealias ConfigResponseHandler = (MovieApiConfig?, Error?) -> Void
    
    fileprivate static func preprocessResponse(data: Data?, response: URLResponse?, error: Error?) throws -> [String: Any] {
        guard let urlResponse = response as? HTTPURLResponse else {
            let error = Errors.unknown(reason: "Response did not exist")
            throw error
        }
        
        guard let code = HTTPResponseCode(rawValue: urlResponse.statusCode) else {
            let error = Errors.unknown(reason: "No response code")
            throw error
        }
        
        if (code != .OK) {
            let error = Errors.httpError(code: code)
            throw error
        }
        
        guard let data = data,
            let _json = try? JSONSerialization.jsonObject(with: data, options: []),
            let json = _json as? [String: Any] else {
                
            let error = Errors.jsonError
            throw error
        }
        
        return json

    }
    
    
    static func search(query: String, page: Int = 1, responseHandler:@escaping SearchResponseHandler) throws {
        guard let searchUrl = searchUrl(query: query, page: page) else {
            throw Errors.invalidSearchQuery
        }
        
        let task = moviesUrlSession.dataTask(with: searchUrl) { data, response, error in
            
            do {
                let json = try preprocessResponse(data: data, response: response, error: error)
                
                let mapper = SearchResultsMapper()
                guard let results = try? mapper.searchResponseFromJson(json: json) else {
                    let error = Errors.jsonError
                    DispatchQueue.main.async { responseHandler(nil, error) }
                    return
                }
                
                DispatchQueue.main.async {
                    responseHandler(results, error)
                }
                
            } catch {
                DispatchQueue.main.async { responseHandler (nil, error) }
            }

        }
        
        task.resume()
    }
    
    

    
    static func searchUrl(query: String, page: Int = 1) -> URL? {
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        let searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=star&query=\(encodedQuery))&page=\(page)&include_adult=false"
        
        
        return URL(string: searchUrl)
        
    }
    
}

extension MovieApi {
    
    static func loadConfiguration(responseHandler: @escaping ConfigResponseHandler) throws {
        guard let url = configUrl() else {
            throw Errors.unknown(reason: "Couldn't create config url")
        }
        
        let task = moviesUrlSession.dataTask(with: url) { data, response, error in
            
            do {
                let json = try preprocessResponse(data: data, response: response, error: error)
                let mapper = ConfigMapper()
                if let config = try? mapper.configFromJson(json: json) {
                    DispatchQueue.main.async {
                        responseHandler(config, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        responseHandler(nil, Errors.jsonError)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    responseHandler(nil, Errors.jsonError)
                }
            }
        }
        
        task.resume()
    }
    
    static func configUrl() -> URL? {
        
        let urlString = "https://api.themoviedb.org/3/configuration?api_key=\(apiKey)"
        return URL(string: urlString)
    }
    
}

extension MovieApi {
    
    static func movieDetailsUrl(id: MovieId) -> URL? {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&language=en-US"
        return URL(string: urlString)
        
    }
    
    
    /// Load extra details for the movie
    ///
    /// - Parameters:
    ///   - movie: the movie to load
    ///   - responseHandler: called when the load is complete
    /// - Throws: an error if the url cannot be created.
    static func fetchDetails(movie: Movie, responseHandler:@escaping MovieDetailsResposeHandler) throws {
        
        guard let url = movieDetailsUrl(id: movie.id) else {
            throw Errors.unknown(reason: "Couldn't create detail url")
        }
        
        let task = moviesUrlSession.dataTask(with: url) { data, response, error in
            do {
                let json = try preprocessResponse(data: data, response: response, error: error)
                
                let mapper = SearchResultsMapper()
                guard let movie = try? mapper.movieFromJSON(json: json) else {
                    let error = Errors.jsonError
                    DispatchQueue.main.async { responseHandler(nil, error) }
                    return
                }
                
                DispatchQueue.main.async {
                    responseHandler(movie, nil)
                }
                
            } catch {
                DispatchQueue.main.async { responseHandler (nil, error) }
            }
        }
        
        task.resume()
        
    }

}

extension MovieApi {
    
    static func imageUrl(movie: Movie) -> URL? {
        
        guard let config = config else {
            return nil
        }
        
        guard let imagePath = movie.imagePath else {
            return nil
        }
        
        guard let preferredSize = config.preferredImageSize else {
            return nil
        }
        
        return URL(string: config.imageBaseUrl + preferredSize.rawValue + imagePath)
    }
    
    
    /// Download the image for the specified movie
    ///
    /// - Parameters:
    ///   - movie: the movie
    ///   - responseHandler: called when the image downlod completes
    /// - Throws: an error in the case of a bad url
    static func downloadImage(movie: Movie, responseHandler: @escaping ImageDownloadResponseHandler) throws {
        
        guard let url = imageUrl(movie: movie) else {
            throw Errors.unknown(reason: "Coudln't get image url")
        }
        
        let task = moviesUrlSession.dataTask(with: url) { data, response, error in
            
            guard let urlResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { responseHandler(nil, Errors.unknown(reason: "Response did not exist")) }
                return
            }
            
            guard let code = HTTPResponseCode(rawValue: urlResponse.statusCode) else {
                DispatchQueue.main.async { responseHandler(nil, Errors.unknown(reason: "No response code")) }
                return
            }
            
            if (code != .OK) {
                DispatchQueue.main.async { responseHandler(nil, Errors.httpError(code: code)) }
                return
            }

            guard let data = data,
                let image = UIImage(data: data) else {
                DispatchQueue.main.async { responseHandler(nil, Errors.imageNotValid) }
                return
            }
            
            var newMovie = movie
            newMovie.image = image
            
            DispatchQueue.main.async {
                responseHandler(newMovie, nil)
            }
        }
        
        task.resume()
    }
}
