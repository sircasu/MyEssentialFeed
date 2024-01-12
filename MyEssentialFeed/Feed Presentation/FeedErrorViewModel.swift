//
//  FeedErrorViewModel.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 12/01/24.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
