//
//  TutorialSB1ViewController.swift
//  Accountable
//
//  Created by Lily Li on 8/3/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class TutorialSB1ViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        circleView.layer.cornerRadius = circleView.frame.size.width/2
        circleView.clipsToBounds = true
        
        circleView.layer.borderColor = UIColor.white.cgColor
        circleView.layer.borderWidth = 5.0    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
