//
//  QuestionStrategy.swift
//  RabbleWabble
//
//  Created by Fahim on 4/23/24.
//

import SwiftUI

public protocol QuestionStrategy: class{
    var title: String {get}
    var correctCount:Int {get}
    var incorrectCount:Int{get}
    func advanceToNextQuestion()->Bool
    func currentQuestion() -> Question
    func markQuestionCorrect(_ question:Question)
    func markQuestionInCorrect(_ question:Question)
    func questionIndexTitle()-> String
}
