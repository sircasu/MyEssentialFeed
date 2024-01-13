//
//  HTTPClient.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 09/10/23.
//

import Foundation


public protocol HTTPClientTask {
    func cancel()
}

//public enum HTTPClientResult {
//    case success(Data, HTTPURLResponse)
//    case failure(Error)
//}
// refactoring to use swift result type `Result<Success, Failure> where Failure : Error`
//public typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>




public protocol HTTPClient {
    
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
