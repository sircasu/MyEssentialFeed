//
//  URLSessionHTTPClientTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 11/10/23.
//

import XCTest
import MyEssentialFeed

// production
class URLSessionHTTPClient {
    
    private let session: URLSession
    
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
// end production

class URLSessionHTTPClientTests: XCTestCase {
    
    
    func test_getFromURL_failsOnRequestError() {
        
        URLProtocolStub.startInterceptingRequest()
        
        let url = URL(string: "http://any-url.com")!
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(url: url, data: nil, response: nil, error: error)
        
        let sut = URLSessionHTTPClient()
        
        let exp = expectation(description: "Wait for completion")
        
        sut.get(from: url) { result in
            
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertNotNil(receivedError)
                XCTAssertEqual(receivedError.domain, error.domain)
                XCTAssertEqual(receivedError.code, error.code)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        URLProtocolStub.stopInterceptingRequest()
        
    }
    
    // MARK: - Helpers
    
    private class URLProtocolStub: URLProtocol { // URLProtocol is a class, so we are subclassing
        
        private static var stubs = [URL: Stub]()
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        
        static func stub(url: URL, data: Data?, response: URLResponse?, error: Error? = nil) {
            stubs[url] = Stub(data: data, response: response, error: error)
        }
        
        
        static func startInterceptingRequest() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequest() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stubs = [:]
        }
        
        
        /* we intercept the request and we have the responsability to commplete the request */
        override class func canInit(with request: URLRequest) -> Bool {
            
            guard let url = request.url else {
                return false
            }
            
            return URLProtocolStub.stubs[url] != nil
        }
        
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        /* the framework has accepted tht we are going to handle this request, and can invoke us to say that it is time to invoke the url */
        override func startLoading() {
            
            guard let url = request.url, let stub = URLProtocolStub.stubs[url] else {
                return
            }
            
            
            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            
            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            
            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        
        override func stopLoading() { }
        
    }
    
}
