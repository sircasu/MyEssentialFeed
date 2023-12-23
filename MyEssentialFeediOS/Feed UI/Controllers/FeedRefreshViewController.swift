//
//  FeedRefreshViewController.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 13/12/23.
//

import UIKit


/// Controller to manage the FeedLoader state and update the UIResfreshControl.
/// It needs to inherits form NSObject because our view target action is based on old Objective-C APIs
public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    
    
    public lazy var view: UIRefreshControl = loadView()
    
    private let loadFeed: () -> Void
    
    init(loadFeed: @escaping() -> Void) {
        self.loadFeed = loadFeed
    }
    
    
    @objc func refresh() {
        
        loadFeed()
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
