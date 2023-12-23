//
//  FeedRefreshViewController.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 13/12/23.
//

import UIKit



protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}


public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    
    
    public lazy var view: UIRefreshControl = loadView()
    
    private let delegate: FeedRefreshViewControllerDelegate
    
    init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    
    @objc func refresh() {
        
        delegate.didRequestFeedRefresh()
    }
    
    
    func display(_ viewModel: FeedLoadingViewModel) {
        
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
           view.endRefreshing()
        }
    }
    
    
    // we can return the in this bind function, so we can chain the view creation with the binding
    private func loadView() -> UIRefreshControl {
    
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
