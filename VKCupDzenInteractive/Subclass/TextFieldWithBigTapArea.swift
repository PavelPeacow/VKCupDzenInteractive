//
//  TextFieldWithBigTapArea.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 13.01.2023.
//

import UIKit

final class LargeTapAreaTextfield: UITextField {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newBounds = CGRect(x: bounds.origin.x - 15, y: bounds.origin.y - 15, width: bounds.size.width + 25, height: bounds.size.height + 25)
        return newBounds.contains(point)
    }
    
}
