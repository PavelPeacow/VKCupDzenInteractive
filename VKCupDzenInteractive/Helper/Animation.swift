//
//  Animation.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import UIKit

extension UIView {
    
    func animateScale(with scale: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func animateWrongTapQuestion() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        self.layer.add(animation, forKey: "shake")
    }
    
}


