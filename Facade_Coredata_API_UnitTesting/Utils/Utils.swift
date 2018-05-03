//
//  Utils.swift
//  careem_execise
//
//  Created by Waseem on 23/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//

import Foundation

extension Date {
    
    //Date formatter  Jan 01, 2018
    static func getFormattedDate(dateString:String) -> String{
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatterGet.date(from:dateString)
        return dateFormatter.string(from: date!)
    }
}

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

struct ErrorMessage {
    
    static func getReadableErrorMessage(_ code:Int) -> String {
        
        let errorMessage:String
        
        switch code {
        case NSURLErrorNotConnectedToInternet:
            errorMessage = "Please connect to Internet"
        case NSURLErrorNetworkConnectionLost:
            errorMessage = "Network connection lost"
        case ErrorCodeConstants.unauthorizedCode:
            errorMessage = "Authentication error"
        case ErrorCodeConstants.serverNotFoundCode:
            errorMessage = "Operation not implemented"
        case ErrorCodeConstants.internalServerErrorCode:
            errorMessage = "Movie request error. Internal Server error"
            
        default:
            errorMessage = "There is error in response"
        }
        return errorMessage
    }
}

//MARK: Manages to check the unique and save suggestion to userdefaults
func manageSearchSuggestions(searchString:String) {
    
    let suggestions = LibraryAPI.shared.getSuggestions()!
    
    if !(suggestions.contains(where:{$0.searchKeyword == searchString})){
        
        if suggestions.count > literalContants.maxLimit {
            
            //delete suggestion record from db
            LibraryAPI.shared.deleteSuggestion()
        }
        
        //save searchkey/suggestion to Coredata
        LibraryAPI.shared.saveSuggestion(searchString)
    }
}
