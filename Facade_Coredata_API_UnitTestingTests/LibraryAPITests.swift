//
//  LibraryAPITests.swift
//  careem_execiseTests
//
//  Created by Waseem on 25/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import careem_execise

class LibraryAPITests: XCTestCase {
    
   
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
          OHHTTPStubs.removeAllStubs()
    }
    
    func testGetMoviesForSearchString() {
        
        //stub creation to mock server response
        stub(condition: isPath("https://api.themoviedb.org/3/search/movie?page=1&query=Mary&api_key=2696829a81b1b5827d515ff121700838")) { request in
            let stubPath = OHPathForFile("response.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        
        let promise = expectation(description: "getMovie Resuest with search string")
        let movies = LibraryAPI.shared.getMoviesForSearchString("Mary") { (movies, error) in
        
            promise.fulfill()
            
            XCTAssertNotNil(movies, "TEST CASE FAILED: movies is nil");
            XCTAssertNil(error, "TEST CASE FAILED: There is error in response");
            
        }
        
        waitForExpectations(timeout: urlConstants.TIME_OUT, handler: nil)

        XCTAssertNotNil(movies, "TEST CASE FAILED: movies is nil");
    }
    
    func testDownloadImage() {
        
         let promise = expectation(description: "download image from server")
        LibraryAPI.shared.downloadImage("io8EuvEII26szS1PJMhh51P2UXG.jpg") { (data, error) in
            
            promise.fulfill()
            XCTAssertNotNil(data, "TEST CASE FAILED: image data is nil");
            XCTAssertNil(error, "TEST CASE FAILED: There is error in getting image data");
        }
        
        waitForExpectations(timeout: urlConstants.TIME_OUT, handler: nil)
    
    }
    
    //This test all persitance CRUD interface
    func testPersistenceMethods() {
        
         LibraryAPI.shared.saveSuggestion("Cow boy")
        
         let suggestions = LibraryAPI.shared.getSuggestions()
        XCTAssertNotNil(suggestions, "TEST CASE FAILED: suggestion is nil. Saving failed");
        
        LibraryAPI.shared.deleteSuggestion()
        let suggestions1 = LibraryAPI.shared.getSuggestions()
        
        if let suggestions = suggestions, let suggestions1 = suggestions1 {
          
        XCTAssert((suggestions.count > suggestions1.count), "TEST CASE FAILED: suggestion is nil. delete sucessful");
     
        }
        
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
