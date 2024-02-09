//
//  RemoteLoader.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 09/02/24.
//

import Foundation

public final class RemoteLoader: FeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = FeedLoader.Result
    
    public init (url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: self.url) { [weak self] result in
            
            // check if exist a reference of self, if not doesn't do anything (avoid memory leak)
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
  
                completion(RemoteLoader.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
            
        }
    }
    
    
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(Error.invalidData)
        }
    }

}

                      
