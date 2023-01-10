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

enum JsonFileUrl {
    case questions
    case fillInQuestions
    case compare
    
    var type: URL? {
        switch self {
        case .questions:
            return Bundle.main.url(forResource: "QuestionsMock", withExtension: "json")
        case .fillInQuestions:
            return Bundle.main.url(forResource: "FillInQuestionsMock", withExtension: "json")
        case .compare:
            return Bundle.main.url(forResource: "CompareMock", withExtension: "json")
        }
    }
    
}

final class JsonMockDecoder {
    
    func getMockData<T: Decodable>(with url: JsonFileUrl, type: T.Type) throws -> T {
        guard let url = url.type else { throw DecoderError.badUrl }
        
        guard let data = try? Data(contentsOf: url) else { throw DecoderError.canNotGetData }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else { throw DecoderError.canNotDecodeData }
        
        return result
    }
    
}
