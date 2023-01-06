//
//  Animation.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import UIKit

extension UIViewController {
    
    func animateScale(element: UIView, with scale: CGFloat) {
        element.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(withDuration: 0.25) {
            element.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func animateWrongTapQuestion(element: UIView) {
           let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
           animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
           animation.duration = 0.6
           animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
            element.layer.add(animation, forKey: "shake")
       }
    
}


