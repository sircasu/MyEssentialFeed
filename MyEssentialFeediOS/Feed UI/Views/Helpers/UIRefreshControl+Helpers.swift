//
//  UIRefreshControl+Helpers.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 11/01/24.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
