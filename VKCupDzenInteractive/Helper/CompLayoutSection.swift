//
//  CompLayoutSection.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import UIKit

extension NSCollectionLayoutSection {
    
        static func createCategorySection() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            
            return section
        }
    
}
