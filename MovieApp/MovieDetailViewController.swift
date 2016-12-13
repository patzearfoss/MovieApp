//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/11/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var yearLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?
    @IBOutlet weak var runtimeLabel: UILabel?
    @IBOutlet weak var overviewLabel: UILabel?
    
    var movie: Movie? {
        didSet {
            if let m = movie {
                viewModel = MovieDetailViewModel(movie: m)
                if !m.hasDetails {
                    fetchDetails(movie: m)
                }
            } else {
                viewModel = nil
            }
        }
    }
    
    var viewModel: MovieDetailViewModel? {
        didSet {
            refreshView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshView() {
        if let vm = viewModel {
            titleLabel?.text = vm.title
            yearLabel?.text = vm.releaseYear
            ratingLabel?.text = vm.rating
            overviewLabel?.text = vm.overview
            runtimeLabel?.text = vm.runtime
            imageView?.image = vm.image
        } else {
            [titleLabel, yearLabel, ratingLabel, overviewLabel, runtimeLabel].forEach{ $0?.text = nil }
            imageView?.image = nil
        }
    }
    
    func fetchDetails(movie: Movie) {
        do {
            try MovieApi.fetchDetails(movie: movie) { (newMovie, error) in
                if let m = newMovie {
                    var mutable = m
                    mutable.hasDetails = true
                    mutable.image = movie.image
                    self.movie = mutable
                } else {
                    print ("couldn't get movie details \(error)")
                }
            }
        } catch {
            print ("couldn't get movie details \(error)")
        }
    }
}
