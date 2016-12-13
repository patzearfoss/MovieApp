//
//  SearchResponse.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/6/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation
import UIKit


struct SearchResults {
    
    private(set) var movies = [Movie]()
    
    let pageCount: Int
    let totalResults: Int
    
    private let completedIndexSet: IndexSet
    
    var complete = false
    
    private var loadedPages = IndexSet() {
        didSet {
            complete = loadedPages == completedIndexSet
        }
    }
    
    init(pageCount: Int, totalResults: Int) {
        
        self.pageCount = pageCount
        self.totalResults = totalResults
        
        let rng = 0..<pageCount
        
        completedIndexSet = IndexSet(integersIn: rng)
    }
    
    mutating func add(items: [Movie], forPage page:Int) {
        self.movies.append(contentsOf: items)
        loadedPages.insert(page)
    }
}
