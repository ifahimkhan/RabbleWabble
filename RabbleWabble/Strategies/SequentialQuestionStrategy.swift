//
//  SequentialQuestionStrategy.swift
//  RabbleWabble
//
//  Created by Fahim on 4/23/24.
//


import SwiftUI

public class SequentialQuestionStrategy: BaseQuestionStrategy{

    public convenience init(
        questionGroupCaretaker: QuestionGroupCaretaker) {
            let questionGroup =
            questionGroupCaretaker.selectedQuestionGroup!
            let questions = questionGroup.questions
            self.init(questionGroupCaretaker: questionGroupCaretaker,questions:questions)
        }


}
