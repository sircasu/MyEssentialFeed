//
//  RemoteImageCommentsLoader.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 09/02/24.
//

import Foundation

public final class RemoteImageCommentsLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<[ImageComment], Swift.Error>
    
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
  
                completion(RemoteImageCommentsLoader.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
            
        }
    }
    
    
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try ImageCommentsMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }

}

                            
