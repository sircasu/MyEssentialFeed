//
//  FeedLoaderPresentationAdapter.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 03/01/24.
//

import MyEssentialFeed
import MyEssentialFeediOS

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {

    
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        
        presenter?.didStartLoadingFeed()
        
        feedLoader.load { [weak self] result in
            
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
        
    }
}