//
//  LoadFeedFromCacheUseCaseTest.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 30/10/23.
//

import XCTest
import MyEssentialFeed

class LoadFeedFromCacheUseCaseTest: XCTestCase {
    
    func test_doesNotMessageStoreUponCreation() {
        
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    
    // MARK: - Helpers
    
    private func makeSut(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
            
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    

}
