//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/6/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import UIKit

private enum MovieListCellId: String {
    case movieCell
    case loadMoreCell
}

class MovieListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var selectedMovie: Movie?
    
    private var query = ""
    
    var viewModel = MovieListViewModel(searchResults: SearchResults(pageCount: 0, totalResults: 0)) {
        didSet {
            viewModel.imageLoaded = { [weak self] (cellModel, index) in
                print("will reload \(index)")
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
            tableView.reloadData()
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Search"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShowNotification(note:)),
                                               name:.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHideNotification(note:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
    }

    
    func performSearch(query: String) {
        
        self.query = query
        
        try? MovieApi.search(query: query) { response, error in
            
            if let results = response {
                
                let newViewModel = MovieListViewModel(searchResults: results)
                
                self.viewModel = newViewModel
            }
        }
    }
    
    func loadNextPage() {
        
        guard let nextPage = viewModel.nextPage else {
            return
        }
        
        try? MovieApi.search(query: query, page: nextPage) { response, error in
            
            if let results = response {
                let newViewModel = self.viewModel.newViewModel(adding: results)
                self.viewModel = newViewModel
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? MovieDetailViewController {
            detail.movie = selectedMovie
        }
    }
 

}

// MARK: - Table Datasource
private typealias TableViewDataSource = MovieListViewController
extension TableViewDataSource: UITableViewDataSource{
    
    static let detailsSegueIdentifier = "toDetails"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count + (viewModel.hasMoreResults ? 1 : 0)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId(forIndexPath: indexPath).rawValue, for: indexPath)
        
        if let movieCell = cell as? MovieCell {
            let cellModel = viewModel.cellModels[indexPath.row]
            movieCell.configureWithCellModel(cellModel: cellModel)
        }
        
        return cell
    }
    
    fileprivate func cellId(forIndexPath indexPath: IndexPath) -> MovieListCellId {
        if indexPath.row == viewModel.cellModels.count {
            return .loadMoreCell
        }
        
        return .movieCell
    }
    
}

// MARK: - Table delegate
private typealias TableViewDelegate = MovieListViewController
extension TableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellId = self.cellId(forIndexPath: indexPath)
        
        switch cellId {
        case .movieCell:
            let cellModel = viewModel.cellModels[indexPath.row]
            if let movie = try? viewModel.movie(forCellModel: cellModel) {
                selectedMovie = movie
                performSegue(withIdentifier: MovieListViewController.detailsSegueIdentifier, sender: self)
            }
        case .loadMoreCell:
            loadNextPage()
        }
        
    }
}

// MARK: - Keyboard Avoidance
extension MovieListViewController {
    
    func keyboardHideNotification(note: Notification) {
        var insets = tableView.contentInset
        insets.bottom = 0
        tableView.contentInset = insets
    }
    
    func keyboardShowNotification(note: Notification) {
        if let keyboardFrame = note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            var insets = tableView.contentInset
            insets.bottom = keyboardFrame.height
            tableView.contentInset = insets
        }
        
    }
    
}

// MARK: - Search bar
private typealias SearchBarDelegate = MovieListViewController
extension SearchBarDelegate: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            performSearch(query: text)
            searchBar.resignFirstResponder()
        }
    }
}

// MARK: - Movie Cell
private extension MovieCell {
    
    func configureWithCellModel(cellModel: MovieCellModel) {
        movieTitleLabel.text = cellModel.title
        releaseYearLabel.text = cellModel.releaseYear
        movieImageView.image = cellModel.image
    }
        
}

