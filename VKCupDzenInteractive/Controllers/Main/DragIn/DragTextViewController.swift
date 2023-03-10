//
//  DragTextViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 04.01.2023.
//

import UIKit

final class DragTextViewController: UIViewController {
    
    private var dragInQuestions = [FillInQuestion]()
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .createDragInTextSection())
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        if #available(iOS 16, *) {
            collection.selfSizingInvalidation = .disabled
        }
        collection.register(DragTextCollectionViewCell.self, forCellWithReuseIdentifier: DragTextCollectionViewCell.identifier)
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

private extension DragTextViewController {
    
    func getMockData() {
        do {
            let result = try JsonMockDecoder().getMockData(with: .fillInQuestions, type: [FillInQuestion].self)
            dragInQuestions = result
        } catch {
            print(error)
        }
    }
    
}

extension DragTextViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dragInQuestions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DragTextCollectionViewCell.identifier, for: indexPath) as! DragTextCollectionViewCell
        
        cell.configure(fillInQuestion: dragInQuestions[indexPath.item])
        
        return cell
    }
    
}
