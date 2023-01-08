//
//  FillTestViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 05.01.2023.
//

import UIKit

class FillTextViewController: UIViewController {
    
    var fillInQuestions = [FillInQuestion]()
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .createFillInTextSection())
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(FillInTextCollectionViewCell.self, forCellWithReuseIdentifier: FillInTextCollectionViewCell.identifier)
        collection.dataSource = self
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMockData()
        
        view.addSubview(collection)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collection.frame = view.bounds
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
