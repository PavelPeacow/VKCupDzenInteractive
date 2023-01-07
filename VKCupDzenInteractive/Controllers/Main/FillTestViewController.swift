//
//  FillTestViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 05.01.2023.
//

import UIKit

class FillTestViewController: UIViewController {
    
    var fillInQuestions = [FillInQuestion]()
    
    lazy var collections: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .createFillInTextSection())
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(FillInQuestionCollectionViewCell.self, forCellWithReuseIdentifier: FillInQuestionCollectionViewCell.identifier)
        collection.dataSource = self
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMockData()
        
        view.addSubview(collections)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collections.frame = view.bounds
    }
    
}

private extension FillTestViewController {
    
    func getMockData() {
        do {
            let result = try JsonMockDecoder().getMockData(with: .fillInQuestions, type: [FillInQuestion].self)
            fillInQuestions = result
        } catch {
            print(error)
        }
    }
    
}

extension FillTestViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fillInQuestions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FillInQuestionCollectionViewCell.identifier, for: indexPath) as! FillInQuestionCollectionViewCell
        
        cell.configure(fillInQuestion: fillInQuestions[indexPath.item])
        
        return cell
    }
    
}
