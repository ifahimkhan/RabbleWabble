//
//  ViewController.swift
//  RabbleWabble
//
//  Created by Ragesh on 4/18/24.
//

import UIKit

class QuestionViewController: UIViewController {


    public var questionGroup = QuestionGroup.basicPhrases()
    public var questionIndex = 0
    public var correctCount = 0
    public var incorrectCount = 0
    public var questionView: QuestionView! {
        guard isViewLoaded else { return nil }
        return (view as! QuestionView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion()
        // Do any additional setup after loading the view.
    }
    private func showQuestion(){
        let question = questionGroup.questions[questionIndex]
        questionView.promptLabel.text = question.prompt
        questionView.hintLabel.text = question.hint
        questionView.answerLabel.text = question.answer

        questionView.hintLabel.isHidden = true
        questionView.answerLabel.isHidden = true
    }

    @IBAction func toggleAnswerLabels(_ sender:Any){
        if questionView.hintLabel.isHidden{
            questionView.hintLabel.isHidden = !questionView.hintLabel.isHidden
            questionView.answerLabel.isHidden = true
        }
        else{
            questionView.hintLabel.isHidden = !questionView.hintLabel.isHidden
            questionView.answerLabel.isHidden = !questionView.answerLabel.isHidden

        }
    }

    @IBAction func handleCorrect(_ sender:Any){
        correctCount += 1
        questionView.correctCountLabel.text = "\(correctCount)"
        showNextQuestion()
    }
    @IBAction func handleIncorrect(_ sender:Any){
        incorrectCount += 1
        questionView.incorrectCountLabel.text = "\(incorrectCount)"
        showNextQuestion()
    }
    private func showNextQuestion(){
        questionIndex += 1
        guard questionIndex < questionGroup.questions.count else{

            return
        }
        showQuestion()
    }

}

