//
//  MovieApiTests.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/10/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import XCTest
@testable import MovieApp

class MovieApiTests: XCTestCase {
    
    func testSearchUrlBuilder() {
        let url = MovieApi.searchUrl(query: "Test")
        XCTAssertNotNil(url)
    }
    
    
}
