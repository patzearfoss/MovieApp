//
//  MovieApiConfig.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/12/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation

/// Poster image sizes from the api
enum PosterImageSize: String {
    
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
    case original
    
    static func sizes(from strings: [String]) -> [PosterImageSize] {
        
        let sizes = strings.flatMap {
            return PosterImageSize(rawValue: $0)
        }
        
        return sizes
        
    }
    
    static var all: [PosterImageSize] {
        get {
            return [.w92, .w154, .w185, .w342, .w500, .w780, .original]
        }
    }
}

struct MovieApiConfig {
    
    /// The base url for all images
    let imageBaseUrl: String
    
    /// The availble image sizes
    let posterSizes: [PosterImageSize]
}
