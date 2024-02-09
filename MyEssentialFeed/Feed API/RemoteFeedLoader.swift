//
//  RemoteFeedLoader.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 06/10/23.
//

import Foundation


public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
           
