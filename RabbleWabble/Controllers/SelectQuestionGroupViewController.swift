//
//  SelectQuestionGroupViewController.swift
//  RabbleWabble
//
//  Created by Fahim on 4/20/24.
//

import UIKit

public class SelectQuestionGroupViewController: UIViewController{

    @IBOutlet internal var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    public let questionGroupCareTaker = QuestionGroupCaretaker()

    private var questionGroups:[QuestionGroup]{
        return questionGroupCareTaker.questionGroups
    }
    private var selectedQuestionGroup: QuestionGroup!{
        get{
            return questionGroupCareTaker.selectedQuestionGroup
        }set{
            questionGroupCareTaker.selectedQuestionGroup = newValue
        }
    }
    private let appSettings = AppSettings.shared

    public override func viewDidLoad() {
      super.viewDidLoad()
      questionGroups.forEach {
        print("\($0.title): " +
          "correctCount \($0.score.correctCount), " +
          "incorrectCount \($0.score.incorrectCount)"
        )
      }
    }



}

extension SelectQuestionGroupViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int)->Int{
        return questionGroups.count
    }

    public func tableView(_ tableView:UITableView,cellForRowAt indexPath: IndexPath)->UITableViewCell{

        let cell  = tableView.dequeueReusableCell(withIdentifier: "QuestionGroupCell",for: indexPath) as! QuestionGroupCell
        let questiongroup = questionGroups[indexPath.row]
        cell.titleLabel.text = questiongroup.title
        return cell

    }
}

extension SelectQuestionGroupViewController: UITableViewDelegate{

    public func tableView(_ tableView:UITableView, willSelectRowAt indexPath: IndexPath)
    -> IndexPath?
    {
        selectedQuestionGroup = questionGroups[indexPath.row]
        return indexPath
    }

    public func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    public override func prepare(for seque: UIStoryboardSegue,sender: Any?){
        guard let viewController = seque.destination as? QuestionViewController else{ return }
        viewController.questionStrategy =
        appSettings.questionStrategy(
            for: questionGroupCareTaker)
        viewController.delegate = self
    }
}
extension SelectQuestionGroupViewController:
    QuestionViewControllerDelegate {
    public func questionViewController(_ questionViewController: QuestionViewController,
                                       didCancel questionStrategy:QuestionStrategy,
                                       at questionIndex: Int){
        navigationController?.popToViewController(self, animated: true)

    }
    public func questionViewController(
        _ viewController: QuestionViewController,
        didComplete questionStrategy: QuestionStrategy) {
            navigationController?.popToViewController(self,
                                                      animated: true)
        }
}
