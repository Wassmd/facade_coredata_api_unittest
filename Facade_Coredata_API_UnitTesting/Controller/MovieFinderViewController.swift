//
//  ViewController.swift
//  careem_execise
//
//  Created by Waseem on 23/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//

import UIKit

//Main View controller to search and display Movies

class MovieFinderViewController: UIViewController {
    
    // MARK: Properties
    
    // the data array for the movietableView
    private var movies = [Movie]()
    
    //MARK: Oulets
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var suggestionTableView: UITableView!
    
    //Remove it not needed
    @IBOutlet weak var searchButton: UIButton!
    
    // keep Task reference. Cancel the task if new request and meanwhile old task is in progress
    var searchTask: URLSessionDataTask?
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set as self to searchbar delegate
        movieSearchBar.delegate = self
        
    }
    
    // MARK: keyboard Dismissals
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //May be used in future to clear memory warning if any
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action methods
    
    /**
     Search button Action to search movies with search key words
     - Parameter sender: Button
     */
    @IBAction func searchMovieAction(_ sender: Any) {
        
        //always hide suggestion tableview on search action
        suggestionTableView.isHidden = true
        
        //dismiss keyboard on click of search button
        self.dismissKeyboard()
        
        // cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        //get search keyword text
        let searchText = movieSearchBar.text
        
        // if the text is empty we are done
        guard !(searchText?.trim().isEmpty)! else {
            return
        }
        
        //start Progress activity
        loadingViewWithText(text: "Loading...", hide: false)
        
        //make search API call
        searchTask = LibraryAPI.shared.getMoviesForSearchString(searchText!) { (movies, error) in
            
            self.searchTask = nil
            
            guard error == nil else {
                
                //There is an error and show it on View
                // print("inside searchMovieAction", error!.code)
                let errorMessage = ErrorMessage.getReadableErrorMessage(error!.code)
                
                //UI show alertView in main thread
                DispatchQueue.main.async {
                    //hide progress
                    loadingViewWithText(text: "", hide: true)
                    showAlertMessage(self,errorMessage)
                }
                return
            }
            
            if let movies = movies {
                
                //reload the movies came from server
                self.movies = movies
                
                //UI updates in Main thread..
                DispatchQueue.main.async {
                    
                    //hide progress
                    loadingViewWithText(text: "", hide: true)
                    
                    //Everything went perfect and load tableView
                    self.movieTableView.reloadData()
                    
                    if movies.count == 0 {
                        self.showNoResultUI(literalContants.noResultFound)
                        showAlertMessage(self,literalContants.noResultFound)
                        
                    }else {
                        //cosmetic
                        self.showNoResultUI("")
                        //store the search keyword
                        manageSearchSuggestions(searchString: searchText!)
                    }
                }
            }
            
        }
    }
    
    //UI for tableView
    func showNoResultUI(_ message:String) {
        
        let noResultLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.movieTableView.bounds.size.width, height: self.movieTableView.bounds.size.height))
        noResultLabel.text          = message  //e.g "No Result Found."
        noResultLabel.textColor     = UIColor.darkGray
        noResultLabel.textAlignment = .center
        self.movieTableView.backgroundView  = noResultLabel
        self.movieTableView.separatorStyle  = .none
        
    }
}

//MARK: TableView datasource and delegate
extension MovieFinderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int = 0
        
        //return count for Movies
        if tableView == self.movieTableView {
            
            count = movies.count
            
        }
        
        //return count for suggestion
        if tableView == self.suggestionTableView {
            if LibraryAPI.shared.getSuggestions() != nil {
                //                count = ((UserDefaults.standard.stringArray(forKey:               literalContants.suggestions))?.count)!
                
                count = LibraryAPI.shared.getSuggestions()!.count
            }
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //This tableView is to display MovieSearch results list
        if tableView == self.movieTableView {
            
            let aMovie = movies[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieSearchCell", for: indexPath) as! MovieCell
            
            cell.resetMovieCell()
            
            cell.movie = aMovie
            
            if let moviePoster = aMovie.moviePoster {
                
                //                if let cachePosterImage = self.cachedImages[moviePoster] {
                if let cachePosterImage = fetchImageFromLocalDir(moviePoster) {
                    
                    cell.moviePosterImageView.image = cachePosterImage
                    
                }else {
                    
                    LibraryAPI.shared.downloadImage(moviePoster, completionHandlerForImage: { (data, error) in
                        
                        guard error == nil else {
                            return
                        }
                        
                        if let data = data {
                            
                            let downloadedPosterImage = UIImage(data: data)
                            
                            DispatchQueue.main.async {
                                if  let reusedMoviecell = self.movieTableView.cellForRow(at: indexPath) as? MovieCell{
                                    reusedMoviecell.moviePosterImageView.image = downloadedPosterImage
                                }
                            }
                            
                        }
                    })
                }
            }
            
            return cell
        }
        
        if tableView == self.suggestionTableView {
            
            //let suggestions = UserDefaults.standard.stringArray(forKey: literalContants.suggestions)
            let suggestion = LibraryAPI.shared.getSuggestions()![indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieSuggestionCell", for: indexPath)
            
            // cell.textLabel?.text = suggestions![indexPath.row]
            cell.textLabel?.text = suggestion.value(forKey: "searchKeyword") as? String
            cell.imageView?.image = UIImage(named: "search2")
            
            return cell
        }
        
        //return the default if no tableview match
        return UITableViewCell()
        
    }
    
    //Gives header to Suggestion tableView
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == self.suggestionTableView {
            
            return "Recent search"
        }
        
        return nil
    }
    
    //Delegate method of UITableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.suggestionTableView {
            
            let suggestion = LibraryAPI.shared.getSuggestions()![indexPath.row]
            movieSearchBar.text = suggestion.value(forKey: "searchKeyword") as? String
            searchMovieAction((Any).self)
            // print("Saved data of Core data",LibraryAPI.shared.getSuggestions()!)
            
        }
    }
}

//MARK: extension Search Bar Delegate

extension MovieFinderViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchMovieAction((Any).self)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        if  LibraryAPI.shared.getSuggestions() != nil {
            
            suggestionTableView.reloadData()
            suggestionTableView.isHidden = false
        }
        
        return true
    }
}


/*Scroll view UIScrollViewDelegate used to dismiss keyboard
 when visible while draging Tableview */
extension MovieFinderViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.movieSearchBar.resignFirstResponder()
    }
}

//END


