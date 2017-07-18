//
//  ItemTableViewCell.swift
//  Accountable
//
//  Created by Lily Li on 7/13/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    static let height: CGFloat = 300
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundButton: UIButton!
    
    @IBOutlet weak var itemTitleTextField: UITextField!
    
    @IBOutlet weak var itemDescriptionTextView: UITextView!
    
    @IBOutlet weak var itemTimePicker: UIDatePicker!
    
    var seconds: Double = 60.0
    var title: String?
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textViewShouldReturn(textField: UITextView) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func backgroundButtonTapped(_ sender: Any) {
        textFieldShouldReturn(textField: itemTitleTextField)
        textViewShouldReturn(textField: itemDescriptionTextView)
        
        title = itemTitleTextField.text!
    }
    @IBAction func itemTimePickerAction(_ sender: Any) {
        itemTimePicker.datePickerMode = UIDatePickerMode.countDownTimer
        seconds = itemTimePicker.countDownDuration
    }
    
}

extension ItemTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("started")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        title = itemTitleTextField.text!
        print("finished")
    }
}
