//
//  QuestionListViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import UIKit

final class QuestionListViewController: UIViewController {
    
    private var questions = [Question]()
    private var count: Int = 0
    
    lazy var collections: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .createMainSection())
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        if #available(iOS 16, *) {
            collection.selfSizingInvalidation = .disabled
        }
        collection.register(QuestionCollectioViewCell.self, forCellWithReuseIdentifier: QuestionCollectioViewCell.identifier)
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

private extension QuestionListViewController {
    
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

extension QuestionListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionCollectioViewCell.identifier, for: indexPath) as! QuestionCollectioViewCell
        
        cell.configure(question: questions[indexPath.item], count: count)
        
        return cell
    }
    
}
