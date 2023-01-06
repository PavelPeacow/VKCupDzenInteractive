//
//  QuestionsViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    let questionModel = ["один", "два", "три", "четыре"]
    let rightQuestionIndex = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createQuestions()
        stackViewContent.addArrangedSubview(resetBtn)
        
        view.backgroundColor = . systemBackground
        view.addSubview(stackViewContent)
        
        setConstraints()
    }
    
    private func createQuestions() {
        
        for questText in questionModel {
            let question = QuestionView()
            question.question.text = questText
            
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
        
        if let tappedQuestionIndex = filterQuestions.firstIndex(of: tappedQuestion) {

            if tappedQuestionIndex == rightQuestionIndex {
                animateScale(element: tappedQuestion, with: 1.2)
                tappedQuestion.rightMark.isHidden = false
                tappedQuestion.questionPersent.isHidden = false
                tappedQuestion.backgroundColor = .systemGreen
            } else {
                animateWrongTapQuestion(element: tappedQuestion)
                tappedQuestion.questionPersent.isHidden = false
                tappedQuestion.backgroundColor = .systemRed
            }
            
            let otherQuestions = stackViewContent.arrangedSubviews.filter( {$0.isKind(of: QuestionView.self) })
            otherQuestions.forEach {
                let question = $0 as! QuestionView
                question.questionPersent.isHidden = false
                question.isUserInteractionEnabled = false
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
        }
    }
    
}

extension QuestionsViewController {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            stackViewContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackViewContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            stackViewContent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
        ])
    }
    
}
