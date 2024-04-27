//
//  QuestionGroupBuilder.swift
//  RabbleWabble
//
//  Created by Fahim on 4/27/24.
//

import SwiftUI

public class QuestionGroupBuilder{
    public var questions = [QuestionBuilder()]
    public var title = ""

    public func addNewQuestion(){
        let question = QuestionBuilder()
        questions.append(question)
    }
    public func removeQuestion(at index: Int){

        questions.remove(at: index)
    }
    public func build() throws -> QuestionGroup{
        guard questions.count > 0 else{
            throw Error.MissingQuestions
        }
        guard title.count > 0 else{
            throw Error.MissingTitle
        }
        let questions = try self.questions.map{
            try $0.build()
        }
        return QuestionGroup(question: questions, title: title)
    }
    public enum Error: String, Swift.Error {
        case MissingTitle
        case MissingQuestions
      }

}
public class QuestionBuilder{
    public var prompt:String = ""
    public var hint:String = ""
    public var answer:String = ""

    public func build() throws -> Question{
        guard prompt.count>0 else{
            throw Error.MissingPrompt
        }
        guard answer.count > 0 else {
            throw Error.MissingAnswer
        }
        return Question(answer: answer, hint: hint, prompt: prompt)
    }
    public enum Error:String,Swift.Error{
        case MissingAnswer
        case MissingPrompt

    }
}

