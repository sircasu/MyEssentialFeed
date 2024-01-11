//
//  FeedErrorViewModel.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 11/01/24.
//

import Foundation

struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
