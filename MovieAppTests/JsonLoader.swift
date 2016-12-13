//
//  JsonLoader.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/10/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation

private let bundleId = "com.patzearfoss.MovieAppTests"

enum JsonLoadingError: Error {
    case invalidBundle
    case fileNotFound
    case fileReadError
    case jsonParseError
    case incorrectData
}

func loadJsonFile(named: String) throws -> [String: Any] {
    
    guard let bundle = Bundle(identifier: bundleId) else {
        throw JsonLoadingError.invalidBundle
    }
    
    guard let url = bundle.url(forResource: named, withExtension: "json") else {
        throw JsonLoadingError.fileNotFound
    }
    
    guard let fileData = try? Data(contentsOf: url) else {
        throw JsonLoadingError.fileReadError
    }
    
    guard let json = try? JSONSerialization.jsonObject(with: fileData, options: []) as? [String: Any] else {
        throw JsonLoadingError.jsonParseError
    }
    
    guard let jsonObj = json else {
        throw JsonLoadingError.incorrectData
    }
    
    return jsonObj
}
