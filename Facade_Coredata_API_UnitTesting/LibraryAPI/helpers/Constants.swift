//
//  Constants.swift
//  careem_execise
//
//  Created by Waseem on 21/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//


struct urlConstants {
    
    // MARK: URLs Constants
    //API
    static let API_SCHEME = "https"
    static let API_HOST = "api.themoviedb.org"
    static let API_PATH = "/3" //Remove should be 3
    static let API_KEY = "api_key"
    
    static let API_KEY_VALUE = "<user your own tmdb API_KEY>"
    
    static let API_METHOD_MOVIE_SEARCH = "/search/movie"
    static let QUERY = "query"
    static let PAGE = "page"
    static let NO_OF_PAGES = 1
    
    //images API
    static let IMAGE_API_HOST = "image.tmdb.org"
    static let IMAGE_API_PATH = "/t/p/"
    static let POSTER_SIZE = "w185"
    
    //response time out
    static let TIME_OUT = 30.0
}

struct JSONResponseKey {
    
    // MARK: Movies
    static let MOVIE_RESULTS = "results"
    static let MOVIE_NAME = "title"
    static let MOVIE_POSTER_PATH = "poster_path"
    static let MOVIE_RELEASE_DATE = "release_date"
    static let MOVIE_OVERVIEW = "overview"
    
    
}

struct ErrorCodeConstants {
    
    static let unauthorizedCode = 401;
    static let serverNotFoundCode = 404;
    static let internalServerErrorCode = 500;
    
    /*Move error code should come here*/
}

struct literalContants {
    
    static let suggestions = "suggestions"
    static let maxLimit = 9
    
    //cache images local directory
    static let imageLocalPath = "movies/images"
    
    static let noResultFound = "No Result Found."
}
