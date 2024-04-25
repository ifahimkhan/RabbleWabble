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
    public let questionGroups = QuestionGroup.allGroups()
    private var selectedQuestionGroup: QuestionGroup!
    private let appSettings = AppSettings.shared


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
           for: selectedQuestionGroup)
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
