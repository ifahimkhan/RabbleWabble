//
//  QuestionGroupCell.swift
//  RabbleWabble
//
//  Created by Fahim on 4/22/24.
//

import SwiftUI
import Combine

public class QuestionGroupCell: UITableViewCell{
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var percentageLabel: UILabel!
    public var percentageSubscriber: AnyCancellable?
}
