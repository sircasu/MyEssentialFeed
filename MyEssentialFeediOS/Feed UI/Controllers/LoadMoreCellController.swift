//
//  LoadMoreCellController.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 19/02/24.
//

import UIKit
import MyEssentialFeed


public class LoadMoreCellController: NSObject, UITableViewDataSource {
    
    private let cell = LoadMoreCell()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell
    }
}



extension LoadMoreCellController: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: MyEssentialFeed.ResourceErrorViewModel) {
        cell.message = viewModel.message
    }
    
    
    public func display(_ viewModel: MyEssentialFeed.ResourceLoadingViewModel) {
        cell.isLoading = viewModel.isLoading
    }
    
}
