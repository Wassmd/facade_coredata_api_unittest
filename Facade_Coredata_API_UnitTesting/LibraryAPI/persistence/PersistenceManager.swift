//
//  PersistenceManager.swift
//  careem_execise
//
//  Created by Waseem on 21/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PersistencyManager {
    
    //Used by all three below CRUD functions
    private let managedContext:NSManagedObjectContext = (CoreDataStack.shared.persistentContainer.viewContext)
    
    //saving data to database
    func saveDataToDB(searchKeyword: String) {
    
        let entity = NSEntityDescription.entity(forEntityName: "Suggestion",
                                       in: managedContext)!
        
        let sug = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        sug.setValue(searchKeyword, forKeyPath: "searchKeyword")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //get data from database
    func fetchDataFromDB() -> [Suggestion]? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Suggestion")
        var suggestionArray:[Suggestion]? = nil
        do {
            suggestionArray = try managedContext.fetch(fetchRequest) as? [Suggestion]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return suggestionArray?.reversed()
    }
    
    //delete older suggestion stored before ten new keywords
    func deleteDataFromDB() {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Suggestion")

        do {
            if let suggestionArray = try managedContext.fetch(fetchRequest) as? [Suggestion], suggestionArray.count > 0 {
                
                managedContext.delete(suggestionArray[0])
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
