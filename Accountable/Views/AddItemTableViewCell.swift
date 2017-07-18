//
//  AddItemTableViewCell.swift
//  Accountable
//
//  Created by Lily Li on 7/13/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

protocol AddItemTableViewCellDelegate: class {
    func didTapAddButton(_ addItemButtom: UIButton, on cell: AddItemTableViewCell)
}

class AddItemTableViewCell: UITableViewCell {
    static let height: CGFloat = 50
    
    @IBOutlet weak var addItemButton: UIButton!
    weak var delegate: AddItemTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    @IBAction func addItemButtonTapped(_ sender: UIButton) {
        delegate?.didTapAddButton(sender, on: self)
    }
}



//tableview.reload
