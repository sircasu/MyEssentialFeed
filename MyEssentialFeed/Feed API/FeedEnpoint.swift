//
//  FeedEnpoint.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 17/02/24.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
