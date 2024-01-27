//
//  UIButton+TestHelpers.swift
//  MyEssentialFeediOSTests
//
//  Created by Matteo Casu on 13/12/23.
//

import UIKit

extension UIButton {
    
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
