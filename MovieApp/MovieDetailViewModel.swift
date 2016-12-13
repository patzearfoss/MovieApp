//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/11/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation
import UIKit

struct MovieDetailViewModel {
    
    /// The movie title
    let title: String
    
    /// The movie description
    let overview: String
    
    /// The rating expressed as a string
    let rating: String
    
    /// The release year expressed as a string
    let releaseYear: String
    
    /// The run time expressed as a string
    let runtime: String
    
    /// The image for the movie
    let image: UIImage?
    
    /// Initialize the view model
    ///
    /// - Parameter movie: the movie to use
    init(movie: Movie) {
        title = movie.title
        overview = movie.description ?? "(overview not available)"
        
        if let movieRating = movie.rating {
            rating = "Rating: " + movieRating.stringValue
        } else {
            rating = "Rating: n/a"
        }
        
        if let year = movie.releaseYear {
            releaseYear = "Release Year: \(year)"
        } else {
            releaseYear = "Release Year: n/a"
        }
       
        if let rt = movie.runtime {
            runtime = "Runtime: \(rt.formatted)"
        } else {
            runtime = "Runtime: n/a"
        }
        
        image = movie.image
    }
    
}
