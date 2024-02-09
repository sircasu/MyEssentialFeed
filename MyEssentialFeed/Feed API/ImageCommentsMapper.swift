//
//  ImageCommentsMapper.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 09/02/24.
//

import Foundation



final class ImageCommentsMapper {
    
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
    
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        
        guard isOk(response), let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }

        return root.items
    }
    
    
    private static func isOk(_ response: HTTPURLResponse) -> Bool {
        
        let acceptedStatusCode = 200...299
        return acceptedStatusCode.contains(response.statusCode)
    }
}
