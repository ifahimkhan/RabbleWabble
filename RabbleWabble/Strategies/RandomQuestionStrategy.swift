//
//  RandomQuestionStrategy.swift
//  RabbleWabble
//
//  Created by Fahim on 4/23/24.
//

import GameplayKit.GKRandomSource

public class RandomQuestionStrategy: BaseQuestionStrategy{

    public convenience init(questionGroupCareTaker: QuestionGroupCaretaker) {
        let questionGroup = questionGroupCareTaker.selectedQuestionGroup!
        
        let randomSource = GKRandomSource.sharedRandom()
        let questions =
        randomSource.arrayByShufflingObjects(
            in: questionGroup.questions) as! [Question]
        self.init(questionGroupCaretaker: questionGroupCareTaker,questions: questions)
    }

}
