//
//  FeedImageCellController.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 14/12/23.
//

import UIKit
import MyEssentialFeed

/// The idea is to have a ontroller per cell
final class FeedImageCellController {
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func view() -> UITableViewCell {
        
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (model.location == nil)
        cell.locationLabel.text = model.location
        cell.descriptionLabel.text = model.description
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.feedImageContainer.startShimmering()
        
        let loadImage = { [weak self, weak cell] in
            
            guard let self = self else { return }
            
            self.task = imageLoader.loadImageData(from: self.model.url) { [weak cell] result in
                
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell?.feedImageView.image = image
                cell?.feedImageRetryButton.isHidden = (image != nil)
                cell?.feedImageContainer.stopShimmering()
            }
        }
        
        cell.onRetry = loadImage
        loadImage()
        
        return cell
    }
    
    func preload() {
        task = imageLoader.loadImageData(from: model.url) { _ in }
    }
    
    /// To keep the same behavior of stopping the request, every time the controller is deinitialized,
    /// we cancel the running task
    deinit {
        task?.cancel()
    }
}
