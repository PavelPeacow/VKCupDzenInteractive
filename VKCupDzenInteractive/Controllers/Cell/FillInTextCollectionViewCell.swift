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
    
    lazy var checkBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Check", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.backgroundColor = .label
        btn.layer.cornerRadius = 15
        btn.translatesAutoresizingMaskIntoConstraints = false
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
        validateLayout()
    }
    
    private func validateLayout() {
        let spacing: CGFloat = 3
        
        var x: CGFloat = 10
        var y: CGFloat = 10
        var previousLabel: UIView?
        
        for label in labels {
            
            if let previousLabel = previousLabel {
                x = previousLabel.frame.maxX
            }
            
            let size = label.sizeThatFits(CGSize(width: 40, height: 10))
            
            if x + label.frame.width > contentView.bounds.width - 10 {
                x = 10
                y += 30
                previousLabel = nil
            }
            
            if label is UILabel {
                label.frame = CGRect(x: x + spacing, y: y, width: size.width, height: size.height)
            }
            
            if label is UITextField {
                label.frame = CGRect(x: x + spacing, y: y, width: size.width + 10, height: size.height)
            }
            
            previousLabel = label
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
    
}

//MARK: Target function

private extension FillInTextCollectionViewCell {
    
    @objc func didTapCheckBtn(_ sender: UIButton) {
        sender.animateScale(with: 0.95)
        for (index, label) in answersLabels.enumerated() {
            let text = label.text
            
            createTapticFeedback(with: .medium)
            
            if rightAnswers[index] == text {
                label.backgroundColor = .green
                label.animateScale(with: 1.2)
            } else {
                label.animateWrongAnswer()
                label.backgroundColor = .red
            }
        }
    }
    
    @objc func didChangeTextInTextField(_ sender: UITextField) {
        sender.animateScale(with: 1.2)
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.validateLayout()
            self?.validateLayout()
            self?.invalidateIntrinsicContentSize()
            self?.layoutIfNeeded()
        }
        
    }
    
}

//MARK: UITextFieldDelegate

extension FillInTextCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "___" { textField.text = "" }
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.validateLayout()
            self?.validateLayout()
            self?.invalidateIntrinsicContentSize()
            self?.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" { textField.text = "___" }
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.validateLayout()
            self?.validateLayout()
            self?.invalidateIntrinsicContentSize()
            self?.layoutIfNeeded()
        }
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
            checkBtn.widthAnchor.constraint(equalToConstant: 100),
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
