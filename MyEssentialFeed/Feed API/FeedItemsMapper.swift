//
//  FeedItemsMapper.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 09/10/23.
//

import Foundation




internal final class FeedItemsMapper {
    
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }


    public struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        
        var item: FeedImage {
            return FeedImage(id: id, description: description, location: location, url: image)
        }
    }
    
    
    private static var OK_200: Int { return 200 }

    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        

        return root.items
    }
}
