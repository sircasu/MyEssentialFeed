//
//  RemoteFeedLoaderTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 06/10/23.
//

import XCTest
@testable import MyEssentialFeed



class RemoteFeedLoader {
    
    let url: URL
    let client: HTTPClient
    
    init (url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: self.url)
    }
}




protocol HTTPClient {

    func get(from url: URL)
}


class HTTPClientSpy: HTTPClient {
    
    func get(from url: URL) {
        requestedURL = url
    }
    
    var requestedURL: URL?
}





final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    
    
    func test_load_requestDataFromURL() {
        
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
}
