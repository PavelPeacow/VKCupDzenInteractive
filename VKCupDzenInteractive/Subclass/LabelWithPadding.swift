//
//  LabelWithPadding.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 10.01.2023.
//

import UIKit

class PaddedLabel: UILabel {
    var padding: UIEdgeInsets!
    
    init(with padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) {
        super.init(frame: .zero)
        self.padding = padding
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        let width = superSize.width + padding.left + padding.right
        let heigth = superSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
