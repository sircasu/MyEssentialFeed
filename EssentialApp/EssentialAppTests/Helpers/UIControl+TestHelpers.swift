//
//  UIControl+TestHelpers.swift
//  MyEssentialFeediOSTests
//
//  Created by Matteo Casu on 13/12/23.
//

import UIKit

extension UIControl {
    
    func simulate(event: UIControl.Event) {
        
        allTargets.forEach { target in
            
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}


