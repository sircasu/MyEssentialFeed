//
//  FeedEndpointTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 17/02/24.
//

import XCTest
import MyEssentialFeed

class FeedEndpointTests: XCTestCase {
    

    
    func test_feed_enpointURL() {
    

        let baseURL = URL(string: "https://base-url.com")!
        
        let received = FeedEndpoint.get().url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path")
        XCTAssertEqual(received.query, "limit=10", "query")
        
        
    }
    
        
    func test_feed_enpointURLAfterGivenImage() {
    
        let image = uniqueImage()
        let baseURL = URL(string: "https://base-url.com")!
        
        let received = FeedEndpoint.get(after: image).url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path")
        XCTAssertEqual(received.query?.contains("limit=10"), true, "limit query param")
        XCTAssertEqual(received.query?.contains("after_id=\(image.id)"), true, "after_id query param")
    }
    
    
}
