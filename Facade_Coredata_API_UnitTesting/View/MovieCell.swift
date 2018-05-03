//
//  MovieCell.swift
//  careem_execise
//
//  Created by Waseem on 22/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    
    //MARK: Outlets
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieReleasedDateLabel: UILabel!
    @IBOutlet weak var movieOverViewTextView: UITextView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    //MARK: Properties
    //Using Observer pattern to update elemnets of MovieCell
    var movie:Movie? {
        didSet{
            
            guard let movie = movie else {
                return
            }
            
            movieNameLabel.text = movie.movieName
            
            if (movie.releaseDate?.isEmpty)! {
                
               movieReleasedDateLabel.text = "Release date unknown"
                
            }else {
                
                movieReleasedDateLabel.text = Date.getFormattedDate(dateString: movie.releaseDate!)
                
            }
            
            movieOverViewTextView.text = movie.fullMovieReview
            moviePosterImageView.image = UIImage(named: "movies1")
            
        }
    }
    
    //reset the set on cell reusage to avaoid flicking
    func resetMovieCell() {
        
        movieNameLabel.text = ""
        movieReleasedDateLabel.text = ""
        movieOverViewTextView.text = ""
        moviePosterImageView.image = UIImage(named: "movies1")
    }
    
}
