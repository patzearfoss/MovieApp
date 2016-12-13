//
//  MovieDetailMappingTests.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/11/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import XCTest
@testable import MovieApp

class MovieDetailMappingTests: XCTestCase {
    
    var json: [String: Any]?
    
    override func setUp() {
        super.setUp()
        
        do {
            json = try loadJsonFile(named:"MovieDetail")
        } catch {
            print("json couldn't be loaded \(error)")
        }
        
    }

    func testDetail() {
        
        let mapper = SearchResultsMapper()
        let movie = try! mapper.movieFromJSON(json: json!)
        
        // We know this works generally from the SearchResultsMappingTests, so check only the runtime
        XCTAssertEqual(movie.runtime!.formatted, "2h1m")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
