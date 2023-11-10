//
//  CoreDataFeedStoreTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 10/11/23.
//

import XCTest
import MyEssentialFeed



class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    
    func test_retrieve_deliversOnEmptyOnEmptyCache() {
        
        let sut = makeSUT()
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        
        let sut = makeSUT()
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        
    }
    
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        
    }
    
    
    func test_insert_deliversNoErrorsOnEmptyCache() {
        
    }
    
    
    func test_insert_deliversNoErrorsOnNonEmptyCache() {
        
    }
    
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        
    }
    
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        
    }
    
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        
    }
    
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        
    }
    
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        
    }
    
    
    func test_storeSideEffects_runSerially() {
        
    }
    
    
    
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore {
        
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        /// The null device discards all data directed to it while reporting that write operations succeeded.
        /// By using a file URL of /dev/null for the persistent store, the Core Data stack will not save SQLite artifacts to disk, doing the work in memory. This means that this option is faster when running tests, as opposed to performing I/O and actually writing/reading from disk. Moreover, when operating in-memory, you prevent cross test side-effects since this process doesn’t create any artifacts.
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    
}
