//
//  FeedStoreSpecs.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 07/11/23.
//

import Foundation

protocol FeedStoreSpecs {
    
    func test_retrieve_deliversOnEmptyOnEmptyCache()
    func test_retrieve_hasNoSideEffectsOnEmptyCache()
    func test_retrieve_deliversFoundValuesOnNonEmptyCache()
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache()

    func test_insert_deliversNoErrorsOnEmptyCache()
    func test_insert_deliversNoErrorsOnNonEmptyCache()
    func test_insert_overridesPreviouslyInsertedCacheValues()
    
    func test_delete_deliversNoErrorOnEmptyCache()
    func test_delete_hasNoSideEffectsOnEmptyCache()
    func test_delete_deliversNoErrorOnNonEmptyCache()
    func test_delete_emptiesPreviouslyInsertedCache()
    
    func test_storeSideEffects_runSerially()
}


protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    
    func test_retrieve_deliversFailureOnRetrievealError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}


protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNoSideEffectsOnInsertionError()
}


protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_deliversErrorOnDeletionError()
    func test_delete_hasNoSideEffectsOnDeletionError()
}


typealias FailableFeedStoreSpec = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs // composition of all available specs
