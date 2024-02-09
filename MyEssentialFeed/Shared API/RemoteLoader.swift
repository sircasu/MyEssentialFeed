//
//  RemoteLoader.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 09/02/24.
//

import Foundation

public final class RemoteLoader<Resource> {
    
    private let url: URL
    private let client: HTTPClient
    private let mapper: Mapper
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<Resource, Swift.Error>
    public typealias Mapper = (Data, HTTPURLResponse) throws -> Resource

    
    public init (url: URL, client: HTTPClient, mapper: @escaping Mapper) {
        self.url = url
        self.client = client
        self.mapper = mapper
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: self.url) { [weak self] result in
            
            // check if exist a reference of self, if not doesn't do anything (avoid memory leak)
//            guard self != nil else { return }
            
            guard let self = self else { return }
            
            switch result {
            case let .success((data, response)):
  
                completion(self.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
            
        }
    }
    
    
    
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try mapper(data, response)
            return .success(items)
        } catch {
            return .failure(Error.invalidData)
        }
    }

}

                      
