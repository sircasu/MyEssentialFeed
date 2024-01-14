//
//  LocalFeedImageDataLoaderTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 14/01/24.
//

import XCTest

final class LocalFeedImageDataLoader {
    
    init(store: Any) {}
}

final class LocalFeedImageDataLoaderTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedStoreSpyo) {
        let store = FeedStoreSpyo()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private class FeedStoreSpyo {
        let receivedMessages = [Any]()
    }
}
