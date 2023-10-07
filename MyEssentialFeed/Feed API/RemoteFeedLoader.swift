//
//  RemoteFeedLoader.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 06/10/23.
//

import Foundation


public protocol HTTPClient {

    func get(from url: URL, completion: @escaping (Error) -> Void)
}

public final class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init (url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Error) -> Void = { _ in } ) {
        client.get(from: self.url) { error in
            
            completion(.connectivity)
            
        }
    }
}

