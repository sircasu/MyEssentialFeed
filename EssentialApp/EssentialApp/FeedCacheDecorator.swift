//
//  FeedCacheDecorator.swift
//  EssentialApp
//
//  Created by Matteo Casu on 24/01/24.
//

import MyEssentialFeed


public final class FeedLoaderCacheDecorator: FeedLoader {
    
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            
//            if let feed = try? result.get() {
//                self?.cache.save(feed) { _ in }
//            }
//            completion(result)
            completion(result.map { feed in
                
                self?.cache.save(feed) { _ in }
                return feed
            })
        }
    }
    
}
