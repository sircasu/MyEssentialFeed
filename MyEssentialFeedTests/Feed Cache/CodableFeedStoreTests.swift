//
//  CodableFeedStoreTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 02/11/23.
//

import XCTest
import MyEssentialFeed


class CodableFeedStoreTests: XCTestCase, FailableFeedStoreSpec {
    
    override func setUp() {
        super.setUp()

        setupEmptyStoreState()
    }
    

    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    

    
    func test_retrieve_deliversOnEmptyOnEmptyCache() {
        
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }    
    
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        
        //given block
        let sut = makeSUT()
        
        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    }
       
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        
        
        let sut = makeSUT()
        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }
    
    
    func test_retrieve_deliversFailureOnRetrievealError() {
        
        // given
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        // when
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        // then
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)

        expect(sut, toRetrieveTwice: .failure(anyNSError()))
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
    
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")
        let sut = makeSUT(storeURL: invalidStoreURL)
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        let insertionError = insert((feed, timestamp), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }
    
    
    func test_insert_hasNoSideEffectsOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")
        let sut = makeSUT(storeURL: invalidStoreURL)
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        
        let sut = makeSUT()
        
        assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
            let sut = makeSUT()
            
            assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
        }
    
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        
        let sut = makeSUT()

        assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }
    
    
    func test_delete_deliversErrorOnDeletionError() {
        
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
    }
    
    func test_delete_hasNoSideEffectsOnDeletionError() {
        
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)
        
        deleteCache(from: sut)
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        assertThatSideEffectsRunSerially(on: sut)
    }
    
    
    // - Mark: Helpers
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let sut =  CodableFeedStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    
    private func  undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    

    private func testSpecificStoreURL() -> URL {
        
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
