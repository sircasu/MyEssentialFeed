//
//  UITableView+Dequeuing.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 28/12/23.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
