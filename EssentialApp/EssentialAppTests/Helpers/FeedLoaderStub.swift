//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Matteo Casu on 23/01/24.
//

import MyEssentialFeed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
