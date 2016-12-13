//
//  MovieListViewModelTests.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/10/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import XCTest
@testable import MovieApp

class MovieListViewModelTests: XCTestCase {
    
    var searchResults: SearchResults?
    
    override func setUp() {
        super.setUp()
        
        do {
            let json = try loadJsonFile(named: "SearchResults")
            searchResults = try SearchResultsMapper().searchResponseFromJson(json: json)
        } catch {
            print("couldn't make search results \(error)")
        }
        
    }
    
    func testEmpty() {
        let emptyResults = SearchResults(pageCount: 0, totalResults: 0)
        let viewModel = MovieListViewModel(searchResults: emptyResults)
        
        XCTAssertEqual(viewModel.cellModels.count, 0)
        XCTAssertFalse(viewModel.hasMoreResults)
    }
    
    func testSampleJson() {
        let viewModel = MovieListViewModel(searchResults: searchResults!)
        XCTAssertEqual(viewModel.cellModels.count, 20)
        XCTAssertTrue(viewModel.hasMoreResults)
    }
    
    func testCellModelContents() {
        let viewModel = MovieListViewModel(searchResults: searchResults!)
        let firstCell = viewModel.cellModels.first!
        
        XCTAssertEqual(firstCell.title, "Star Wars")
        XCTAssertEqual(firstCell.releaseYear, "1977")
    }
    
    func testFindMovieFromCellModel() {
        let viewModel = MovieListViewModel(searchResults: searchResults!)
        let aCell = viewModel.cellModels[5]
        
        let movie = try! viewModel.movie(forCellModel: aCell)
        XCTAssertEqual(movie.id, aCell.id)
    }
    
}
