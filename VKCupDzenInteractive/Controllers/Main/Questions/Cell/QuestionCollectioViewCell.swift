//
//  QuestionCollectioViewCell.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import UIKit

private enum AnswerType {
    case right
    case wrong
    
    var answerImageSystemName: String {
        switch self {
        case .right:
            return "checkmark"
        case .wrong:
            return "xmark"
        }
    }
    
    var answerBackgroundColor: UIColor {
        switch self {
        case .right:
            return .systemGreen
        case .wrong:
            return .systemRed
        }
    }
    
}

final class QuestionCollectioViewCell: UICollectionViewCell {
    
    //MARK: Properties
    
    static let identifier = "QuestionsViewController"
    
    private var questionModel = [QuestionAnswer]()
    private var rightQuestionIndex = 0
    private var didCreateQuestions = false
    
    //MARK: View
    
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
    
    lazy var resetBtn: MainButton = {
        let btn = MainButton(title: "Сбросить")
        btn.addTarget(self, action: #selector(didTapResetBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    //MARK: Lifecycle
    
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
    
    //MARK: Configure
    
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
    
    //MARK: Set questions layout
    
    private func createQuestions() {
        for question in questionModel {
            let questionView = QuestionView()
            
            questionView.question.text = question.answerName
            questionView.questionPercent.text = question.validatePercentToString()
            
            let gesutre = UITapGestureRecognizer(target: self, action: #selector(didTapQuestion(_:)))
            questionView.addGestureRecognizer(gesutre)
                        
            stackViewContent.addArrangedSubview(questionView)
        }
    }
    
    //MARK: Questions logic
    
    private func setAnswerFocus(answer: QuestionView, answerType: AnswerType) {
        if answerType == .right {
            answer.animateScale(with: 1.2)
        } else {
            answer.animateWrongAnswer()
        }
        
        answer.rightMark.isHidden = false
        answer.questionPercent.isHidden = false
        answer.stackView.isHidden = false
        answer.isUserInteractionEnabled = false
        
        let image = createAnswerImage(answerType: answerType)
        
        answer.rightMark.image = image
        answer.backgroundColor = answerType.answerBackgroundColor
    }
    
    private func setOtherAnswers(tappedAnswer: QuestionView, rightAnswer: QuestionView) {
        let otherQuestions = stackViewContent.arrangedSubviews.filter { $0.isKind(of: QuestionView.self) && $0 != tappedAnswer && $0 != rightAnswer }
        otherQuestions.forEach {
            let question = $0 as! QuestionView
            question.stackView.isHidden = false
            question.questionPercent.isHidden = false
            question.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2) {
                question.alpha = 0.5
            }
        }
    }
    
    private func createAnswerImage(answerType: AnswerType) -> UIImage {
        let systemName = answerType.answerImageSystemName
        let rightAnsmwerImage = UIImage(systemName: systemName)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return rightAnsmwerImage!
    }
    
    private func resetQuestions() {
        let questions = stackViewContent.arrangedSubviews.filter( {$0.isKind(of: QuestionView.self) })
        questions.forEach {
            let question = $0 as! QuestionView
            question.questionPercent.isHidden = true
            question.rightMark.isHidden = true
            question.stackView.isHidden = true
            question.isUserInteractionEnabled = true
            question.backgroundColor = .orange
            question.alpha = 1
        }
    }
    
    private func animateLayoutChanges() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.layoutIfNeeded()
        }
        let collectionView = self.superview as! UICollectionView
        collectionView.performBatchUpdates({
            collectionView.layoutIfNeeded()
        })
    }
    
}

//MARK: Target function

private extension QuestionCollectioViewCell {
    
    @objc func didTapQuestion(_ sender: UITapGestureRecognizer) {
        guard let tappedQuestion = sender.view as? QuestionView else { return }
        
        createTapticFeedback(with: .medium)
        
        let rightAnswer = stackViewContent.arrangedSubviews.filter {$0.isKind(of: QuestionView.self)} [rightQuestionIndex] as! QuestionView
       
        if rightAnswer == tappedQuestion {
            setAnswerFocus(answer: tappedQuestion, answerType: .right)
        } else {
            setAnswerFocus(answer: tappedQuestion, answerType: .wrong)
            setAnswerFocus(answer: rightAnswer, answerType: .right)
        }
        
        setOtherAnswers(tappedAnswer: tappedQuestion, rightAnswer: rightAnswer)
        
        animateLayoutChanges()
    }
    
    @objc func didTapResetBtn(_ sender: UIButton) {
        sender.animateScale(with: 0.95)
        resetQuestions()
        animateLayoutChanges()
    }
}

//MARK: Constraints

private extension QuestionCollectioViewCell {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            stackViewContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackViewContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackViewContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackViewContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            resetBtn.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
}
