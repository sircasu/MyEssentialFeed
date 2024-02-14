//
//  FeedImageCellController.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 14/12/23.
//

import UIKit
import MyEssentialFeed

public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

/// The idea is to have a controller per cell
public final class FeedImageCellController: CellController, ResourceView, ResourceLoadingView, ResourceErrorView {
    
    public typealias ResourceViewModel = UIImage
    private let viewModel: FeedImageViewModel
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageCell?
    

    public init(viewModel: FeedImageViewModel, delegate: FeedImageCellControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.locationContainer.isHidden = !viewModel.hasLocation
        cell?.locationLabel.text = viewModel.location
        cell?.descriptionLabel.text = viewModel.description
        cell?.onRetry = { [weak self] in
            self?.delegate.didRequestImage()
        }
        cell?.onReuse = { [weak self] in
            self?.releaseCellForReuse()
        }
        delegate.didRequestImage()
        return cell!
    }
    
    public func preload() {
        delegate.didRequestImage()
    }

    public func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }

    
    
    public func display(_ viewModel: UIImage) {
        cell?.feedImageView.setImageAnimated(viewModel)
    }
    
    
    public func display(_ viewModel: MyEssentialFeed.ResourceLoadingViewModel) {
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: MyEssentialFeed.ResourceErrorViewModel) {
        cell?.feedImageRetryButton.isHidden = viewModel.message == nil
    }
    
    private func releaseCellForReuse() {
        cell?.onReuse = nil
        cell = nil
    }
}
