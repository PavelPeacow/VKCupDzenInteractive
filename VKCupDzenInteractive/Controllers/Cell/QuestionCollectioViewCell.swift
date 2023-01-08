//
//  QuestionCollectioViewCell.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import UIKit

class QuestionCollectioViewCell: UICollectionViewCell {
    
    static let identifier = "QuestionsViewController"
    
    private var questionModel = [QuestionAnswer]()
    private var rightQuestionIndex = 0
    private var didCreateQuestions = false
    
    lazy var stackViewContent: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [questionCount, questionDescription])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var questionCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var questionDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var resetBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Reset", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .label
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(didTapResetBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 15
        contentView.addSubview(stackViewContent)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(question: Question, count: Int) {
        questionDescription.text = question.question
        questionModel = question.answers
        rightQuestionIndex = question.rightAnswerIndex
        questionCount.text = "\(question.id)/\(count)"
        
        if !didCreateQuestions {
            createQuestions()
        }
        didCreateQuestions = true
        
        stackViewContent.addArrangedSubview(resetBtn)
    }
    
    private func createQuestions() {
        for question in questionModel {
            let questionView = QuestionView()
            
            questionView.question.text = question.answerName
            questionView.questionPercent.text = question.validatePercentToString()
            
            let gesutre = UITapGestureRecognizer(target: self, action: #selector(didTapQuestion(_:)))
            questionView.addGestureRecognizer(gesutre)
            
            questionView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                questionView.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            stackViewContent.addArrangedSubview(questionView)
        }
    }
        
    private func setAnswerFocus(answer: QuestionView, isRightAnswer: Bool) {
        isRightAnswer ? answer.animateScale(with: 1.2) : answer.animateWrongAnswer()
        
        answer.rightMark.isHidden = false
        answer.questionPercent.isHidden = false
        answer.isUserInteractionEnabled = false
        
        let image = createAnswerImage(isRightAnswer: isRightAnswer)
        
        answer.rightMark.image = image
        answer.backgroundColor = isRightAnswer ? .systemGreen : .systemRed
    }
    
    private func setOtherAnswers(tappedAnswer: QuestionView, rightAnswer: QuestionView) {
        let otherQuestions = stackViewContent.arrangedSubviews.filter { $0.isKind(of: QuestionView.self) && $0 != tappedAnswer && $0 != rightAnswer }
        otherQuestions.forEach {
            let question = $0 as! QuestionView
            question.questionPercent.isHidden = false
            question.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2) {
                question.alpha = 0.5
            }
        }
    }
    
    private func createAnswerImage(isRightAnswer: Bool) -> UIImage {
        let systemName = isRightAnswer ? "checkmark" : "xmark"
        let rightAnsmwerImage = UIImage(systemName: systemName)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return rightAnsmwerImage!
    }

}

private extension QuestionCollectioViewCell {
    
    @objc func didTapQuestion(_ sender: UITapGestureRecognizer) {
        guard let tappedQuestion = sender.view as? QuestionView else { return }
        
        createTapticFeedback(with: .medium)
        
        let rightAnswer = stackViewContent.arrangedSubviews.filter {$0.isKind(of: QuestionView.self)} [rightQuestionIndex] as! QuestionView
       
        if rightAnswer == tappedQuestion {
            setAnswerFocus(answer: tappedQuestion, isRightAnswer: true)
        } else {
            setAnswerFocus(answer: tappedQuestion, isRightAnswer: false)
            setAnswerFocus(answer: rightAnswer, isRightAnswer: true)
        }
        
        setOtherAnswers(tappedAnswer: tappedQuestion, rightAnswer: rightAnswer)
    }
    
    @objc func didTapResetBtn(_ sender: UIButton) {
        sender.animateScale(with: 0.95)
        
        let questions = stackViewContent.arrangedSubviews.filter( {$0.isKind(of: QuestionView.self) })
        questions.forEach {
            let question = $0 as! QuestionView
            question.questionPercent.isHidden = true
            question.rightMark.isHidden = true
            question.isUserInteractionEnabled = true
            question.backgroundColor = .orange
            question.alpha = 1
        }
    }
}

private extension QuestionCollectioViewCell {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            stackViewContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackViewContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackViewContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackViewContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
}
