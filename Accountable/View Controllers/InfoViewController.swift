//
//  InfoViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/27/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var noftificationSwitch: UISwitch!
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name")
        userNameLabel.text = name
        print(name)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name")
        userNameLabel.text = name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindSegueToInfo(for segue: UIStoryboardSegue, sender: Any) {
    }
}
