//
//  Paginated.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 20/02/24.
//

import Foundation

public struct Paginated<Item> {
//    public typealias LoadMoreCompletion = (Result<Paginated<Item>, Error>) -> Void
    public typealias LoadMoreCompletion = (Result<Self, Error>) -> Void
    
    public let items: [Item]
    let loadMore: ((@escaping LoadMoreCompletion) -> Void)?
    
    public init(items: [Item], loadMore: ((LoadMoreCompletion) -> Void)? = nil) {
        self.items = items
        self.loadMore = loadMore
    }
}
