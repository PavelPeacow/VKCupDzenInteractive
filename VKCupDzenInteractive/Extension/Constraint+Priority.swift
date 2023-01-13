//
//  Constraint+Priority.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 13.01.2023.
//

import UIKit

extension NSLayoutConstraint {
    func withPriority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(priority)
        return self
    }
}
