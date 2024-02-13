//
//  FeedImageViewModel.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 12/01/24.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?

    public var hasLocation: Bool {
        return location != nil
    }
}
