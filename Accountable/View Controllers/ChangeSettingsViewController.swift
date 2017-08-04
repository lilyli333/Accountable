//
//  ChangeSettingsViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/27/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class ChangeSettingsViewController: UIViewController {

    @IBOutlet weak var restTimePicker: UIDatePicker!
    @IBAction func tapGestureTapped(_ sender: Any) {
        nameTextField.resignFirstResponder()
        User.setTime(seconds: restTimePicker.countDownDuration)
    }
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        nameTextField.text = defaults.string(forKey: Constants.UserDefaults.name)
        let time = defaults.double(forKey: "restTime")
        restTimePicker.countDownDuration = time
    }
   
    @IBAction func backButtonTapped(_ sender: Any) {
        User.setTime(seconds: restTimePicker.countDownDuration)
         let defaults = UserDefaults.standard
        let time = defaults.double(forKey: "restTime")
        print(time)
    }
    @IBAction func timeChanged(_ sender: Any) {
        User.setTime(seconds: restTimePicker.countDownDuration)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        let defaults = UserDefaults.standard
        let name = nameTextField.text!
        defaults.set(name, forKey: Constants.UserDefaults.name)
    }
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "changePinToInput", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changePinToInput" {
            let inputPinViewController = segue.destination as! InputPinViewController
            inputPinViewController.fromSB = .editSettings
        }
    }
}
