//
//  FillTestViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 05.01.2023.
//

import UIKit

final class FillTextViewController: UIViewController {
    
    private var fillInQuestions = [FillInQuestion]()
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .createFillInTextSection())
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        if #available(iOS 16, *) {
            collection.selfSizingInvalidation = .disabled
        }
        collection.register(FillInTextCollectionViewCell.self, forCellWithReuseIdentifier: FillInTextCollectionViewCell.identifier)
        collection.dataSource = self
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMockData()
        registerKeyboardNotification()
        
        view.addSubview(collection)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collection.frame = view.bounds
    }
    
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 100, right: 0)
        collection.contentInset = contentInsets
        collection.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        collection.contentInset = .zero
        collection.scrollIndicatorInsets = .zero
    }
    
}

private extension FillTextViewController {
    
    func getMockData() {
        do {
            let result = try JsonMockDecoder().getMockData(with: .fillInQuestions, type: [FillInQuestion].self)
            fillInQuestions = result
        } catch {
            print(error)
        }
    }
    
}

extension FillTextViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fillInQuestions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FillInTextCollectionViewCell.identifier, for: indexPath) as! FillInTextCollectionViewCell
        
        cell.configure(fillInQuestion: fillInQuestions[indexPath.item])
        
        return cell
    }
    
}
