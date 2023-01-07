//
//  JsonDecoder.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 07.01.2023.
//

import Foundation

enum DecoderError: Error {
    case badUrl
    case canNotGetData
    case canNotDecodeData
}

final class JsonMockDecoder {
    
    func getMockData() async throws -> QuestionsResult {
        guard let url = Bundle.main.url(forResource: "QuestionsMock", withExtension: "json") else { throw DecoderError.badUrl }
        
        guard let data = try? Data(contentsOf: url) else { throw DecoderError.canNotGetData }
        
        guard let result = try? JSONDecoder().decode(QuestionsResult.self, from: data) else { throw DecoderError.canNotDecodeData }
        
        return result
    }
    
}
