//
//  RemoteFeedLoaderTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 06/10/23.
//

import XCTest
@testable import MyEssentialFeed



class RemoteFeedLoader {
    
}



class HTTPClient {
    
    var requestedURL: URL?
}



final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
