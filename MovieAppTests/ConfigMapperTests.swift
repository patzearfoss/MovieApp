//
//  ConfigMapperTests.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/12/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import XCTest
@testable import MovieApp

class ConfigMapperTests: XCTestCase {
    
    var json: [String: Any]?
    
    override func setUp() {
        super.setUp()
        
        do {
            json = try loadJsonFile(named:"Config")
        } catch {
            print("json couldn't be loaded \(error)")
        }
        
    }
    
    func testBadJson() {
        let empty = [String: Any]()
        let mapper = ConfigMapper()
        
        XCTAssertThrowsError(try mapper.configFromJson(json: empty))
    }
    
    func testSampleJson() {
        let mapper = ConfigMapper()
        let config = try! mapper.configFromJson(json: json!)
        
        XCTAssertEqual(config.imageBaseUrl, "https://image.tmdb.org/t/p/")
        XCTAssertEqual(config.posterSizes, PosterImageSize.all)
        
    }
    
}
