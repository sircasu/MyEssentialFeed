//
//  FeedViewModel.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 16/12/23.
//

import Foundation
import MyEssentialFeed

final class FeedViewModel {
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    
    
    // closures to send back data
    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?
    
    
    private(set) var isLoading: Bool = false {
        didSet { onChange?(self) }
    }
    
    
    func loadFeed() {
        
        isLoading = true
        
        feedLoader.load { [weak self] result in
            
            if let feed = try? result.get() {
                
                self?.onFeedLoad?(feed)
            }
                
            self?.isLoading = false
        }

    }
}
