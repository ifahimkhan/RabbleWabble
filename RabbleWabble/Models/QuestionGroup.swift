//
//  QuestionGroup.swift
//  RabbleWabble
//
//  Created by Fahim on 4/18/24.
//

import Foundation
import Combine

public class QuestionGroup: Codable{
    public class Score: Codable{
        public var correctCount: Int = 0 {
            didSet { updateRunningPercentage() }
        }
        public var incorrectCount: Int = 0 {
            didSet { updateRunningPercentage() }
        }

            public init(){

            }
            @Published public var runningPercentage:Double = 0
            private enum CodingKeys: String, CodingKey {
                case correctCount
                case incorrectCount
            }
            public required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy:
                                                        CodingKeys.self)
                self.correctCount = try container.decode(Int.self,
                                                         forKey: .correctCount)
                self.incorrectCount = try container.decode(Int.self,
                                                           forKey: .incorrectCount)
                updateRunningPercentage()
            }
            private func updateRunningPercentage() {
                let totalCount = correctCount + incorrectCount
                guard totalCount > 0 else {
                    runningPercentage = 0
                    return
                }
                runningPercentage = Double(correctCount) / Double(totalCount)
            }
            public func reset(){
                correctCount = 0
                incorrectCount = 0
            }
        }
        public private(set) var score: Score
        public let questions:[Question]
        public let title:String


        public init(question:[Question],
                    score:Score = Score(),title:String) {
            self.questions = question
            self.score = score
            self.title = title
        }

    }
