//
//  SearchResponse.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/6/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation
import UIKit

func +(lhs: SearchResults, rhs: SearchResults) -> SearchResults {
    
    var newResults = SearchResults(pageCount: lhs.pageCount, totalResults: lhs.totalResults)
    newResults.movies = lhs.movies + rhs.movies
    let loadedPages = lhs.loadedPages.union(rhs.loadedPages)
    newResults.loadedPages = loadedPages
    
    return newResults
}

/// Search results from the web service
struct SearchResults {
    
    enum Errors: Error {
        case movieReplacementError(reason: String)
    }
    
    /// The list of movies returned in the search
    fileprivate(set) var movies = [Movie]()
    
    /// The total number of possible pages
    let pageCount: Int
    
    /// The total number of possible results
    let totalResults: Int
    
    let completedIndexSet: IndexSet
    
    /// Whether the search results contains all pages
    var complete = false
    
    /// The page number of the next page to load
    var nextPageToLoad: Int? {
        if complete {
            return nil
        }
        
        return loadedPages.last! + 1
    }
    
    fileprivate var loadedPages = IndexSet() {
        didSet {
            complete = loadedPages == completedIndexSet
        }
    }
    
    
    /// Initializes a set of search results, specifying the total number of pages 
    /// and results
    ///
    /// - Parameters:
    ///   - pageCount: the page count
    ///   - totalResults: the result count
    init(pageCount: Int, totalResults: Int) {
        
        self.pageCount = pageCount
        self.totalResults = totalResults
        
        if (pageCount == 0 && totalResults == 0) {
            completedIndexSet = IndexSet(integer: 0)
            complete = true
        } else {
            completedIndexSet = IndexSet(integersIn: 1...pageCount)
        }
    }
    
    /// Add movies to the result
    ///
    /// - Parameters:
    ///   - items: the items to add
    ///   - page: the page from which the items originate
    mutating func add(items: [Movie], forPage page:Int) {
        self.movies.append(contentsOf: items)
        loadedPages.insert(page)
    }
    
    /// Replace an item in the results
    ///
    /// - Parameters:
    ///   - item: the item being replaced
    ///   - movie: the item being inserted
    /// - Throws: an error if the movie ids do not align
    mutating func replace(item: Movie, with movie:Movie) throws {
        if item.id != movie.id {
            throw Errors.movieReplacementError(reason: "Movie ids must match")
        }
        
        let index = movies.index { (m) -> Bool in
             m.id == movie.id
        }
        
        guard let idx = index else {
            throw Errors.movieReplacementError(reason: "Couldn't find existing movie")
        }
        
        movies[idx] = movie
    }
}
