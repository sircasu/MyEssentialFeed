//
//  FeedRefreshViewController.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 13/12/23.
//

import UIKit
import MyEssentialFeed

/// Controller to manage the FeedLoader state and update the UIResfreshControl.
/// It needs to inherits form NSObject because our view target action is based on old Objective-C APIs
public final class FeedRefreshViewController: NSObject {
    
    public lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    // closure to send back data
    var onRefresh: (([FeedImage]) -> Void)?
    
    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            
            self?.view.endRefreshing()
        }

    }
}
