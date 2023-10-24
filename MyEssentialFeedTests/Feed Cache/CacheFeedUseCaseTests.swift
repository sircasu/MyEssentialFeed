//
//  CacheFeedUseCaseTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 24/10/23.
//

import XCTest
import MyEssentialFeed

class LocalFeedLoader {
    
    private let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed()
    }
}

class FeedStore {
    
    var deleteCachedFeedCallCount = 0
    
    
    func deleteCachedFeed() {
        deleteCachedFeedCallCount += 1
    }
}


final class CacheFeedUseCaseTests: XCTestCase {

    func test_doesNotDeleteCacheUponCreation() {
        
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    
    func test_save_requestCacheDeletion() {
        
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        let items = [uniqueItem()]
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    
    // MARK: - Helpers
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "a desc", location: "a loc", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
}