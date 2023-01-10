//
//  CompareViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 08.01.2023.
//

import UIKit

final class CompareViewController: UIViewController {
    
    //MARK: Properties
    
    private var right = ["один", "два", "три", "четыре"]
    private var left = ["1", "2", "3", "4"]
    
    private var answers = [UILabel:UILabel]()
    
    private var rightAnswers: Dictionary<String,String> = ["1":"один", "2":"два", "3":"три", "4":"четыре"]
    
    private var lineShape = CAShapeLayer()
    private var combinedPath = CGMutablePath()
    
    //MARK: View
    
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
        
        view.backgroundColor = .systemBackground
        view.layer.addSublayer(lineShape)
        view.addSubview(leftStackView)
        view.addSubview(rightStackView)
        view.addSubview(btnsStackView)
        
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
        let label = UILabel()
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
                
                addAnswer(firstLabel: tappedView, secondLabel: secondLabel)
                
                addLine(startPoint: startPoint, endPoint: secondPoint)
                createAnimation()
                return
            }
            
            createAnimation()
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
    
    private func createAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.5
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        view.layer.addSublayer(lineShape)
        lineShape.add(animation, forKey: nil)
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
        
}

//MARK: Target function

private extension CompareViewController {
    
    @objc func didTapCheckBtn(_ sender: UIButton) {
        sender.animateScale(with: 0.95)
        
        for (key, value) in answers {
            guard let keyText = key.text else { return }
            
            if rightAnswers[keyText] == value.text {
                key.backgroundColor = .orange
                key.animateScale(with: 1.2)
                
                value.backgroundColor = .orange
                value.animateScale(with: 1.2)
            } else {
                key.backgroundColor = .red
                key.animateWrongAnswer()
                
                value.backgroundColor = .red
                value.animateWrongAnswer()
            }
        }
    }
    
    @objc func didTapResetBtn(_ sender: UIButton) {
        sender.animateScale(with: 0.95)
        lineShape.path = nil
        combinedPath = CGMutablePath()
        
        answers.forEach { (key: UILabel, value: UILabel) in
            key.backgroundColor = .clear
            value.backgroundColor = .clear
        }
        answers.removeAll()
    }
    
}

//MARK: Constraints

private extension CompareViewController {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            leftStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            rightStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            rightStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            btnsStackView.topAnchor.constraint(equalTo: leftStackView.bottomAnchor, constant: 15),
            btnsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
    }
    
}
