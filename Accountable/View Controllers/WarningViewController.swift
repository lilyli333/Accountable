//
//  WarningViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/26/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class WarningViewController: UIViewController {
    var task: Task?
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func continueButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "startTaskNoTxt", sender: self)

        
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startTaskNoTxt" {
            let timerViewController = segue.destination as! TimerViewController
            timerViewController.task = task!
            timerViewController.items = items
            timerViewController.originalItems = items
        }
    }
}
