//
//  NullStore.swift
//  EssentialApp
//
//  Created by Matteo Casu on 23/02/24.
//

import Foundation
import MyEssentialFeed

class NullStore {
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        completion(.success(()))
    }
    
    func insert(_ feed: [MyEssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        completion(.success(()))
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(.none))

    }
    
    
}


extension NullStore: FeedStore & FeedImageDataStore {
    
    func insert(_ data: Data, for url: URL) throws {}
    
    func retrieve(dataForURL url: URL) throws -> Data? { .none }
    
}
