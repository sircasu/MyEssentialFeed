//
//  FeedStore.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 26/10/23.
//

import Foundation


//public enum RetrieveCachedFeedResult {
//    case empty
//    case found(feed: [LocalFeedImage], timestamp: Date)
//    case failure(Error)
//}

//public typealias RetrieveCachedFeedResult = Result <CachedFeed, Error>


//public enum CachedFeed {
//    case empty
//    case found(feed: [LocalFeedImage], timestamp: Date)
//}


// refactoring to use standard optional type to represent the concept to havirn or not the CachedFeed
//public struct CachedFeed {
//    public let feed: [LocalFeedImage]
//    public let timestamp: Date
//    
//    public init(feed: [LocalFeedImage], timestamp: Date) {
//        self.feed = feed
//        self.timestamp = timestamp
//    }
//}

// refactoring to typealias (with a tuple)
public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)



public protocol FeedStore {
    
    func deleteCachedFeed() throws
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    func retrieve() throws -> CachedFeed?
    
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result <CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void

    @available(*, deprecated)
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    @available(*, deprecated)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    
    @available(*, deprecated)
    func retrieve(completion: @escaping RetrievalCompletion)
}

public extension FeedStore {
    func deleteCachedFeed() throws {
        let group = DispatchGroup()
        group.enter()
        var result: DeletionResult!
        deleteCachedFeed {
            result = $0
            group.leave()
        }
        group.wait()
        return try result.get()
    }

    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        let group = DispatchGroup()
        group.enter()
        var result: InsertionResult!
        insert(feed, timestamp: timestamp) {
            result = $0
            group.leave()
        }
        group.wait()
        return try result.get()
    }

    func retrieve() throws -> CachedFeed? {
        let group = DispatchGroup()
        group.enter()
        var result: RetrievalResult!
        retrieve {
            result = $0
            group.leave()
        }
        group.wait()
        return try result.get()
    }

    func deleteCachedFeed(completion: @escaping DeletionCompletion) {}
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {}
    func retrieve(completion: @escaping RetrievalCompletion) {}
}
