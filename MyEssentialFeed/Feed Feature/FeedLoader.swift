//
//  FeedLoader.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 05/10/23.
//

import Foundation

//
//public enum LoadFeedResult {
//    case success([FeedImage])
//    case failure(Error)
//}
// refactoring to use swift result type `Result<Success, Failure> where Failure : Error`

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
