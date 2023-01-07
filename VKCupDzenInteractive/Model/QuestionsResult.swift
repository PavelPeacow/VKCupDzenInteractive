//
//  Questions.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 06.01.2023.
//

import Foundation

struct QuestionsResult: Decodable {
    let questionCount: Int
    let items: [Question]
}

struct Question: Decodable {
    let id: Int
    let question: String
    let answers: [QuestionAnswer]
    let rightAnswerIndex: Int
}

struct QuestionAnswer: Decodable {
    let answerName: String
    let percent: Int
}

extension QuestionAnswer {
    
    func validatePercentToString() -> String {
        "\(percent)%"
    }
    
}
