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
        
        let compare = UINavigationController(rootViewController: CompareViewController())
        
        compare.tabBarItem.title = "Questions"
        compare.tabBarItem.image = UIImage(systemName: "questionmark.app")
        
        let dragText = UINavigationController(rootViewController: DragTextViewController())
        
        dragText.tabBarItem.title = "Questions"
        dragText.tabBarItem.image = UIImage(systemName: "questionmark.app")
        
        let starRating = UINavigationController(rootViewController: StarRatingViewController())
        
        starRating.tabBarItem.title = "Rating"
        starRating.tabBarItem.image = UIImage(systemName: "star")
        
        let fillInText = UINavigationController(rootViewController: FillTextViewController())
        
        fillInText.tabBarItem.title = "QuestionsFillIn"
        fillInText.tabBarItem.image = UIImage(systemName: "questionmark.circle")
        
        let questions = UINavigationController(rootViewController: QuestionListViewController())
        
        questions.tabBarItem.title = "RegularQuestions"
        questions.tabBarItem.image = UIImage(systemName: "xmark")
        
        setViewControllers([compare, dragText, fillInText, questions, starRating], animated: true)
    }
    
}

