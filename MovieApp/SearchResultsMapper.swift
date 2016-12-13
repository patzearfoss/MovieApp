//
//  SearchResultsMapper.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/8/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation

/// Json errors
///
/// - invalidInputJson: an issue with the input json
/// - invalidYear: the json contained invalid date time information
enum SearchResultsMapperError: Error {
    case invalidInputJson(details: String)
    case invalidYear
}

/// A utility for mapping movies and search results
struct SearchResultsMapper {
    
    private let dateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-mm-dd"
        return formatter
    }()
    
    /// Create a movie object from json
    ///
    /// - Parameter json: the json repsonse
    /// - Returns: a movie struct
    /// - Throws
    func movieFromJSON(json: [String: Any]) throws -> Movie {
        
        guard let movieId = json["id"] as? MovieId,
            let title = json["title"] as? String else {
                throw SearchResultsMapperError.invalidInputJson(details: "invalid movie json")
        }
        
        var movie = Movie(id: movieId)
        movie.title = title
    
        if let overview = json["overview"] as? String { movie.description = overview }
        
        if let ratingVal = json["vote_average"] as? Float {
            movie.rating = try? MovieRating(value: ratingVal)
        }
        
        if let releaseDateStr = json["release_date"] as? String,
            let releaseDate = dateFormatter.date(from: releaseDateStr) {
            
            movie.releaseYear = NSCalendar.current.component(.year, from: releaseDate)
        }
    
        if let imagePath = json["poster_path"] as? String {
            movie.imagePath = imagePath
        }
        
        if let runtime = json["runtime"] as? Int {
            movie.runtime = RunTime(minutes: UInt(runtime))
        }
        
        return movie
        
    }
    
    /// Creates a search response object from json
    ///
    /// - Parameter json: the input json
    /// - Returns: the search results
    /// - Throws
    func searchResponseFromJson(json: [String: Any]) throws -> SearchResults {
        
        guard let pageCount = json["total_pages"] as? Int,
            let totalResults = json["total_results"] as? Int,
            let moviesJson = json["results"] as? [[String: AnyObject]],
            let currentPage = json["page"] as? Int else {
            throw SearchResultsMapperError.invalidInputJson(details: "invalid search results json")
        }
        
        var response = SearchResults(pageCount: pageCount, totalResults: totalResults)
        
        let movies = moviesJson.flatMap{ try? movieFromJSON(json:$0) }
        
        response.add(items: movies, forPage: currentPage)
        
        
        return response
        
    }
    
}
