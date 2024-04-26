//
//  BaseQuestionStrategy.swift
//  RabbleWabble
//
//  Created by Fahim on 4/25/24.
//

import SwiftUI

public class BaseQuestionStrategy: QuestionStrategy{

    private var questionIndex = 0
    public let questions: [Question]

    public var questionGroupCaretaker: QuestionGroupCaretaker
    public var questionGroup: QuestionGroup {
        return questionGroupCaretaker.selectedQuestionGroup
    }
    public init(questionGroupCaretaker: QuestionGroupCaretaker,
                questions: [Question]) {
        self.questionGroupCaretaker = questionGroupCaretaker
        self.questions = questions
        self.questionGroupCaretaker.selectedQuestionGroup.score.reset()
    }


    public var title: String{
        return questionGroup.title
    }

    public var correctCount: Int{
        get{return questionGroup.score.correctCount}
        set{ questionGroup.score.correctCount = newValue}
    }

    public var incorrectCount: Int{
        get{return questionGroup.score.incorrectCount}
        set{
            questionGroup.score.incorrectCount = newValue
        }
    }

    public func advanceToNextQuestion() -> Bool {
        try? questionGroupCaretaker.save()
        guard questionIndex + 1 < questions.count else {
            return false
        }
        questionIndex += 1
        return true
    }

    public func currentQuestion() -> Question {
        return questions[questionIndex]
    }

    public func markQuestionCorrect(_ question: Question) {
        correctCount += 1
    }

    public func markQuestionInCorrect(_ question: Question) {
        incorrectCount += 1
    }

    public func questionIndexTitle() -> String {
        return "\(questionIndex + 1) / \(questions.count)"
    }


}
