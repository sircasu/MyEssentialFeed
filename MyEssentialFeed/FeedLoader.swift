//
//  FeedLoader.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 05/10/23.
//

import Foundation


enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
