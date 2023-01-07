//
//  QuestionsViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import UIKit

class QuestionsUICollectioViewCell: UICollectionViewCell {
    
    static let identifier = "QuestionsViewController"
    
    var questionModel = [QuestionAnswer]()
    var rightQuestionIndex = 0
    var isCreatedQuestions = false
    
    lazy var stackViewContent: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [questionAllNumber, questionNumber])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var questionAllNumber: UILabel = {
        let label = UILabel()
        label.text = "Вопрос 1/1"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var questionNumber: UILabel = {
        let label = UILabel()
        label.text = "Первый вопрос"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var resetBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Reset", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .gray
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(didTapResetBtn), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        

        contentView.backgroundColor = .red
        contentView.addSubview(stackViewContent)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(question: Question, count: Int) {
        questionNumber.text = question.question
        questionModel = question.answers
        rightQuestionIndex = question.rightAnswerIndex
        questionAllNumber.text = "\(question.id)/\(count)"
        
        if !isCreatedQuestions {
            createQuestions()
        }
        isCreatedQuestions = true
        
        stackViewContent.addArrangedSubview(resetBtn)
    }
    
     func createQuestions() {
        
        for (questText) in questionModel {
            let question = QuestionView()
            
            question.question.text = questText.answerName
            question.questionPersent.text = questText.validatePercentToString()
            
            let gesutre = UITapGestureRecognizer(target: self, action: #selector(didTapQuestion(_:)))
            question.addGestureRecognizer(gesutre)
            
            question.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                question.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            stackViewContent.addArrangedSubview(question)
        }
        
    }
    
    @objc private func didTapQuestion(_ sender: UITapGestureRecognizer) {
        guard let tappedQuestion = sender.view as? QuestionView else { return }
        
        let filterQuestions = stackViewContent.arrangedSubviews.filter({$0.isKind(of: QuestionView.self)})
        let rightAnswer = filterQuestions[rightQuestionIndex] as! QuestionView
        
        if let tappedQuestionIndex = filterQuestions.firstIndex(of: tappedQuestion) {

            if tappedQuestionIndex == rightQuestionIndex {
                tappedQuestion.animateScale(with: 1.2)
                tappedQuestion.rightMark.isHidden = false
                tappedQuestion.questionPersent.isHidden = false
                tappedQuestion.backgroundColor = .systemGreen
                tappedQuestion.isUserInteractionEnabled = false
            } else {
                tappedQuestion.animateWrongTapQuestion()
                tappedQuestion.rightMark.isHidden = false
                tappedQuestion.rightMark.image = UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                tappedQuestion.questionPersent.isHidden = false
                tappedQuestion.backgroundColor = .systemRed
                tappedQuestion.isUserInteractionEnabled = false
                
                rightAnswer.backgroundColor = .systemGreen
                rightAnswer.animateScale(with: 1.2)
                rightAnswer.rightMark.isHidden = false
                rightAnswer.questionPersent.isHidden = false
                rightAnswer.isUserInteractionEnabled = false
            }
            
            let otherQuestions = stackViewContent.arrangedSubviews.filter( {$0.isKind(of: QuestionView.self) }).filter( {$0 != tappedQuestion && $0 != rightAnswer })
            otherQuestions.forEach {
                let question = $0 as! QuestionView
                question.questionPersent.isHidden = false
                question.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.2) {
                    question.alpha = 0.8
                }
            }
        }
    }
    
    @objc private func didTapResetBtn() {
        let questions = stackViewContent.arrangedSubviews.filter( {$0.isKind(of: QuestionView.self) })
        questions.forEach {
            let question = $0 as! QuestionView
            question.questionPersent.isHidden = true
            question.rightMark.isHidden = true
            question.isUserInteractionEnabled = true
            question.backgroundColor = .lightGray
            question.alpha = 1
        }
    }
    
}

extension QuestionsUICollectioViewCell {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            stackViewContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackViewContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackViewContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackViewContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
