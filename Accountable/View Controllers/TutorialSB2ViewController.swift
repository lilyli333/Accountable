//
//  TutorialSB2ViewController.swift
//  Accountable
//
//  Created by Lily Li on 8/4/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class TutorialSB2ViewController: UIViewController {

    @IBOutlet weak var beginUsingAppButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        beginUsingAppButton.layer.cornerRadius = 6

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
