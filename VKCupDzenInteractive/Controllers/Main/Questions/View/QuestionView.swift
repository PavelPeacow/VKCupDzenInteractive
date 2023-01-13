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
        question.numberOfLines = 0
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
    
    lazy var stackViewMain: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [question, stackView])
        stackView.spacing = 5
        stackView.isHidden = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rightMark, questionPercent])
        stackView.spacing = 5
        stackView.isHidden = true
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .orange
        layer.cornerRadius = 15
        
        addSubview(stackViewMain)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension QuestionView {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: stackViewMain.bottomAnchor, constant: 15),
            
            stackViewMain.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackViewMain.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackViewMain.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            stackView.widthAnchor.constraint(equalToConstant: 85),
            rightMark.heightAnchor.constraint(equalToConstant: 20),
            rightMark.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
}
