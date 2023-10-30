//
//  FeedItemsMapper.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 09/10/23.
//

import Foundation


internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}

internal final class FeedItemsMapper {
    
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }


    public struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    
    private static var OK_200: Int { return 200 }

    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        

        return root.items
    }
}
