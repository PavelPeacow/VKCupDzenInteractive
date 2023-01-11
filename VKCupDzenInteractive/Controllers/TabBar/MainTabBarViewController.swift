//
//  MainTabBarViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 04.01.2023.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }

    private func setTabBar() {
        
        let questions = UINavigationController(rootViewController: QuestionListViewController())
        
        questions.tabBarItem.title = "Вопросы"
        questions.tabBarItem.image = UIImage(systemName: "questionmark.square.fill")
        
        let compare = UINavigationController(rootViewController: CompareViewController())
        
        compare.tabBarItem.title = "Соотношение"
        compare.tabBarItem.image = UIImage(systemName: "arrow.right.to.line.compact")
        
        let dragText = UINavigationController(rootViewController: DragTextViewController())
        
        dragText.tabBarItem.title = "Перетащить"
        dragText.tabBarItem.image = UIImage(systemName: "hand.draw.fill")
        
        let fillInText = UINavigationController(rootViewController: FillTextViewController())
        
        fillInText.tabBarItem.title = "Заполнить"
        fillInText.tabBarItem.image = UIImage(systemName: "text.insert")
                
        let starRating = UINavigationController(rootViewController: StarRatingViewController())
        
        starRating.tabBarItem.title = "Звезда"
        starRating.tabBarItem.image = UIImage(systemName: "star.fill")
        
        setViewControllers([compare, dragText, fillInText, questions, starRating], animated: true)
    }
    
}

