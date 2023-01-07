//
//  QuestionsListViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import UIKit

final class QuestionsListViewController: UIViewController {
    
    var questions = [Question]()
    var count: Int = 0
    
    lazy var collections: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .createMainSection())
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(QuestionsUICollectioViewCell.self, forCellWithReuseIdentifier: QuestionsUICollectioViewCell.identifier)
        collection.dataSource = self
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collections)
        getMockData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collections.frame = view.bounds
    }
    
}

private extension QuestionsListViewController {
    
    func getMockData() {
        do {
            let result = try JsonMockDecoder().getMockData(with: .questions, type: QuestionsResult.self)
            questions = result.items
            count = result.questionCount
        } catch {
            print(error)
        }
    }
    
}

extension QuestionsListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionsUICollectioViewCell.identifier, for: indexPath) as! QuestionsUICollectioViewCell
        
        cell.configure(question: questions[indexPath.item], count: count)
        
        return cell
    }
    
}
