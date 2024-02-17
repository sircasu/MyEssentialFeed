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
        
        let sut = makeSUT()
        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    }
    
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        
        let sut = makeSUT()
        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }
    
    
    func test_insert_deliversNoErrorsOnEmptyCache() {
        
        let sut = makeSUT()
        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    
    func test_insert_deliversNoErrorsOnNonEmptyCache() {
        
        let sut = makeSUT()
        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        
        let sut = makeSUT()
        assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
    }
    
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        
        let sut = makeSUT()
        assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
       
        let sut = makeSUT()
        assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        
        let sut = makeSUT()
        assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        
        let sut = makeSUT()
        assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }
    
    
    func test_storeSideEffects_runSerially() {
        
        let sut = makeSUT()
        assertThatSideEffectsRunSerially(on: sut)
    }
    
    
    
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> FeedStore {
        
        /// The null device discards all data directed to it while reporting that write operations succeeded.
        /// By using a file URL of /dev/null for the persistent store, the Core Data stack will not save SQLite artifacts to disk, doing the work in memory. This means that this option is faster when running tests, as opposed to performing I/O and actually writing/reading from disk. Moreover, when operating in-memory, you prevent cross test side-effects since this process doesn’t create any artifacts.
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    
}
