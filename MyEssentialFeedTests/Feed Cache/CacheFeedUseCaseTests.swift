//
//  CacheFeedUseCaseTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 24/10/23.
//

import XCTest


class LocalFeedLoader {
    
    let store: FeedStore
    init(store: FeedStore) {
        self.store = store
    }
}

class FeedStore {
    
    var deleteCachedFeedCallCount = 0
}


final class CacheFeedUseCaseTests: XCTestCase {

    func test_doesNotDeleteCacheUponCreation() {
        
        let store = FeedStore()
        
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
