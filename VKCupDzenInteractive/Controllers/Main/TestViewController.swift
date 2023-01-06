//
//  TestViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 04.01.2023.
//

import UIKit

class TestViewController: UIViewController {
    
    var words = ["1", "lol", "mothermothermothermother", "2", "mothermother", "lol", "mother", "lol", "mother", "lol", "mother",]
    var text = "Put string ___ in here ___ fucker, Fcuk you the ___ epta Fcuk you the ___ epta"
    var textAnswers = ["lol", "1", "lol", "1"]
    
    var textFormated: [String] = []
    var labels: [UILabel] = []
    var answersLabels: [UILabel] = []

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 60, height: 30)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(WordsCollectionViewCell.self, forCellWithReuseIdentifier: WordsCollectionViewCell.identifier)
        collection.dataSource = self
        collection.dragDelegate = self
        return collection
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
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
        
        view.addSubview(stackView)
        view.addSubview(collectionView)
        view.addSubview(checkBtn)
        view.backgroundColor = .systemBackground
                
        setConstraints()
    }
    
    private func setText() {
        textFormated = text.components(separatedBy: " ")
        
        let spacing: CGFloat = 3
        
        var x: CGFloat = 0
        let y: CGFloat = 90
        var previousLabel: UILabel?
        
        for text in textFormated {
            let label = UILabel()
            label.isUserInteractionEnabled = true
            label.text = text
            label.font = .systemFont(ofSize: 18)
            
            x = previousLabel?.frame.maxX ?? x
            let size = label.sizeThatFits(CGSize(width: 40, height: 10))
            label.frame = CGRect(x: x + spacing, y: y, width: size.width, height: size.height)
            
            if label.text == "___" {
                let dropInteraction = UIDropInteraction(delegate: self)
                label.addInteraction(dropInteraction)
                label.backgroundColor = .gray
                label.layer.cornerRadius = 5
                label.textAlignment = .center
                label.clipsToBounds = true
                label.frame = CGRect(x: x + spacing, y: y, width: size.width + 10, height: size.height)
                answersLabels.append(label)
            }
            
            previousLabel = label
            
            labels.append(label)
            view.addSubview(label)
        }
        
        validateLayout()
    }
    
    private func validateLayout() {
        let spacing: CGFloat = 3
        
        var x: CGFloat = 0
        var y: CGFloat = 90
        var previousLabel: UILabel?
        
        for label in labels {
            
            x = previousLabel?.frame.maxX ?? x
            
            if x + label.frame.width > view.bounds.width {
                x = 0
                y += 30
                previousLabel = nil
            }
        
            let size = label.sizeThatFits(CGSize(width: 40, height: 10))
            label.frame = CGRect(x: x + spacing, y: y, width: size.width, height: size.height)
            
            if answersLabels.contains(label) {
                label.frame = CGRect(x: x + spacing, y: y, width: size.width + 10, height: size.height)
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
    
}

extension TestViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let index = session.items.first?.localObject as? Int
        
        let point = session.location(in: self.view)
        let selectedView = view.hitTest(point, with: nil) as? UILabel
        
        if let index = index, let selectedView = selectedView {
            selectedView.text = words[index]
            animateLabelChange(label: selectedView)
            
            UIView.animate(withDuration: 0.25) {
                //It just works
                self.validateLayout()
                self.validateLayout()
            }
            
        }
    }
    
}


//MARK: BURGER KING GOVNO

extension TestViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = words[indexPath.item]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = indexPath.item
        return [dragItem]
    }
    
}

extension TestViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordsCollectionViewCell.identifier, for: indexPath) as! WordsCollectionViewCell
        
        cell.configure(word: words[indexPath.item])
        return cell
    }
    
}

extension TestViewController {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            stackView.widthAnchor.constraint(equalToConstant: 200),
            
            collectionView.widthAnchor.constraint(equalToConstant: 300),
            collectionView.heightAnchor.constraint(equalToConstant: 150),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: labels.last!.bottomAnchor, constant: 20),
            
            checkBtn.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
            checkBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkBtn.heightAnchor.constraint(equalToConstant: 30),
            checkBtn.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
}


//
//  TestViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 04.01.2023.
//

//import UIKit
//
//class TestViewController: UIViewController {
//    
//    var words = ["1", "lol", "mothermothermothermother", "2", "mothermother", "lol", "mother", "lol", "mother", "lol", "mother",]
//    var text = "Put string ___ in here ___ fucker, Fcuk you the ___ epta Fcuk you the ___ epta"
//    var textAnswers = ["lol", "1", "lol", "1"]
//    
//    var textFormated: [String] = []
//    var labels: [UILabel] = []
//    var answersLabels: [UILabel] = []
//
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = CGSize(width: 60, height: 30)
//        
//        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collection.translatesAutoresizingMaskIntoConstraints = false
//        collection.register(WordsCollectionViewCell.self, forCellWithReuseIdentifier: WordsCollectionViewCell.identifier)
//        collection.dataSource = self
//        collection.dragDelegate = self
//        return collection
//    }()
//    
//    lazy var stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fill
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        return stackView
//    }()
//    
//    lazy var checkBtn: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("Check", for: .normal)
//        btn.backgroundColor = .orange
//        btn.layer.cornerRadius = 15
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.addTarget(self, action: #selector(didTapCheckBtn), for: .touchUpInside)
//        return btn
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setText()
//        
//        view.addSubview(stackView)
//        view.addSubview(collectionView)
//        view.addSubview(checkBtn)
//        view.backgroundColor = .systemBackground
//                
//        setConstraints()
//    }
//    
//    private func setText() {
//        textFormated = text.components(separatedBy: " ")
//        
//        let spacing: CGFloat = 3
//        
//        var x: CGFloat = 0
//        let y: CGFloat = 90
//        var previousLabel: UILabel?
//        
//        for text in textFormated {
//            let label = UILabel()
//            label.isUserInteractionEnabled = true
//            label.text = text
//            label.font = .systemFont(ofSize: 18)
//            
//            x = previousLabel?.frame.maxX ?? x
//            let size = label.sizeThatFits(CGSize(width: 40, height: 10))
//            label.frame = CGRect(x: x + spacing, y: y, width: size.width, height: size.height)
//            
//            if label.text == "___" {
//                let dropInteraction = UIDropInteraction(delegate: self)
//                label.addInteraction(dropInteraction)
//                label.backgroundColor = .gray
//                label.layer.cornerRadius = 5
//                label.textAlignment = .center
//                label.clipsToBounds = true
//                label.frame = CGRect(x: x + spacing, y: y, width: size.width + 10, height: size.height)
//                answersLabels.append(label)
//            }
//            
//            previousLabel = label
//            
//            labels.append(label)
//            view.addSubview(label)
//        }
//        
//        validateLayout()
//    }
//    
//    private func validateLayout() {
//        let spacing: CGFloat = 3
//        
//        var x: CGFloat = 0
//        var y: CGFloat = 90
//        var previousLabel: UILabel?
//        
//        for label in labels {
//            
//            x = previousLabel?.frame.maxX ?? x
//            
//            if x + label.frame.width > view.bounds.width {
//                x = 0
//                y += 30
//                previousLabel = nil
//            }
//        
//            let size = label.sizeThatFits(CGSize(width: 40, height: 10))
//            label.frame = CGRect(x: x + spacing, y: y, width: size.width, height: size.height)
//            
//            if answersLabels.contains(label) {
//                label.frame = CGRect(x: x + spacing, y: y, width: size.width + 10, height: size.height)
//            }
//            
//            previousLabel = label
//        }
//    }
//    
//    @objc private func didTapCheckBtn() {
//        for (index, label) in answersLabels.enumerated() {
//            let text = label.text
//            
//            if textAnswers[index] == text {
//                label.backgroundColor = .green
//            } else {
//                label.backgroundColor = .red
//            }
//        }
//    }
//    
//    func animateLabelChange(label: UILabel) {
//        label.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//        
//        UIView.animate(withDuration: 0.25) {
//            label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        }
//    }
//    
//}
//
//extension TestViewController: UIDropInteractionDelegate {
//    
//    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
//        return UIDropProposal(operation: .copy)
//    }
//    
//    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
//        let index = session.items.first?.localObject as? Int
//        
//        let point = session.location(in: self.view)
//        let selectedView = view.hitTest(point, with: nil) as? UILabel
//        
//        if let index = index, let selectedView = selectedView {
//            selectedView.text = words[index]
//            animateLabelChange(label: selectedView)
//            
//            UIView.animate(withDuration: 0.25) {
//                //It just works
//                self.validateLayout()
//                self.validateLayout()
//            }
//            
//        }
//    }
//    
//}
//
//
////MARK: BURGER KING GOVNO
//
//extension TestViewController: UICollectionViewDragDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = words[indexPath.item]
//        let itemProvider = NSItemProvider(object: item as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = indexPath.item
//        return [dragItem]
//    }
//    
//}
//
//extension TestViewController: UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        words.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordsCollectionViewCell.identifier, for: indexPath) as! WordsCollectionViewCell
//        
//        cell.configure(word: words[indexPath.item])
//        return cell
//    }
//    
//}
//
//extension TestViewController {
//    
//    func setConstraints() {
//        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            stackView.heightAnchor.constraint(equalToConstant: 200),
//            stackView.widthAnchor.constraint(equalToConstant: 200),
//            
//            collectionView.widthAnchor.constraint(equalToConstant: 300),
//            collectionView.heightAnchor.constraint(equalToConstant: 150),
//            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            collectionView.topAnchor.constraint(equalTo: labels.last!.bottomAnchor, constant: 20),
//            
//            checkBtn.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
//            checkBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            checkBtn.heightAnchor.constraint(equalToConstant: 30),
//            checkBtn.widthAnchor.constraint(equalToConstant: 100),
//        ])
//    }
//    
//}
