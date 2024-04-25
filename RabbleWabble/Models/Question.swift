//
//  Question.swift
//  RabbleWabble
//
//  Created by Fahim on 4/18/24.
//

import Foundation

public class Question: Codable{
    public let answer: String
    public let hint:String?
    public let prompt:String

    init(answer:String,hint:String?,prompt:String) {
        self.answer = answer
        self.hint = hint
        self.prompt = prompt
    }
}
