//
//  CreateQuestionGroupViewController.swift
//  RabbleWabble
//
//  Created by Fahim on 4/26/24.
//

import UIKit

public protocol CreateQuestionGroupViewControllerDelegate {

  func createQuestionGroupViewControllerDidCancel(_ viewController: CreateQuestionGroupViewController)

  func createQuestionGroupViewController(_ viewController: CreateQuestionGroupViewController,
                                         created questionGroup: QuestionGroup)
}

public class CreateQuestionGroupViewController: UITableViewController {

  // MARK: - Properties
  public var delegate: CreateQuestionGroupViewControllerDelegate?

  public override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
  }

  // MARK: - IBActions
  @IBAction func cancelPressed(_ sender: Any) {
    delegate?.createQuestionGroupViewControllerDidCancel(self)
  }

  @IBAction func savePressed(_ sender: Any) {
    // TODO: - Notify save pressed
  }
}

// MARK: - UITableViewDataSource
extension CreateQuestionGroupViewController {

  fileprivate struct CellIdentifiers {
    fileprivate static let add = "AddQuestionCell"
    fileprivate static let title = "CreateQuestionGroupTitleCell"
    fileprivate static let question = "CreateQuestionCell"
  }

  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = indexPath.row
    if row == 0 {
      return titleCell(from: tableView, for: indexPath)
    } else if row == 1 {
      return self.questionCell(from: tableView, for: indexPath)
    } else {
      return addQuestionGroupCell(from: tableView, for: indexPath)
    }
  }

  private func titleCell(from tableView: UITableView,
                         for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.title,
                                             for: indexPath) as! CreateQuestionGroupTitleCell
    cell.delegate = self

    // TODO: - Configure the cell

    return cell
  }

  private func  questionCell(from tableView: UITableView,
                             for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.question,
                                             for: indexPath) as! CreateQuestionCell
    cell.delegate = self

    // TODO: - Configure the cell

    return cell
  }

  private func addQuestionGroupCell(from tableView: UITableView,
                                    for indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.add,
                                         for: indexPath)
  }
}

// MARK: - UITableViewDelegate
extension CreateQuestionGroupViewController {

  // TODO: - Add `UITableViewDelegate` methods
}

// MARK: - CreateQuestionCellDelegate
extension CreateQuestionGroupViewController: CreateQuestionCellDelegate {

  public func createQuestionCell(_ cell: CreateQuestionCell,
                                 answerTextDidChange text: String) {
    // TODO: - Write this
  }

  public func createQuestionCell(_ cell: CreateQuestionCell,
                                 hintTextDidChange text: String) {
    // TODO: - Write this
  }

  public func createQuestionCell(_ cell: CreateQuestionCell,
                                 promptTextDidChange text: String) {
    // TODO: - Write this
  }
}

// MARK: - CreateQuestionGroupTitleCellDelegate
extension CreateQuestionGroupViewController: CreateQuestionGroupTitleCellDelegate {

  public func createQuestionGroupTitleCell(_ cell: CreateQuestionGroupTitleCell,
                                           titleTextDidChange text: String) {
    // TODO: - Write this
  }
}
