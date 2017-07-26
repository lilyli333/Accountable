//
//  InputPinViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/26/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class InputPinViewController: UIViewController {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    @IBOutlet weak var pinInputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func textFieldChanged(_ sender: UITextField) {
        let arr = Array(pinInputTextField.text!.characters)
        
        if arr.count >= 1 {
            firstLabel.text = "."
        } else {
            firstLabel.text = "-"
        }
        
        if arr.count >= 2 {
            secondLabel.text = "."
        } else {
            secondLabel.text = "-"
        }
        
        if arr.count >= 3 {
            thirdLabel.text = "."
        } else {
            thirdLabel.text = "-"
        }
        
        if arr.count >= 4 {
            fourthLabel.text = "."
        } else {
            fourthLabel.text = "-"
        }
        
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        let number = Int(pinInputTextField.text!)
        let defaults = UserDefaults.standard
        let pin = defaults.integer(forKey: "pin")
        if number == pin{
            
        }
    }
}
