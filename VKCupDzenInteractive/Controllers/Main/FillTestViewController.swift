//
//  FillTestViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 05.01.2023.
//

import UIKit

class FillTestViewController: UIViewController {

    var words = ["1", "lol", "mothermothermothermother", "2", "mothermother", "lol", "mother", "lol", "mother", "lol", "mother",]
    var text = "Put string ___ in here ___ fucker, Fcuk you the ___ epta Fcuk you the ___ epta"
    var textAnswers = ["lol", "1", "lol", "1"]
    
    var textFormated: [String] = []
    var labels: [UIView] = []
    var answersLabels: [UITextField] = []

    lazy var checkBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Check", for: .normal)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 15
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapCheckBtn), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setText()
        
        view.addSubview(checkBtn)
        view.backgroundColor = .systemBackground
                
        setConstraints()
    }
    
    private func setText() {
        textFormated = text.components(separatedBy: " ")

        for text in textFormated {
           
            if text == "___" {
                let labelTextField = UITextField()
                labelTextField.text = text
                labelTextField.font = .systemFont(ofSize: 18)
                labelTextField.backgroundColor = .gray
                labelTextField.layer.cornerRadius = 5
                labelTextField.textAlignment = .center
                labelTextField.delegate = self
                labelTextField.clipsToBounds = true
                labelTextField.addTarget(self, action: #selector(didChangeTextInTextField(_:)), for: .editingChanged)
               
                answersLabels.append(labelTextField)
                labels.append(labelTextField)
                view.addSubview(labelTextField)
            } else {
                let label = UILabel()
                label.isUserInteractionEnabled = true
                label.text = text
                label.font = .systemFont(ofSize: 18)
                labels.append(label)
                view.addSubview(label)
            }
            
        }
        
        validateLayout()
        validateLayout()
    }
    
    private func validateLayout() {
        let spacing: CGFloat = 3
        
        var x: CGFloat = 0
        var y: CGFloat = 90
        var previousLabel: UIView?
        
        for label in labels {
            
            x = previousLabel?.frame.maxX ?? x
            
            let size = label.sizeThatFits(CGSize(width: 40, height: 10))
            
            if x + label.frame.width > view.bounds.width {
                x = 0
                y += 30
                previousLabel = nil
            }
            
            if let label = label as? UILabel {
                
            
                label.frame = CGRect(x: x + spacing, y: y, width: size.width, height: size.height)
            } else if let field = label as? UITextField {
                if answersLabels.contains(field) {
                    if x + label.frame.width > view.bounds.width {
                        x = 0
                        y += 30
                        previousLabel = nil
                    }
                    
                    field.frame = CGRect(x: x + spacing, y: y, width: size.width + 10, height: size.height)
                }
            }
            
            previousLabel = label
        }
    }
    
    @objc private func didTapCheckBtn() {
        for (index, label) in answersLabels.enumerated() {
            let text = label.text
            
            if textAnswers[index] == text {
                label.backgroundColor = .green
            } else {
                label.backgroundColor = .red
            }
        }
    }
    
    func animateLabelChange(label: UILabel) {
        label.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        UIView.animate(withDuration: 0.25) {
            label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @objc func didChangeTextInTextField(_ sender: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.validateLayout()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension FillTestViewController: UITextFieldDelegate {
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "___" { textField.text = "" }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" { textField.text = "___" }
        UIView.animate(withDuration: 0.25) {
            self.validateLayout()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.25) {
            self.validateLayout()
        }
        return true
    }
    
}


//MARK: BURGER KING GOVNO

extension FillTestViewController {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            checkBtn.topAnchor.constraint(equalTo: labels.last!.bottomAnchor, constant: 15),
            checkBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkBtn.heightAnchor.constraint(equalToConstant: 30),
            checkBtn.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
}
