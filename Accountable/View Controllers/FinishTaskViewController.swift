//
//  FinishTaskViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/25/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class FinishTaskViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
