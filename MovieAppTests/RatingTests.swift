//
//  RatingTests.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/8/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import XCTest
@testable import MovieApp

class RatingTests: XCTestCase {
    
    func testInBounds() {
        let rating = try? MovieRating(value: 5.0)
        XCTAssertNotNil(rating)
    }
    
    func testOutOfBounds() {
        XCTAssertThrowsError(try MovieRating(value: -0.1))
        XCTAssertThrowsError(try MovieRating(value: 10.1))
    }
    
    func testEquivalenceValues() {
        XCTAssertNotNil(try? MovieRating(value: 0.0))
        XCTAssertNotNil(try? MovieRating(value: 10.0))
    }
    
    func testStringFormat() {
        let rating = try? MovieRating(value: 5.0)
        XCTAssertNotNil(rating)
        
        if let strVal = rating?.stringValue {
            XCTAssertEqual(strVal, "5.0")
        }
    }
}
