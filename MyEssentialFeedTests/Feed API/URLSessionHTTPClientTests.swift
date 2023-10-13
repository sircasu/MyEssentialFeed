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
    
    
    struct UnexpectedValueRepresentation: Error {}
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {

        session.dataTask(with: url) { _, _, error in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UnexpectedValueRepresentation()))
            }
        }.resume()
    }
}
// end production

class URLSessionHTTPClientTests: XCTestCase {
    
    
    override class func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequest()
    }
    
    
    override class func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequest()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        

        let url = anyURL()
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            
            exp.fulfill()
        }
        
        makeSUT().get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    func test_getFromURL_failsOnRequestError() {
                
        
        let requestError = NSError(domain: "any error", code: 1)
        let receivedError = resultForError(data: nil, response: nil, error: requestError) as? NSError

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError?.domain, requestError.domain)
        XCTAssertEqual(receivedError?.code, requestError.code)
    }
    
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
                
        let anyData = Data("any data".utf8)
        let anyError = NSError(domain: "any error", code: 0)
        let nonHTTPURLResponse = URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let anyHTTPURLResponse = HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)

        XCTAssertNotNil(resultForError(data: nil, response: nil, error: nil) as? NSError)
        XCTAssertNotNil(resultForError(data: nil, response: nonHTTPURLResponse, error: nil) as? NSError)
        XCTAssertNotNil(resultForError(data: nil, response: anyHTTPURLResponse, error: nil) as? NSError)
        XCTAssertNotNil(resultForError(data: anyData, response: nil, error: nil) as? NSError)
        XCTAssertNotNil(resultForError(data: anyData, response: nil, error: anyError) as? NSError)
        XCTAssertNotNil(resultForError(data: nil, response: nonHTTPURLResponse, error: anyError) as? NSError)
        XCTAssertNotNil(resultForError(data: nil, response: anyHTTPURLResponse, error: anyError) as? NSError)
        XCTAssertNotNil(resultForError(data: anyData, response: nonHTTPURLResponse, error: anyError) as? NSError)
        XCTAssertNotNil(resultForError(data: anyData, response: anyHTTPURLResponse, error: anyError) as? NSError)
        XCTAssertNotNil(resultForError(data: anyData, response: nonHTTPURLResponse, error: nil) as? NSError)
    }
    
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    
    private func resultForError(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        
        URLProtocolStub.stub(data: data, response: response, error: error)
             
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedError: Error?
        sut.get(from: anyURL()) { result in
            
            switch result {
            case let .failure(error):
                receivedError = error
                break
            default:
                XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
    
    
    private func anyURL() -> URL {
        let url = URL(string: "http://any-url.com")!
        return url
    }
    
    
    private class URLProtocolStub: URLProtocol { // URLProtocol is a class, so we are subclassing
        
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        
        static func stub(data: Data?, response: URLResponse?, error: Error? = nil) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        
        static func startInterceptingRequest() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequest() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        
        /* we intercept the request and we have the responsability to commplete the request */
        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            return true
        }
        
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        /* the framework has accepted tht we are going to handle this request, and can invoke us to say that it is time to invoke the url */
        override func startLoading() {
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        
        override func stopLoading() { }
        
    }
    
}
