//
//  FileManager.swift
//  careem_execise
//
//  Created by Waseem on 24/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//

import Foundation
import UIKit

private let documentsPath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
/**
 it created a folder in app document to cache images
 */
func createImageDirectory() {
    
    let imageDirPath = documentsPath.appendingPathComponent(literalContants.imageLocalPath)
    
    do {
        if (FileManager.default.fileExists(atPath: (imageDirPath.path))) {
            
            try  FileManager.default.removeItem(atPath: (imageDirPath.path))
        }
        try FileManager.default.createDirectory(atPath: (imageDirPath.path), withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
        NSLog("Unable to create directory \(error.debugDescription)")
    }
}


/**
 it saves a image in image folder in app document to cache
 - Paramter ImageData
 - Parameter ImageName
 */
func saveImageInLocalDir(_ imageData:Data, _ imageName:String) {
    
    let anImagePath = documentsPath.appendingPathComponent("\(literalContants.imageLocalPath)/\(imageName)")
    do {
        if (FileManager.default.fileExists(atPath: (anImagePath.path))) {
            
            try  FileManager.default.removeItem(atPath: (anImagePath.path))
        }
        
        try imageData.write(to: anImagePath)
        
    } catch let error as NSError {
        NSLog("Unable to create directory \(error.debugDescription)")
    }
}

/**
 it fetch a image in image folder in app document from cache
 
 - Parameter ImageName
 - Return  UIImage
 */
func fetchImageFromLocalDir(_ imageName:String) -> UIImage? {
    
    let anImagePath = documentsPath.appendingPathComponent("\(literalContants.imageLocalPath)/\(imageName)")
    
    var anImage:UIImage? = nil
    
    if (FileManager.default.fileExists(atPath: (anImagePath.path))) {
        
        anImage = UIImage(contentsOfFile: anImagePath.path)
    }
    
    return anImage;
}

/**
 
 It clears the cached images from Image folder
 */
func clearImageDir() {
    
    let imageDirPath = documentsPath.appendingPathComponent(literalContants.imageLocalPath)
    
    if(FileManager.default.fileExists(atPath: (imageDirPath.path))) {
        
        do{
            try FileManager.default.removeItem(atPath: (imageDirPath.path))
        }catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }
}
