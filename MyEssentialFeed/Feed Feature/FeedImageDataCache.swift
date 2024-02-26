//
//  FeedImageDataCache.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 24/01/24.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
