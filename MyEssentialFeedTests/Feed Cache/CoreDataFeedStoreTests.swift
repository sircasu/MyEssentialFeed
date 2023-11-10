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
    
    public func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore {
        
        let sut = CoreDataFeedStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    
}
