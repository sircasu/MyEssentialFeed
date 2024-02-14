//
//  ImageCommentCellController.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 14/02/24.
//

import UIKit
import MyEssentialFeed

public class ImageCommentCellController: NSObject, UITableViewDataSource {
    
    private let model: ImageCommentViewModel
    
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
    

    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.usernameLabel.text = model.username
        cell.dataLabel.text = model.date
        return cell
    }
    
    
}
