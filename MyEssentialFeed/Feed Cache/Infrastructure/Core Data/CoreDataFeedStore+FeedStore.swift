//
//  CoreDataFeedStore+FeedStore.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 16/01/24.
//

import CoreData


extension CoreDataFeedStore: FeedStore {
    
    public func retrieve() throws -> CachedFeed? {
        
        try performSync { context in
            
            Result(catching: {
                
                try ManagedCache.find(in: context).map {
                    return CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            })
        }
    }

    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        
        try performSync { context in
            
           Result {
                
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp

                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                
                try context.save()
            }
        }
    }
    

    public func deleteCachedFeed() throws {
        
        try performSync { context in
    
            Result {

                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            }
        }
    
    }
}
