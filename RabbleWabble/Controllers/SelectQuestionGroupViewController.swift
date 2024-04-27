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
    private let questionGroupCareTaker = QuestionGroupCaretaker()

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
        cell.percentageSubscriber =
          questiongroup.score.$runningPercentage // 1
            .receive(on: DispatchQueue.main) // 2
            .map() { // 3
              return String(format: "%.0f %%", round(100 * $0))
          }.assign(to: \.text, on: cell.percentageLabel)
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
    public override func prepare(
      for segue: UIStoryboardSegue, sender: Any?) {
      if let viewController =
        segue.destination as? QuestionViewController {
        viewController.questionStrategy =
          appSettings.questionStrategy(for: questionGroupCareTaker)
        viewController.delegate = self

      } else if let navController =
          segue.destination as? UINavigationController,
        let viewController =
          navController.topViewController as? CreateQuestionGroupViewController {
        viewController.delegate = self
      }

      // Whatevs... skip anything else
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

extension SelectQuestionGroupViewController:
CreateQuestionGroupViewControllerDelegate {
  public func createQuestionGroupViewControllerDidCancel(
    _ viewController: CreateQuestionGroupViewController) {
    dismiss(animated: true, completion: nil)
  }
  public func createQuestionGroupViewController(
    _ viewController: CreateQuestionGroupViewController,
    created questionGroup: QuestionGroup) {
        questionGroupCareTaker.questionGroups.append(questionGroup)
        try? questionGroupCareTaker.save()
            dismiss(animated: true, completion: nil)
            tableView.reloadData()
          }
        }
