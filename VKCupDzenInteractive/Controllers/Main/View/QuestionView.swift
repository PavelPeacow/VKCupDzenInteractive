//
//  QuestionView.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import UIKit

final class QuestionView: UIView {
    
    lazy var question: UILabel = {
        let question = UILabel()
        question.translatesAutoresizingMaskIntoConstraints = false
        return question
    }()
    
    lazy var questionPercent: UILabel = {
        let questionPersent = UILabel()
        questionPersent.isHidden = true
        questionPersent.translatesAutoresizingMaskIntoConstraints = false
        return questionPersent
    }()
    
    lazy var rightMark: UIImageView = {
        let rightMark = UIImageView()
        rightMark.isHidden = true
        rightMark.translatesAutoresizingMaskIntoConstraints = false
        return rightMark
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rightMark, questionPercent])
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .orange
        layer.cornerRadius = 15
        
        addSubview(stackView)
        addSubview(question)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension QuestionView {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            question.centerYAnchor.constraint(equalTo: centerYAnchor),
            question.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
