//
//  ListTasksTableViewCell.swift
//  Accountable
//
//  Created by Lily Li on 7/13/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class ListTasksTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 100
    
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    @IBOutlet weak var taskModificationTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
