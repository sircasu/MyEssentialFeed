//
//  CoreDataFeedStore+FeedImageDataStore.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 16/01/24.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {

    public func insert(_ data: Data, for url: URL) throws {
        
        try performSync { context in
            
            Result {

                try ManagedFeedImage.first(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            }
        }
    }
    
    public func retrieve(dataForUrl url: URL) throws -> Data? {

        try performSync { context in
            
            Result {
                try ManagedFeedImage.data(with: url, in: context)
            }
        }
    }

}
