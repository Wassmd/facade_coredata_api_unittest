//
//  HTTPClientTests.swift
//  careem_execiseTests
//
//  Created by Waseem on 25/03/18.
//  Copyright © 2018 Waseem. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import careem_execise

class HTTPClientTests: XCTestCase {
    
    let httpClient = HTTPClient()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMovieURLFromParameters() {
        
        //Test by passing empty string
        let url = HTTPClient.movieURLFromParameters(["hi" : "bye" as AnyObject], withPathExtension: "")
        print(url)
        XCTAssertNotNil(url, "TEST CASE FAILED: Unable to form image url");
    }
    
    func testImageURLFromParameters() {
        
        let url = HTTPClient.imageURLFromParameters(imagePath: "")
        print(url)
        XCTAssertNotNil(url, "TEST CASE FAILED: Unable to form image url");
        
        let url1 = HTTPClient.imageURLFromParameters(imagePath: "/1.jp")
        print(url1)
        XCTAssertNotNil(url1, "TEST CASE FAILED: Unable to form image url");
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
}
