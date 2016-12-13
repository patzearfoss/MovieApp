//
//  ConfigMapper.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/12/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation


/// A utility for mapping json into the needed MovieApiConfig
struct ConfigMapper {
    
    /// Config mapper errors
    ///
    /// - jsonError: There was an issue with the input json
    private enum Errors: Error {
        case jsonError(reason: String)
    }
    
    /// Map json into needed configuration
    ///
    /// - Parameter json: the input json
    /// - Returns: the filled out api config
    /// - Throws: ConfigMapper.Errors in the event of a problem
    func configFromJson(json: [String: Any]) throws -> MovieApiConfig {
    
        guard let imageStruct = json["images"] as? [String: Any],
            let baseUrlString = imageStruct["secure_base_url"] as? String else {
            
            throw Errors.jsonError(reason: "base url missing")
        }
        
        guard let sizeStrings = imageStruct["poster_sizes"] as? [String] else {
            throw Errors.jsonError(reason: "Couldn't find size strings")
        }
    
        let sizes = PosterImageSize.sizes(from: sizeStrings)
        if sizes.count <= 0 {
            throw Errors.jsonError(reason: "Couldn't find size strings")
        }
        
        let config = MovieApiConfig(imageBaseUrl: baseUrlString, posterSizes: sizes)
        return config
    }
}
