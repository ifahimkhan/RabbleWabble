//
//  QuestionGroup.swift
//  RabbleWabble
//
//  Created by Fahim on 4/18/24.
//

import Foundation
public class QuestionGroup: Codable{
    public class Score: Codable{
        public var correctCount:Int = 0
        public var incorrectCount:Int = 0
        public init(){

        }
    }
    public var score:Score

    public let questions:[Question]
    public let title:String


    public init(question:[Question],
                score:Score = Score(),title:String) {
        self.questions = question
        self.score = score
        self.title = title
    }

}
