//
//  FillInQuestion.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 07.01.2023.
//

import Foundation

struct FillInQuestion: Decodable {
    let text: String
    let rightAnswers: [String]
    let possibleAnswers: [String]
}
