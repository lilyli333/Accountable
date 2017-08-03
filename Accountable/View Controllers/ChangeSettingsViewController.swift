//
//  ChangeSettingsViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/27/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class ChangeSettingsViewController: UIViewController {

    @IBAction func tapGestureTapped(_ sender: Any) {
        nameTextField.resignFirstResponder()
    }
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        nameTextField.text = defaults.string(forKey: Constants.UserDefaults.name)
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
