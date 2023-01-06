//
//  WordsCollectionViewCell.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 04.01.2023.
//

import UIKit

class WordsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "WordsCollectionViewCell"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
        layer.cornerRadius = 10
        
        contentView.addSubview(label)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(word: String) {
        label.text = word
    }
    
}

extension WordsCollectionViewCell {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
}
