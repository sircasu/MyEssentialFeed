//
//  FeedEndpointTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 17/02/24.
//

import XCTest
import MyEssentialFeed

class FeedEndpointTests: XCTestCase {
    

    
    func test_imageComments_enpointURL() {
    

        let baseURL = URL(string: "https://base-url.com")!
        
        let received = FeedEndpoint.get.url(baseURL: baseURL)
        let expected = URL(string: "https://base-url.com/v1/feed")!
        
        XCTAssertEqual(received, expected)
        
    }
}
