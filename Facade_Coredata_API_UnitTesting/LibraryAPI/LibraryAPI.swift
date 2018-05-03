//
//  LibraryAPI.swift
//  careem_execise
//
//  Created by Waseem on 22/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//

import Foundation

//singleton class 
final class LibraryAPI {
    
    //MARK: - Singletone
    static let shared = LibraryAPI()
    
    //keeps the object of httpClient
    private let httpClient = HTTPClient()
    private let persistanceManager = PersistencyManager()
    
    private init() {
        
    }
    
    //MARK: Network Library
    
    /**
     It takes search srting and returns Movies result in JSON format.
     - Parameter searchString: search keyword user typed
     - Parameter Completion handler: block closure to pass back the movie resul
     */
    func getMoviesForSearchString(_ searchString: String, completionHandlerForMovieSearch: @escaping (_ result: [Movie]?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
       /*dynamically prepare the URL Query*/
        let parameters = [urlConstants.QUERY: searchString,urlConstants.PAGE:urlConstants.NO_OF_PAGES] as [String : Any]
        
        /* Make the GET request */
        let task = httpClient.requestGETMethodAPI(urlConstants.API_METHOD_MOVIE_SEARCH, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* Send the value(s) to completion handler */
            if let error = error {
                completionHandlerForMovieSearch(nil, error)
            } else {
                
                if let results = results?[JSONResponseKey.MOVIE_RESULTS] as? [[String:AnyObject]] {
                    
                  //  print("inside getMoviesForSearchString:",results)
                   let movies = Movie.moviesFromSearchResults(results)
                    completionHandlerForMovieSearch(movies, nil)
                    
                } else {
                    completionHandlerForMovieSearch(nil, NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForSearchString"]))
                }
            }
        }
        
        return task
    }
    
    /**
     download images asynchornously
     - Parameter imagePath: imageName as path
     - Completion handler: block closure to pass back the imagedata
     */
    func downloadImage(_ imagePath: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) {
        
        httpClient.downloadImageTask(imagePath) { (data, error) in
            
            if let error = error {
                
                print("Image download:",error.localizedDescription)
                completionHandlerForImage(nil, error)
                
            } else {
                
                completionHandlerForImage(data, nil)
                saveImageInLocalDir(data!, imagePath)
                    
                }
            }
        }
    
    
    //MARK: Persistance Library
    
    /**
        Passes search string to Persitance layer to save in core data
     - Parameter searchKeyword: string keyword
     - Completion handler: block closure to pass back the imagedata
     */
    func saveSuggestion(_ searchKeyword:String) {
        
        persistanceManager.saveDataToDB(searchKeyword: searchKeyword)
        
    }
    
    
    /**
     gets records from persitance layer
     - Return: Array of Suggestion from core data
     */
    func getSuggestions() -> [Suggestion]? {
        
        return persistanceManager.fetchDataFromDB();
    }
    
    
    /**
     ask persitance layer to delete record
     - Return: Array of Suggestion from core data
     */
    func deleteSuggestion()  {
        
        persistanceManager.deleteDataFromDB()
    }

}
