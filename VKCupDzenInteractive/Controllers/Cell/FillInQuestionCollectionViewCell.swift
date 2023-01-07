//
//  FillInQuestionCollectionViewCell.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 07.01.2023.
//

import UIKit

class FillInQuestionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FillInQuestionCollectionViewCell"
    
    var text = ""
    var rightAnswers = [String]()
    
    var didSetText = false
    
    var textFormated: [String] = []
    var labels: [UIView] = []
    var answersLabels: [UITextField] = []
    
    lazy var checkBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Check", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.backgroundColor = .label
        btn.layer.cornerRadius = 15
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapCheckBtn), for: .touchUpInside)
        return btn
    }()
    
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
    
    func configure(fillInQuestion: FillInQuestion) {
        text = fillInQuestion.text
        rightAnswers = fillInQuestion.rightAnswers
        
        if !didSetText {
            setText()
            setConstraints()
        }
        didSetText = true
    }
    
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
    
    private func createTextField(text: String) -> UITextField {
        let labelTextField = UITextField()
        labelTextField.text = text
        labelTextField.autocorrectionType = .no
        labelTextField.autocapitalizationType = .none
        labelTextField.font = .systemFont(ofSize: 18)
        labelTextField.backgroundColor = .orange
        labelTextField.layer.cornerRadius = 5
        labelTextField.textAlignment = .center
        labelTextField.clipsToBounds = true
        labelTextField.delegate = self
        labelTextField.addTarget(self, action: #selector(didChangeTextInTextField(_:)), for: .editingChanged)
        return labelTextField
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = text
        label.font = .systemFont(ofSize: 18)
        return label
    }
    
}

extension FillInQuestionCollectionViewCell {
    
    @objc private func didTapCheckBtn() {
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
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.validateLayout()
        }
        sender.animateScale(with: 1.2)
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.invalidateIntrinsicContentSize()
            self?.layoutIfNeeded()
        }
        
    }
    
}

//MARK: UITextField

extension FillInQuestionCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "___" { textField.text = "" }
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.validateLayout()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" { textField.text = "___" }
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.validateLayout()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


//MARK: BURGER KING GOVNO

extension FillInQuestionCollectionViewCell {
    
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
