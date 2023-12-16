//
//  FeedRefreshViewController.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 13/12/23.
//

import UIKit


/// Controller to manage the FeedLoader state and update the UIResfreshControl.
/// It needs to inherits form NSObject because our view target action is based on old Objective-C APIs
public final class FeedRefreshViewController: NSObject {
    
//    public lazy var view: UIRefreshControl = {
////        let view = UIRefreshControl()
////        return bind(view)
//        return bind(UIRefreshControl())
//    }()
    
    // OR
    
    public lazy var view: UIRefreshControl = binded(UIRefreshControl())
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    
    @objc func refresh() {
        
        viewModel.loadFeed()
    }
    
    
    // we can return the in this bind function, so we can chain the view creation with the binding
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        
        viewModel.onChange = { [weak self] viewModel in
            
            // the onChange closure is the binding logic between the ViewModel and the view
            if viewModel.isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
            
        }
        
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
