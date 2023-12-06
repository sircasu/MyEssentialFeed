//
//  FeedViewController.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 06/12/23.
//

import UIKit
import MyEssentialFeed

final public class FeedViewController: UITableViewController {
    
    private var loader: FeedLoader?
    
    // convenience initializer becase we don't need any custom initialization (in this way we don't need to implement UIViewController's required initializer)
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }

    }
}
