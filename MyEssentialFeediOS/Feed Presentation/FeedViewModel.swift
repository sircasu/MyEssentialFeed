//
//  FeedViewModel.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 16/12/23.
//

import Foundation
import MyEssentialFeed

final class FeedViewModel {
    
    typealias Observer<T> = (T) -> Void

    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    
    
    // closures to send back data
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?
    

    
    
    func loadFeed() {
        
        onLoadingStateChange?(true)

        feedLoader.load { [weak self] result in
            
            if let feed = try? result.get() {
                
                self?.onFeedLoad?(feed)
            }
                
            self?.onLoadingStateChange?(false)
        }

    }
}
