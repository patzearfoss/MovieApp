//
//  RunTime.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/6/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation

/// Represents the running time/duration of a movie
struct RunTime {
    
    /// The total minutes of the runtime
    let totalMinutes: UInt
    
    /// The hours component of the runtime
    let hours: UInt
    
    /// The minutes of the runtime
    let minutes: UInt
    
    /// Initializes a runtime with the number of minutes in the movie
    ///
    /// - Parameter minutes: the total minute count
    init(minutes: UInt) {
        totalMinutes = minutes
        self.minutes = totalMinutes % 60
        hours = minutes / 60
    }
    
    /// Returns a formatted string of the run time.
    ///
    /// This will omit the hours the runtime is less than 60 minutes. 
    /// Likewise if the duration falls evenly on an hour then the minutes
    /// will be omitted. 
    /// If the time is zero this property returns "0m"
    var formatted: String {
        var string = ""
        if hours > 0 {
            string += "\(hours)h"
        }
        
        if minutes > 0 {
            string += "\(minutes)m"
        }
        
        if minutes == 0 && hours == 0 {
            string = "0m"
        }
        
        return string
    }
}
