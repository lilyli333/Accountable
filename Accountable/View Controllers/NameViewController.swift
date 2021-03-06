//
//  NameViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/26/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dontButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        dontButton.layer.cornerRadius = 6
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "setPin", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setPin" {
            let str = nameTextField.text!.removeWhiteSpaces()
            if nameTextField.text != "" && str != ""{
                let defaults = UserDefaults.standard
                User.setName(name: nameTextField.text!.trimmingCharacters(in: .whitespaces))
                if let name = defaults.string(forKey: "name"){
                    print("name:\(name)")
                }
            }
            else {
                let alertController = UIAlertController(title: "please enter a name", message:
                    "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
    }
}
