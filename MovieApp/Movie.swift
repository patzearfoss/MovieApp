//
//  Movie.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/6/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation
import UIKit

typealias MovieId = Int

/// Represents a movie
struct Movie {
    
    /// The movie's id
    let id: MovieId
    
    /// The title
    var title: String
    
    /// The description/overview
    var description: String?
    
    /// The year of release
    var releaseYear: Int?
    
    /// the rating given to the movie
    var rating: MovieRating?
    
    /// An associated image
    var image: UIImage?
    
    /// The path of the image on the internet
    var imagePath: String?
    
    /// The run time of the movie
    var runtime: RunTime?
    
    /// Whether additional details are loaded for the movie
    var hasDetails = false
    
    /// Initialize a movie
    ///
    /// - Parameter id: the id of the movie
    init(id: MovieId) {
        
        self.id = id
        self.title = ""
    }
    
}
