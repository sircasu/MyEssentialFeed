//
//  FeedCache.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 23/01/24.
//

import Foundation

public protocol FeedCache {
    
    func save(_ feed: [FeedImage]) throws
}
