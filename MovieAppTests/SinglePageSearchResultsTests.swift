//
//  SinglePageSearchResultsTests.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/10/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import XCTest
@testable import MovieApp

class SinglePageSearchResultsTests: XCTestCase {
    
    var json: [String: Any]?
    var searchResults: SearchResults?
    
    override func setUp() {
        super.setUp()
        
        do {
            json = try loadJsonFile(named:"OnePageOnlySearchResults")
        } catch {
            print("json couldn't be loaded \(error)")
        }
        
    }

    func testProperJson() {
        let mapper = SearchResultsMapper()
        XCTAssertNotNil(try? mapper.searchResponseFromJson(json: json!))
    }
    
    func testTopLevelMapping() {
        let mapper = SearchResultsMapper()
        let results = try! mapper.searchResponseFromJson(json: json!)
        
        XCTAssertEqual(results.pageCount, 1)
        XCTAssertEqual(results.complete, true)
        XCTAssertEqual(results.totalResults, 20)
        XCTAssertEqual(results.movies.count, 20)
    }
    
}
