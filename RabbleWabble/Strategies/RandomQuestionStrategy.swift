//
//  RandomQuestionStrategy.swift
//  RabbleWabble
//
//  Created by Fahim on 4/23/24.
//

import GameplayKit.GKRandomSource

public class RandomQuestionStrategy: QuestionStrategy{

    public var correctCount: Int = 0
    public var incorrectCount: Int = 0
    private let questionGroup: QuestionGroup
    private var questionIndex = 0
    private let questions: [Question]
    
    public init(questionGroup: QuestionGroup) {
        self.questionGroup = questionGroup
        
        let randomSource = GKRandomSource.sharedRandom()
        self.questions =
        randomSource.arrayByShufflingObjects(
            in: questionGroup.questions) as! [Question]
    }
    public var title: String {
        return questionGroup.title
    }
    public func currentQuestion() -> Question {
        return questions[questionIndex]
    }
    public func advanceToNextQuestion() -> Bool {
        guard questionIndex + 1 < questions.count else {
            return false
        }
        questionIndex += 1
        return true
    }
    public func markQuestionCorrect(_ question: Question) {
        correctCount += 1
    }
    public func markQuestionInCorrect(_ question: Question) {
        incorrectCount += 1
    }
    public func questionIndexTitle() -> String {
        return "\(questionIndex + 1)/\(questions.count)"
    }

}
