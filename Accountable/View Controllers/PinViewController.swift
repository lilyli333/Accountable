//
//  PinViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/26/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class PinViewController: UIViewController {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pinTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.cornerRadius = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        let num = Int(pinTextField.text!)
        if num?.digitCount == 4{
            
            User.setPin(num!)
            
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
    }
    @IBAction func pinTextFieldChanged(_ sender: UITextField) {
        let arr = Array(pinTextField.text!.characters)
        
        if arr.count >= 1 {
            firstLabel.text = String(arr[0])
        } else {
            firstLabel.text = "-"
        }
        
        if arr.count >= 2 {
            secondLabel.text = String(arr[1])
        } else {
            secondLabel.text = "-"
        }
        
        if arr.count >= 3 {
            thirdLabel.text = String(arr[2])
        } else {
            thirdLabel.text = "-"        }
        
        if arr.count >= 4 {
            fourthLabel.text = String(arr[3])
        } else {
            fourthLabel.text = "-"
        }
    }
}