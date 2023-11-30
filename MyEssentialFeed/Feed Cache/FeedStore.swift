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
    typealias DeletionResult = Error?
    typealias DeletionCompletion = (Error?) -> Void
    
    typealias InsertionResult = Error?
    typealias InsertionCompletion = (Error?) -> Void
    
    typealias RetrievalResult = Result <CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}

