//
//  CodableFeedStoreTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 02/11/23.
//

import XCTest
import MyEssentialFeed

class CodableFeedStore {
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        
        completion(.empty)
    }

}
class CodableFeedStoreTests: XCTestCase {
    
    func test_retrieve_deliversOnEmptyOnEmptyCache() {
        
        
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { result in
            
            switch result {
            case .empty:
                break;
                
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
