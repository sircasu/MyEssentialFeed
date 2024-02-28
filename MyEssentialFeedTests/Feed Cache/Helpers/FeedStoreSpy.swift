//
//  FeedStoreSpy.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 30/10/23.
//

import Foundation
import MyEssentialFeed


class FeedStoreSpy: FeedStore {

    
    
    
//    typealias InsertionCompletion = (Error?) -> Void
    
    enum ReceivedMessage: Equatable {
        case deleteCacheFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    

    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedFeed?, Error>?
    
    
    //
    func deleteCachedFeed() throws {
        
        receivedMessages.append(.deleteCacheFeed)
        try deletionResult?.get()
    }
    
    
    func completeDeletion(with error: Error) {
    
        deletionResult = .failure(error)
    }
    
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        
        deletionResult = .success(())
    }
    
    //
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        receivedMessages.append(.insert(feed, timestamp))
        try insertionResult?.get()
    }
    
    
    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }
    
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
    
    
    //
    func retrieve() throws -> CachedFeed? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache() {
        retrievalResult = .success(.none)
    }
    
    func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date) {
        retrievalResult = .success(CachedFeed(feed: feed, timestamp: timestamp))
    }
    
    
 }
