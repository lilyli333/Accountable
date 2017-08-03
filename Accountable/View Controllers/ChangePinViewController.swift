//
//  ChangePinViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/28/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class ChangePinViewController: UIViewController {
    
    @IBOutlet var changePinView: UIView!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pinTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.cornerRadius = 6
        
        pinTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        let num = Int(pinTextField.text!)
        if num?.digitCount == 4{
            
            User.setPin(pin: num!)
            
            let defaults = UserDefaults.standard
            if let pin = defaults.string(forKey: "pin") {
                print(pin)
            }
            
            pinTextField.resignFirstResponder()
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
        else{
            let alertController = UIAlertController(title: "please enter a 4 digit pin", message:
                "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        self.changePinView.isHidden = true
        
        performSegue(withIdentifier: "changePinToInfo", sender: self)
    }
    @IBAction func pinTextFieldChanged(_ sender: UITextField) {
        let arr = Array(pinTextField.text!.characters)
        
        if arr.count >= 1 {
            firstLabel.font = firstLabel.font.withSize(20)
            firstLabel.text = "⚪"
        } else {
            firstLabel.text = "-"
        }
        
        if arr.count >= 2 {
            secondLabel.font = secondLabel.font.withSize(20)
            secondLabel.text = "⚪"
        } else {
            secondLabel.text = "-"
        }
        
        if arr.count >= 3 {
            thirdLabel.font = thirdLabel.font.withSize(20)
            thirdLabel.text = "⚪"
        } else {
            thirdLabel.text = "-"
        }
        
        if arr.count >= 4 {
            fourthLabel.font = fourthLabel.font.withSize(20)
            fourthLabel.text = "⚪"
        } else {
            fourthLabel.text = "-"
        }
        
        if arr.count > 4 {
            pinTextField.isUserInteractionEnabled = false
            
        }
        else {
            pinTextField.isUserInteractionEnabled = true
        }
    }
}
