//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 12/11/23.
//

import XCTest
import MyEssentialFeed

extension FailableDeleteFeedStoreSpecs where Self: XCTestCase {
   
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
