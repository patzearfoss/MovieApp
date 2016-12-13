//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/6/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import Foundation
import UIKit

/// A view model describing a table cell for the movie list
struct MovieCellModel: Equatable {
    
    /// The id of the movie.
    let id: MovieId
    
    /// The title of the movie
    let title: String
    
    /// The year the movie was released
    let releaseYear: String
    
    /// The image for the movie
    let image: UIImage?
}

func ==(lhs: MovieCellModel, rhs: MovieCellModel) -> Bool {
    return lhs.id == rhs.id
}

/// A view model for the movie list
class MovieListViewModel {
    
    /// Errors that can arise in the view model
    ///
    /// - internalInconsistency: There was an issue coordinating the model internals
    enum Errors: Error {
        case internalInconsistency(reason: String)
    }
    
    fileprivate var searchResults: SearchResults
    
    /// Initialize the view model with search results
    ///
    /// - Parameter searchResults: the search results
    init(searchResults: SearchResults) {
        self.searchResults = searchResults

        cellModels = searchResults.movies.map(mapMovieToCellModel)
        hasMoreResults = !searchResults.complete
        
        downloadImagesForViewModels()
    }
    
    /// A callback when an image is loaded for the specified cell model
    var imageLoaded: ((MovieCellModel, Int) -> Void)?
    
    /// Construct a new view model adding the data from `searchResults`
    ///
    /// - Parameter searchResults: the search results to add in. This method naïvely
    ///      assumes this if from the same search as the current view model
    /// - Returns: the newly initalized view model
    func newViewModel(adding searchResults: SearchResults) -> MovieListViewModel {
        
        let combinedResults = self.searchResults + searchResults
        return MovieListViewModel(searchResults: combinedResults)
        
    }
    
    fileprivate func mapMovieToCellModel(movie: Movie) -> MovieCellModel {
        let year = movie.releaseYear != nil ? "\(movie.releaseYear!)" : ""
        let cellModel = MovieCellModel(id: movie.id, title: movie.title, releaseYear: year, image: movie.image)
        return cellModel
    }
    
    /// Locate a movie for its corresponding cell
    ///
    /// - Parameter cellModel: the cell
    /// - Returns: a movie object from the view model
    /// - Throws: Errors.internalInconsistency when the movie cannot be found
    func movie(forCellModel cellModel: MovieCellModel) throws -> Movie {
        let indexOpt = cellModels.index { (item) -> Bool in
            return item == cellModel
        }
        
        if let index = indexOpt {
            let movie = searchResults.movies[index]
            return movie
        }
        
        throw Errors.internalInconsistency(reason: "Movie not found for id: \(cellModel.id)")
    }
    
    /// The cell models for the movie list
    fileprivate(set) var cellModels = [MovieCellModel]()
    
    /// Whether there are more results that can be fetched from the server
    private(set) var hasMoreResults = false
    
    /// The next page number that could be loaded, if one exists.
    var nextPage: Int? {
        return searchResults.nextPageToLoad
    }
}

private typealias ImageDownloads = MovieListViewModel
extension ImageDownloads {
    
    /// Fetch images for search results that don't yet have them
    func downloadImagesForViewModels() {
        
        let cellModelsNeedingImages = cellModels.filter { (cellModel) -> Bool in
            return cellModel.image == nil
        }
        
        cellModelsNeedingImages.forEach { (cellModel) in
            guard let originalMovie = try? movie(forCellModel: cellModel) else {
                return
            }
            
            try? MovieApi.downloadImage(movie: originalMovie) { [weak self] (movie, error) in
                if let newMovie = movie {
                    
                    guard let safeSelf = self else {
                        return
                    }
                    
                    try? safeSelf.searchResults.replace(item: originalMovie, with: newMovie)
                    if let index = safeSelf.cellModels.index(of: cellModel) {
                        safeSelf.cellModels[index] = safeSelf.mapMovieToCellModel(movie: newMovie)
                        safeSelf.imageLoaded?(safeSelf.cellModels[index], index)
                    }
                }
            }
        }
    }
    
}

