//
//  ImageCommentsMapper.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 09/02/24.
//

import Foundation



internal final class ImageCommentsMapper {
    
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
    
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }

        return root.items
    }
}
