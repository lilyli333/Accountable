//
//  AddItemView.swift
//  Accountable
//
//  Created by Lily Li on 7/17/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

protocol AddItemViewDelegate: class {
    func didTapAddButton(_ addItemButtom: UIButton, on view: AddItemView)
}

class AddItemView: UIView {
    
//    @IBOutlet weak var addItemButton: UIButton!
//    weak var delegate: AddItemViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    @IBAction func addItemButtonTapped(_ sender: UIButton) {
//        delegate?.didTapAddButton(sender, on: self)
//    }
}
