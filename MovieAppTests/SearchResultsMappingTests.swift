//
//  SearchResultsMappingTests.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/10/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import XCTest
@testable import MovieApp

class SearchResultsMappingTests: XCTestCase {
    
    var json: [String: Any]?
    var searchResults: SearchResults?
    
    override func setUp() {
        super.setUp()
        
        do {
            json = try loadJsonFile(named: "SearchResults")
        } catch {
            print("json couldn't be loaded \(error)")
        }
        
    }
    
    func testInvalidJson() {
        
        let mapper = SearchResultsMapper()
        let data = [String:Any]()
        
        XCTAssertThrowsError(try mapper.searchResponseFromJson(json: data))
        
    }
    
    func testProperJson() {
        let mapper = SearchResultsMapper()
        XCTAssertNotNil(try? mapper.searchResponseFromJson(json: json!))
    }
    
    func testTopLevelMapping() {
        let mapper = SearchResultsMapper()
        let results = try! mapper.searchResponseFromJson(json: json!)
        
        XCTAssertEqual(results.pageCount, 83)
        XCTAssertEqual(results.complete, false)
        XCTAssertEqual(results.totalResults, 1649)
        XCTAssertEqual(results.movies.count, 20)
    }
    
    func testMovieMapping() {
        let mapper = SearchResultsMapper()
        let results = try! mapper.searchResponseFromJson(json: json!)
        let starWars = results.movies.first!
        
        XCTAssertEqual(starWars.id, 11)
        XCTAssertEqual(starWars.title, "Star Wars")
        XCTAssertEqual(starWars.description, "Princess Leia is captured and held hostage by the evil Imperial forces in their effort to take over the galactic Empire. Venturesome Luke Skywalker and dashing captain Han Solo team together with the loveable robot duo R2-D2 and C-3PO to rescue the beautiful princess and restore peace and justice in the Empire.")
        XCTAssertEqual(starWars.releaseYear, 1977)
        XCTAssertEqual(starWars.imagePath, "/tvSlBzAdRE29bZe5yYWrJ2ds137.jpg")
        XCTAssertEqual(starWars.rating?.stringValue, "7.9")
    }
    
    
    
}
