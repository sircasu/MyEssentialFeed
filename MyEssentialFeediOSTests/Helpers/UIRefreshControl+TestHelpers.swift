//
//  UIRefreshControl+TestHelpers.swift
//  MyEssentialFeediOSTests
//
//  Created by Matteo Casu on 13/12/23.
//

import UIKit

extension UIRefreshControl {
    
    func simulatePullToRefresh(){
        
        simulate(event: .valueChanged)
    }
}
