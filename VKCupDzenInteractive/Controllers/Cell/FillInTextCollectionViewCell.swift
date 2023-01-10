//
//  FillInTextCollectionViewCell.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 07.01.2023.
//

import UIKit

final class FillInTextCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    
    static let identifier = "FillInQuestionCollectionViewCell"
    
    private var text = ""
    private var rightAnswers = [String]()
    
    private var didSetText = false
    
    private var textFormated: [String] = []
    private var labels: [UIView] = []
    private var answersLabels: [UITextField] = []
    
    //MARK: View
    
    lazy var checkBtn: MainButton = {
        let btn = MainButton(title: "Проверить")
        btn.addTarget(self, action: #selector(didTapCheckBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    //MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(checkBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.validateLayout()
        }
    }
    
    //MARK: Configure
    
    func configure(fillInQuestion: FillInQuestion) {
        text = fillInQuestion.text
        rightAnswers = fillInQuestion.rightAnswers
        
        if !didSetText {
            setText()
            setConstraints()
        }
        didSetText = true
    }
    
    //MARK: Set text layout
    
    private func setText() {
        textFormated = text.components(separatedBy: " ")
        
        for text in textFormated {
            
            var element: UIView
            
            if text == "___" {
                element = createTextField(text: text)
                answersLabels.append(element as! UITextField)
            } else {
                element = createLabel(text: text)
            }
            labels.append(element)
            contentView.addSubview(element)
        }
        validateLayout()
    }
    
    private func validateLayout() {
        let spacing: CGFloat = 3
        
        var x: CGFloat = 10
        var y: CGFloat = 10
        var previousLabel: UIView?
        
        //set basic frames
        for label in labels {
            let width = label.intrinsicContentSize.width
            let height = label.intrinsicContentSize.height
            
            label.frame = CGRect(x: x + spacing, y: y, width: width, height: height)
        }
        
        for label in labels {
            
            if let previousLabel = previousLabel {
                x = previousLabel.frame.maxX
            }
            
            if x + label.frame.width > contentView.bounds.width - 10 {
                x = 10
                y += 30
            }
            
            let width = label.intrinsicContentSize.width
            let height = label.intrinsicContentSize.height
            
            if label is UILabel {
                label.frame = CGRect(x: x + spacing, y: y, width: width, height: height)
            }
            
            if label is UITextField {
                label.frame = CGRect(x: x + spacing, y: y, width: width + 10, height: height)
            }
            
            previousLabel = label
        }
        
    }
    
    private func animateLayoutChanges() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.validateLayout()
            self?.invalidateIntrinsicContentSize()
            self?.layoutIfNeeded()
        }
    }
    
    //MARK: Create UIElements
    
    private func createTextField(text: String) -> UITextField {
        let textField = UITextField()
        textField.text = text
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.font = .systemFont(ofSize: 18)
        textField.backgroundColor = .orange
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.clipsToBounds = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(didChangeTextInTextField(_:)), for: .editingChanged)
        return textField
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = text
        label.font = .systemFont(ofSize: 18)
        return label
    }
    
    //MARK: Logic
    
    private func checkAnswers() {
        for (index, label) in answersLabels.enumerated() {
            let text = label.text
            
            createTapticFeedback(with: .medium)
            
            if rightAnswers[index] == text {
                label.backgroundColor = .green
                label.animateScale(with: 1.2)
            } else {
                label.backgroundColor = .red
                label.animateWrongAnswer()
            }
        }
    }
    
}

//MARK: Target function

private extension FillInTextCollectionViewCell {
    
    @objc func didTapCheckBtn(_ sender: UIButton) {
        sender.animateScale(with: 0.95)
        checkAnswers()
    }
    
    @objc func didChangeTextInTextField(_ sender: UITextField) {
        sender.animateScale(with: 1.2)
        animateLayoutChanges()
    }
    
}

//MARK: UITextFieldDelegate

extension FillInTextCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "___" { textField.text = "" }
        animateLayoutChanges()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" { textField.text = "___" }
        animateLayoutChanges()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: Constraints

private extension FillInTextCollectionViewCell {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            checkBtn.topAnchor.constraint(equalTo: labels.last!.bottomAnchor, constant: 15).withPriority(999),
            checkBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).withPriority(999),
            checkBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            checkBtn.heightAnchor.constraint(equalToConstant: 30),
            checkBtn.widthAnchor.constraint(equalToConstant: 120),
        ])
    }
    
}

extension NSLayoutConstraint
{
    func withPriority(_ priority: Float) -> NSLayoutConstraint
    {
        self.priority = UILayoutPriority(priority)
        return self
    }
}
