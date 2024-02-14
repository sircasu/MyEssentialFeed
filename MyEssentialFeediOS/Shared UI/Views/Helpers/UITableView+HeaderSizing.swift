//
//  UITableView+HeaderSizing.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 06/02/24.
//

import UIKit

extension UITableView {
    
    func sizeTableHeaderToFit() {
        
        guard let header = tableHeaderView else { return }
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let needFrameUpdate = header.frame.height != size.height
        if needFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
        
    }
}
