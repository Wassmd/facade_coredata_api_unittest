//
//  Movie.swift
//  careem_execise
//
//  Created by Waseem on 23/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//

// 🎬 object, encapsulates movie information
struct Movie {
    
    //MARK: Properties
    let movieName:String
    let releaseDate:String?
    let moviePoster:String?
    let fullMovieReview:String?
    
    init(dictionary:[String:AnyObject]) {
        
        movieName = dictionary[JSONResponseKey.MOVIE_NAME] as! String
        releaseDate = dictionary[JSONResponseKey.MOVIE_RELEASE_DATE] as? String
        
        moviePoster = dictionary[JSONResponseKey.MOVIE_POSTER_PATH] as? String
        fullMovieReview = dictionary[JSONResponseKey.MOVIE_OVERVIEW] as? String
    }
    
    
}

/**
 
 Prepares Movie model from JSON dictionaries
 - Paramter results: dictionaries
 - Return   Movies: Array of Movies
 **/

extension Movie {
    
    static func moviesFromSearchResults(_ results:[[String:AnyObject]]) -> [Movie] {
        
        var movies = [Movie]()
        
        //create array of movie object from dictonaries in results
        for result in results {
            
            movies.append(Movie(dictionary: result))
        }
        
        //print("movies:",movies)
        return movies
        
    }
}
extension Movie:CustomDebugStringConvertible {
    
    var debugDescription: String {
        return  "movieName:\(movieName)" +
                "releaseDate:\(String(describing: releaseDate))" +
                "moviePoster:\(String(describing: moviePoster))"
    }
    
    
    
}
