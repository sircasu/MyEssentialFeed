//
//  XCTestCase+FeedStoreSpecs.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 07/11/23.
//

import XCTest
import MyEssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    
    
    @discardableResult
    func insert(cache: (feed: [LocalFeedImage], timestamp: Date) ,to sut: FeedStore) -> Error? {
        
        let exp = expectation(description: "Wait for cache retrieval")
        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return insertionError
    }
    
    
    @discardableResult
    func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedFeed { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        return deletionError
    }
    
    
    
    func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrieveCacheFeedResult, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { retrievedResult in
            
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break
                
            case let (.found(expectedFeed, expectedTimestamp), .found(retrievedFeed, retrievedTimestamp)):
                XCTAssertEqual(retrievedFeed, expectedFeed, file: file, line: line)
                XCTAssertEqual(retrievedTimestamp, expectedTimestamp, file: file, line: line)
                
                break;
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead")
            }
            
            exp.fulfill()
        }


        wait(for: [exp], timeout: 1.0)
    }
    
    
    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrieveCacheFeedResult, file: StaticString = #file, line: UInt = #line) {
        
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
}
