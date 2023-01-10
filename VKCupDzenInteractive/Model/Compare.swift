//
//  Compare.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 10.01.2023.
//

struct Compare: Decodable {
    let leftColumn: [String]
    let rightColumn: [String]
    let rightAnswers: [String:String]
}
