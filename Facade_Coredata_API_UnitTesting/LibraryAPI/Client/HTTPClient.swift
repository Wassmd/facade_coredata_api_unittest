//
//  HTTPClient.swift
//  careem_execise
//
//  Created by Waseem on 23/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//

import Foundation

class HTTPClient:NSObject {
    
    // shared session
    private var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    // MARK: Generic GET call
    
    /* Generic GET Method server call
     - Parameter method: GET
     - Parameter parameters: to make query of URL
     - Parameter completionHandlerForGET: block to send data back
     */
    @discardableResult func requestGETMethodAPI(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
        var requestParametersWithAPIKey = parameters
        requestParametersWithAPIKey[urlConstants.API_KEY] = urlConstants.API_KEY_VALUE as AnyObject
        
        /* Prepare the URL, Configure the request */
        let request =  URLRequest(url: HTTPClient.movieURLFromParameters(requestParametersWithAPIKey,withPathExtension: method), cachePolicy: .reloadIgnoringCacheData, timeoutInterval: urlConstants.TIME_OUT)
        
        //to debug the url
      //  print(request.description)
        
        /* make GET request call*/
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String,_ code: Int) {
                
               // print(code)
                let userInfo  = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil,NSError(domain: "requestGETMethodAPI", code: code, userInfo: userInfo))
            }
            
            guard error == nil else {
                let errorCode = (error! as NSError).code
                print("error code ",errorCode)
                sendError("There was an error with your request: \(String(describing: error))",errorCode)
                return
            }
            
            /* GUARD: Check for successful response*/
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                sendError("Your request returned a status code other than 200 - 299!",(response as! HTTPURLResponse).statusCode)
                return
            }
            
            /*GUARD was there any data return*/
            guard let data = data else {
                
                sendError("No data returned by the request!",0)
                return
            }
            //print(String(data: data, encoding: String.Encoding.utf8) ?? "No data")
            
            self.parserWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
        
    }
    
    //convert the data to raw JSON, return movie Object
    private func parserWithCompletionHandler(_ data:Data, completionHandlerForConvertData:(_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult:AnyObject? = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        }catch {
            
            let userInfo = [NSLocalizedDescriptionKey : "Error in parsing data to JSON"]
            completionHandlerForConvertData(nil,NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        
        completionHandlerForConvertData(parsedResult, nil)
        
    }
    
    //downloads Images asynchronously
    func downloadImageTask(_ imagePath: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) {
        
        let url = HTTPClient.imageURLFromParameters(imagePath: imagePath)
        
        //print("image URL:",url.description)
        
        session.dataTask(with: url) { (responseData, response,error) -> Void in
            
            guard error == nil else {
                
                let userInfo  = [NSLocalizedDescriptionKey : "There was an error with image download: \(String(describing: error))"]
                completionHandlerForImage(nil,NSError(domain: "downloadImage", code: 1, userInfo: userInfo))
                return
            }
            
            if let data = responseData {
                
                completionHandlerForImage(data, nil)
            }
            }.resume()
    }
    
    /* create a movie URL from parameters
     - Parameter parameters: to make query of URL
     - Parameter withPathExtension: this is the method of URL
     - Return    URL: to movie data from server
     */
    class func movieURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = urlConstants.API_SCHEME
        components.host = urlConstants.API_HOST
        components.path = urlConstants.API_PATH + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    /* create a Image download URL from parameters
     - Parameter imagePath: Image Name as path
     - Return    URL: to download image from server
     */
    //https://image.tmdb.org/t/p/w185\(imagePath)
    class func imageURLFromParameters(imagePath:String) -> URL {
        
        var components = URLComponents()
        components.scheme = urlConstants.API_SCHEME
        components.host = urlConstants.IMAGE_API_HOST
        components.path = urlConstants.IMAGE_API_PATH + urlConstants.POSTER_SIZE + imagePath
        
        return components.url!
    }
}
