//
//  InfoViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/27/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var restTime: UILabel!
    @IBOutlet weak var sendTextSwitch: UISwitch!
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name")
        userNameLabel.text = name
        let time = defaults.double(forKey: "restTime")
        print(time)
        restTime.text = "\(Int(time)/60) min"
        
        let deviceCanText = defaults.bool(forKey: "deviceText")
        if deviceCanText == true{
            sendTextSwitch.isEnabled = true
            let text = defaults.integer(forKey: "canText")
            if text == 0 {
                sendTextSwitch.setOn(false, animated: false)
            }
            else {
                sendTextSwitch.setOn(true, animated: false)
            }
        }
        else {
            sendTextSwitch.setOn(false, animated: false)
            sendTextSwitch.isEnabled = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name")
        userNameLabel.text = name
        let time = defaults.double(forKey: "restTime")
        restTime.text = "\(Int(time)/60) min"
    }

    @IBAction func textFuncSwitch(_ sender: Any) {
        if ((sender as AnyObject).isOn == true) {
            User.setText(num: 1)
        }
        else{
            User.setText(num: 0)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindSegueToInfo(for segue: UIStoryboardSegue, sender: Any) {
    }
}
