//
//  RemoteFeedLoader.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 06/10/23.
//

import Foundation


public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}


public protocol HTTPClient {

    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    
    public init (url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: self.url) { result in
            
            switch result {
            case let .success(data, response):
                if let items = try? FeedItemsMapper.map(data, response) {
                    completion(.success(items))
                } else {
                    completion(.failure(.invalidData))
                }

            case .failure:
                completion(.failure(.connectivity))
            }
            
        }
    }
}



private class FeedItemsMapper {
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        
        guard response.statusCode == 200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return try JSONDecoder().decode(Root.self, from: data).items.map { $0.item }
    }
}

private struct Root: Decodable {
    let items: [Item]
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
