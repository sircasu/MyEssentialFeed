//
//  UIButton+TestHelpers.swift
//  MyEssentialFeediOSTests
//
//  Created by Matteo Casu on 13/12/23.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
