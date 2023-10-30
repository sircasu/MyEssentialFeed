//
//  FeedItem.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 05/10/23.
//

import Foundation


public struct FeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
