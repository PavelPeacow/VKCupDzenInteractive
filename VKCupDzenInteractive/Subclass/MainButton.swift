//
//  MainButton.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 09.01.2023.
//

import UIKit

final class MainButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(.systemBackground, for: .normal)
        self.backgroundColor = .label
        self.layer.cornerRadius = 15
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
