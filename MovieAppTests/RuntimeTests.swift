//
//  RuntimeTests.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/6/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import XCTest
@testable import MovieApp

class RuntimeTests: XCTestCase {
    
    func testZeroMinutes() {
        let rt = RunTime(minutes: 0)
        XCTAssertEqual(rt.formatted, "0m")
    }
    
    func testUnderHour() {
        let rt = RunTime(minutes: 45)
        XCTAssertEqual(rt.formatted, "45m")
    }
    
    func testMultipleEvenHours() {
        let rt = RunTime(minutes: 180)
        XCTAssertEqual(rt.formatted, "3h")
    }
    
    func testExactlyOneHour() {
        let rt = RunTime(minutes: 60)
        XCTAssertEqual(rt.formatted, "1h")
    }
    
    func testMixedTime() {
        let rt = RunTime(minutes: 90)
        XCTAssertEqual(rt.formatted, "1h30m")
    }
    
}
