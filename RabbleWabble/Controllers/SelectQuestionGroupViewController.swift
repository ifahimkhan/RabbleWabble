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


}

extension SelectQuestionGroupViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int)->Int{
        return questionGroups.count
    }

    public func tableView(_ tableView:UITableView,cellForRowAt indexPath: IndexPath)->UITableViewCell{

        let cell  = tableView.dequeueReusableCell(withIdentifier: "QuestionGroupCell") as! QuestionGroupCell
        let questiongroup = questionGroups[indexPath.row]
        cell.titleLabel.text = questiongroup.title
        return cell

    }
}
