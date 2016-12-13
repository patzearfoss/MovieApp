//
//  MovieDetailViewModelTests.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/11/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import XCTest
@testable import MovieApp

class MovieDetailViewModelTests: XCTestCase {
    
    func testEmptyViewModel() {
        var testMovie = Movie(id: 123)
        testMovie.title = "Movie Title"
        testMovie.description = "Test description"
        testMovie.rating = try! MovieRating(value: 7.5)
        testMovie.releaseYear = 1990
        testMovie.runtime = RunTime(minutes: 90)
        
        let viewModel = MovieDetailViewModel(movie: testMovie)
        
        XCTAssertEqual(viewModel.title, "Movie Title")
        XCTAssertEqual(viewModel.overview, "Test description")
        XCTAssertEqual(viewModel.rating, "Rating: 7.5")
        XCTAssertEqual(viewModel.releaseYear, "Release Year: 1990")
        XCTAssertEqual(viewModel.runtime, "Runtime: 1h30m")
    }
    
    func testFullViewModel() {
        let testMovie = Movie(id: 123)
        
        let viewModel = MovieDetailViewModel(movie: testMovie)
        
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.overview, "(overview not available)")
        XCTAssertEqual(viewModel.rating, "Rating: n/a")
        XCTAssertEqual(viewModel.releaseYear, "Release Year: n/a")
        XCTAssertEqual(viewModel.runtime, "Runtime: n/a")

    }
}
