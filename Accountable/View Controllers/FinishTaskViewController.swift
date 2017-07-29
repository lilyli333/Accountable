//
//  FinishTaskViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/25/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class FinishTaskViewController: UIViewController {

    @IBOutlet weak var taskNameLabel: UILabel!
    var task: Task?
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameLabel.text = task?.title
        continueButton.layer.cornerRadius = 6
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
