//
//  NullStore.swift
//  EssentialApp
//
//  Created by Matteo Casu on 23/02/24.
//

import Foundation
import MyEssentialFeed

class NullStore {

    func deleteCachedFeed() throws {}
   
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {}
    
    func retrieve() throws -> CachedFeed? { .none }
    
    
    
}


extension NullStore: FeedStore & FeedImageDataStore {
    
    func insert(_ data: Data, for url: URL) throws {}
    
    func retrieve(dataForURL url: URL) throws -> Data? { .none }
    
}
