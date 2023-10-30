//
//  FeedLoader.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 05/10/23.
//

import Foundation


public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}


public protocol FeedLoader {
    
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
