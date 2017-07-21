//
//  DisplayItemsTableViewCell.swift
//  Accountable
//
//  Created by Lily Li on 7/21/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class DisplayItemsTableViewCell: UITableViewCell {

    static var height: CGFloat = 150
    
    @IBOutlet weak var itemDescriptionTextView: UITextView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var itemTitleLabel: UILabel!
}
