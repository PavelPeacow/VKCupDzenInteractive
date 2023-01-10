//
//  CompareViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 08.01.2023.
//

import UIKit

final class CompareViewController: UIViewController {
    
    //MARK: Properties
    
    private var right = [String]()
    private var left = [String]()
    
    private var answers = [UILabel:UILabel]()
    
    private var rightAnswers = [String:String]()
    
    private var lineShape = CAShapeLayer()
    private var combinedPath = CGMutablePath()
    
    //MARK: View
    
    lazy var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var btnsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkBtn, resetBtn])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var checkBtn: MainButton = {
        let btn = MainButton(title: "Проверить")
        btn.addTarget(self, action: #selector(didTapCheckBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var resetBtn: MainButton = {
        let btn = MainButton(title: "Сбросить")
        btn.addTarget(self, action: #selector(didTapResetBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMockData()
        
        view.backgroundColor = .systemBackground
        view.layer.addSublayer(lineShape)
        view.addSubview(background)
        background.addSubview(leftStackView)
        background.addSubview(rightStackView)
        background.addSubview(btnsStackView)
        
        setLeftStackViewContent()
        setRightStackViewContent()
        
        setConstraints()
    }
    
    //MARK: Set layout
    
    private func setLeftStackViewContent() {
        for text in left {
            let label = createPossibleAnswerLabel(text: text)
            leftStackView.addArrangedSubview(label)
            
        }
    }
    
    private func setRightStackViewContent() {
        for text in right {
            let label = createPossibleAnswerLabel(text: text)
            rightStackView.addArrangedSubview(label)
        }
    }
    
    private func createPossibleAnswerLabel(text: String?) -> UILabel {
        let padding = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        let label = PaddedLabel(with: padding)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.clipsToBounds = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        label.addGestureRecognizer(panGesture)
        
        label.text = text
        label.font = .systemFont(ofSize: 22)
        label.layer.borderColor = UIColor.orange.cgColor
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.textAlignment = .center
        return label
    }
    
    //MARK: Compare logic
                
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let tappedView = gesture.view as? UILabel else { return }
        let currentPanPoint = gesture.location(in: view)

        let startPoint = getStartPoint(of: tappedView)
        
        let linePath = UIBezierPath()
        
        switch gesture.state {
        case .began:
            createTapticFeedback(with: .medium)

        case .changed:
            
            linePath.move(to: startPoint)
            linePath.addLine(to: currentPanPoint)
            
            createStroke(line: linePath)
            
        case .ended:
            if let secondLabel = view.hitTest(currentPanPoint, with: .none) as? UILabel {
                let secondPoint = getStartPoint(of: secondLabel)
                
                lineShape.path = combinedPath
                
                if isLabelHasLine(label: secondLabel, secondLabel: tappedView) { return }
                if isAtSameStackView(firstView: tappedView, secondView: secondLabel) { return }
                
                createTapticFeedback(with: .heavy)
                
                addAnswer(firstLabel: tappedView, secondLabel: secondLabel)
                
                addLine(startPoint: startPoint, endPoint: secondPoint)
                view.createStrokeAnimation(in: lineShape)
                return
            }
            
            view.createStrokeAnimation(in: lineShape)
            lineShape.path = combinedPath
            
        default: break
        }
    }
    
    func createStroke(line: UIBezierPath) {
        lineShape.path = line.cgPath
        lineShape.strokeColor = UIColor.orange.cgColor
        lineShape.lineWidth = 2
    }
    
    private func getStartPoint(of view: UIView) -> CGPoint {
        guard let coordinates = view.superview?.convert(view.frame, to: self.view) else { return CGPoint(x: 0, y: 0) }

        if leftStackView.arrangedSubviews.contains(view) {
            return CGPoint(x: coordinates.maxX, y: coordinates.midY)
        }
        return CGPoint(x: coordinates.minX, y: coordinates.midY)
    }
    
    private func isAtSameStackView(firstView: UIView, secondView: UIView) -> Bool {
        guard let superview = firstView.superview as? UIStackView else { return true }

        if superview.arrangedSubviews.contains(secondView) {
            return true
        }
        return false
    }
        
    private func addLine(startPoint: CGPoint, endPoint: CGPoint) {
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        combinedPath.addPath(linePath.cgPath)
        lineShape.path = combinedPath
    }
    
    private func addAnswer(firstLabel: UILabel, secondLabel: UILabel) {
        if leftStackView.arrangedSubviews.contains(firstLabel) {
            answers[firstLabel] = secondLabel
        } else {
            answers[secondLabel] = firstLabel
        }
    }
    
    private func isLabelHasLine(label: UILabel, secondLabel: UILabel) -> Bool {
        if answers.contains(where: {$0.key == label || $0.value == label || $0.key == secondLabel || $0.value == secondLabel}) {
            return true
        }
        return false
    }
    
    //MARK: Answers set
    
    private func setRightAnswer(key: UILabel, value: UILabel) {
        key.backgroundColor = .green
        key.animateScale(with: 1.2)
        
        value.backgroundColor = .green
        value.animateScale(with: 1.2)
    }
    
    private func setWrongAnswer(key: UILabel, value: UILabel) {
        key.backgroundColor = .red
        key.animateWrongAnswer()
        
        value.backgroundColor = .red
        value.animateWrongAnswer()
    }
        
}

//MARK: Target function

private extension CompareViewController {
    
    @objc func didTapCheckBtn(_ sender: UIButton) {
        sender.animateScale(with: 0.95)
        createTapticFeedback(with: .medium)
        
        for (key, value) in answers {
            guard let keyText = key.text else { return }
            
            if rightAnswers[keyText] == value.text {
                setRightAnswer(key: key, value: value)
            } else {
                setWrongAnswer(key: key, value: value)
            }
        }
    }
    
    @objc func didTapResetBtn(_ sender: UIButton) {
        sender.animateScale(with: 0.95)
        createTapticFeedback(with: .medium)
        
        lineShape.path = nil
        combinedPath = CGMutablePath()
        
        answers.forEach { (key: UILabel, value: UILabel) in
            key.backgroundColor = .clear
            value.backgroundColor = .clear
        }
        answers.removeAll()
    }
    
}

//MARK: JsonMockData

extension CompareViewController {
    
    private func getMockData() {
        do {
            let result = try JsonMockDecoder().getMockData(with: .compare, type: Compare.self)
            left = result.leftColumn
            right = result.rightColumn
            rightAnswers = result.rightAnswers
        } catch {
            print(error)
        }
    }
    
}

//MARK: Constraints

private extension CompareViewController {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            background.bottomAnchor.constraint(equalTo: btnsStackView.bottomAnchor, constant: 5),
            
            leftStackView.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
            leftStackView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 5),
            
            rightStackView.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
            rightStackView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -5),
            
            btnsStackView.topAnchor.constraint(equalTo: leftStackView.bottomAnchor, constant: 15),
            btnsStackView.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            btnsStackView.widthAnchor.constraint(equalTo: background.widthAnchor, multiplier: 0.8),
        ])
    }
    
}
