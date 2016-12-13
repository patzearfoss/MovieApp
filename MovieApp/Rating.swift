//
//  Rating.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/8/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation

/// errors in movie ratings
///
/// - invalidRatingValue: An invalid values was specified when creating a rating
enum MovieRatingError: Error {
    case invalidRatingValue(Float)
}

/// Describes a movie rating, between 0.0 and 10.0
struct MovieRating {
    
    private let backingValue: Float
    
    /// Creates a rating from a float value
    ///
    /// - Parameter value: the value of the rating
    /// - Throws: .invalidRatingValue if the values is less than 0 or more than 10
    init(value: Float) throws {
        if case 0.0 ... 10.0 = value {
            backingValue = value
        } else {
            throw MovieRatingError.invalidRatingValue(value)
        }
    }
    
    /// Returns the formatted string value of the rating
    var stringValue: String {
        return String(format: "%.1f", backingValue)
    }
}
