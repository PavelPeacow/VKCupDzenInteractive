//
//  QuestionsListViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import UIKit

class QuestionsListViewController: UIViewController {
    
    var questions = [Question]()
    var count: Int = 0
    
    lazy var collections: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .createCategorySection())

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(QuestionsUICollectioViewCell.self, forCellWithReuseIdentifier: QuestionsUICollectioViewCell.identifier)
        collection.dataSource = self
        
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            if let result = try? await JsonMockDecoder().getMockData() {
                print(result)
                questions = result.items
                count = result.questionCount
                collections.reloadData()
            }
            
        }

        view.addSubview(collections)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collections.frame = view.bounds
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
