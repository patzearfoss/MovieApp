//
//  SearchResultsTests.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/11/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import XCTest
@testable import MovieApp

class SearchResultsTests: XCTestCase {
    
    var json1: [String: Any]?
    var json2: [String: Any]?
    var searchResults: SearchResults?
    
    override func setUp() {
        super.setUp()
        
        do {
            json1 = try loadJsonFile(named: "SearchResults")
            json2 = try loadJsonFile(named: "SearchResultsPage2")
        } catch {
            print("json couldn't be loaded \(error)")
        }
        
    }
    
    func testCombining() {
        let mapper = SearchResultsMapper()
        let results1 = try! mapper.searchResponseFromJson(json: json1!)
        let results2 = try! mapper.searchResponseFromJson(json: json2!)
        
        let added = results1 + results2
        
        XCTAssertEqual(added.movies.count, 40)
        XCTAssertEqual(added.pageCount, 83)
        XCTAssertEqual(added.totalResults, 1649)
        XCTAssertFalse(added.complete)
    }
    
    func testCorrectReplacement() {
        let mapper = SearchResultsMapper()
        var results = try! mapper.searchResponseFromJson(json: json1!)
        
        let startingMovie = results.movies[0]
        var aMovie = results.movies[0]
        aMovie.releaseYear = 2016
        
        try? results.replace(item: startingMovie, with: aMovie)
        XCTAssertEqual(results.movies[0].releaseYear, 2016)
        
    }
    
    func testIncorrectReplacement() {
        let mapper = SearchResultsMapper()
        var results = try! mapper.searchResponseFromJson(json: json1!)
        
        let aMovie = results.movies[0]
        
        XCTAssertThrowsError(try results.replace(item: aMovie, with: results.movies[1]))
    }
    
}
