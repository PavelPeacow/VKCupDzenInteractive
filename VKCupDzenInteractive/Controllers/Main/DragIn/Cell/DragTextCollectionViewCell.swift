//
//  DragTextCollectionViewCell.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 07.01.2023.
//

import UIKit

final class DragTextCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    
    static let identifier = "DragTextCollectionViewCell"
    
    private var possibleAnswers = [String]()
    private var text = ""
    private var rightAnswers =  [String]()
    
    private var textFormated: [String] = []
    private var labels: [UILabel] = []
    private var answersLabels: [UILabel] = []
    
    private var possibleAnswersLabels: [UILabel] = []
    
    private var didSetText = false
    
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
    
    //MARK: Configure
    
    func configure(fillInQuestion: FillInQuestion) {
        possibleAnswers = fillInQuestion.possibleAnswers
        text = fillInQuestion.text
        rightAnswers = fillInQuestion.rightAnswers
        
        if !didSetText {
            setText()
            setPossibleAnswersText()
            setConstraints()
        }
        didSetText = true
    }
    
    //MARK: Create text layout
    
    private func setText() {
        textFormated = text.components(separatedBy: " ")
        
        for text in textFormated {
            var label = createLabel(text: text)
            
            if label.text == "___" {
                label = createDropInLabel(text: text)
                answersLabels.append(label)
            }
            
            labels.append(label)
            contentView.addSubview(label)
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
            
            if x + label.frame.width > contentView.bounds.width - 15 {
                x = 10
                y += 30
            }
            
            let width = label.intrinsicContentSize.width
            let height = label.intrinsicContentSize.height
            
            label.frame = CGRect(x: x + spacing, y: y, width: width, height: height)
            
            if answersLabels.contains(label) {
                label.frame = CGRect(x: x + spacing, y: y, width: width + 10, height: height)
            }
            
            previousLabel = label
        }
        
    }
    
    //MARK: Create possible answers layout
    
    private func setPossibleAnswersText() {
        for text in possibleAnswers {
            let label = createPossibleAnswerLabel(text: text)
            possibleAnswersLabels.append(label)
            contentView.addSubview(label)
        }
        validatePossibleAnswersLayout()
    }
    
    private func validatePossibleAnswersLayout() {
        let spacing: CGFloat = 10
        
        var x: CGFloat = 15
        var y: CGFloat = labels.last!.frame.maxY + 30
        var previousLabel: UILabel?
        
        //set basic frames
        for label in possibleAnswersLabels {
            let width = label.intrinsicContentSize.width
            let height = label.intrinsicContentSize.height
            
            label.frame = CGRect(x: x + spacing, y: y, width: width, height: height)
        }
        
        for label in possibleAnswersLabels {
            
            if let previousLabel = previousLabel {
                x = previousLabel.frame.maxX
            }
            
            if x + label.frame.width > contentView.bounds.width - 45 {
                x = 15
                y += 30
            }
            
            let width = label.intrinsicContentSize.width
            let height = label.intrinsicContentSize.height
            
            label.frame = CGRect(x: x + spacing, y: y, width: width + 15, height: height + 5)
            
            previousLabel = label
        }
    }
    
    //MARK: Create UIElements
    
    private func createLabel(text: String) -> LargeTapAreaLabel {
        let label = LargeTapAreaLabel()
        label.isUserInteractionEnabled = false
        label.text = text
        label.font = .systemFont(ofSize: 18)
        return label
    }
    
    private func createDropInLabel(text: String) -> LargeTapAreaLabel {
        let label = createLabel(text: text)
        label.isUserInteractionEnabled = true
        let dropInteraction = UIDropInteraction(delegate: self)
        label.addInteraction(dropInteraction)
        label.backgroundColor = .orange
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }
    
    private func createPossibleAnswerLabel(text: String?, position: CGRect = .zero) -> LargeTapAreaLabel {
        let label = LargeTapAreaLabel()
        label.isUserInteractionEnabled = true
        label.frame = position
        
        let dragInteraction = UIDragInteraction(delegate: self)
        label.addInteraction(dragInteraction)
        
        label.text = text
        label.font = .systemFont(ofSize: 18)
        label.layer.borderColor = UIColor.orange.cgColor
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.textAlignment = .center
        return label
    }
    
    //MARK: Logic
    
    private func swapLabels(first: UILabel, second: UILabel, at index: Int) {
        let label = createPossibleAnswerLabel(text: second.text, position: second.frame)
        contentView.addSubview(label)
        
        possibleAnswersLabels.insert(label, at: index)
        
        second.text = first.text
    }
    
    private func animateLayoutChanges() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.validateLayout()
            self?.validatePossibleAnswersLayout()
            self?.layoutIfNeeded()
        }
        let collectionView = self.superview as! UICollectionView
        collectionView.performBatchUpdates({
            collectionView.layoutIfNeeded()
        })
    }
    
    private func checkAnswers() {
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
}

//MARK: Target function

private extension DragTextCollectionViewCell {
    
    @objc private func didTapCheckBtn(_ sender: UIButton) {
        sender.animateScale(with: 0.95)
        checkAnswers()
    }
    
}

//MARK: DragDelegate

extension DragTextCollectionViewCell: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let view = interaction.view as! UILabel
        let item = view.text!
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = view
        createTapticFeedback(with: .medium)
        return [dragItem]
    }
    
}

//MARK: DropDelegate

extension DragTextCollectionViewCell: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        //prevent drop from other cells
        if let label = session.items.first?.localObject as? UILabel {
            if possibleAnswersLabels.contains(label) { return UIDropProposal(operation: .copy) }
        }
        return UIDropProposal(operation: .forbidden)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let draggedLabel = session.items.first?.localObject as? UILabel else { return}
        let touchCoordinate = session.location(in: contentView)
        guard let destinationLabel = contentView.hitTest(touchCoordinate, with: nil) as? UILabel else { return }
        guard let draggedLabelIndex = possibleAnswersLabels.firstIndex(of: draggedLabel) else { return }
        
        createTapticFeedback(with: .medium)
        
        if destinationLabel.text == "___" {
            destinationLabel.text = draggedLabel.text
        } else {
            swapLabels(first: draggedLabel, second: destinationLabel, at: draggedLabelIndex)
        }
        
        destinationLabel.animateScale(with: 1.2)
        
        if let draggedLabel = possibleAnswersLabels.firstIndex(of: draggedLabel) {
            possibleAnswersLabels.remove(at: draggedLabel).removeFromSuperview()
        }
        
        //update constraint
        checkBtn.topAnchor.constraint(equalTo: possibleAnswersLabels.last!.bottomAnchor, constant: 15).isActive = true
        animateLayoutChanges()
    }
    
}

//MARK: Constraints

private extension DragTextCollectionViewCell {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            checkBtn.topAnchor.constraint(equalTo: possibleAnswersLabels.last!.bottomAnchor, constant: 15),
            checkBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).withPriority(999),
            checkBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            checkBtn.widthAnchor.constraint(equalToConstant: 120),
        ])
    }
    
}
