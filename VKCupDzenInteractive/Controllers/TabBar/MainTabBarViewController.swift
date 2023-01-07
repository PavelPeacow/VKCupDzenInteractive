//
//  ViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 04.01.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }

    private func setTabBar() {
        
        let test = UINavigationController(rootViewController: TestViewController())
        
        test.tabBarItem.title = "Questions"
        test.tabBarItem.image = UIImage(systemName: "questionmark.app")
        
        let starRating = UINavigationController(rootViewController: StarRatingViewController())
        
        starRating.tabBarItem.title = "Rating"
        starRating.tabBarItem.image = UIImage(systemName: "star")
        
        let testFillIn = UINavigationController(rootViewController: FillTestViewController())
        
        testFillIn.tabBarItem.title = "QuestionsFillIn"
        testFillIn.tabBarItem.image = UIImage(systemName: "questionmark.circle")
        
        let questions = UINavigationController(rootViewController: QuestionsListViewController())
        
        questions.tabBarItem.title = "RegularQuestions"
        questions.tabBarItem.image = UIImage(systemName: "xmark")
        
        setViewControllers([test, testFillIn, questions, starRating], animated: true)
    }
    
}

