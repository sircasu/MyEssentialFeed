//
//  FeedImageDataStore.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 15/01/24.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
