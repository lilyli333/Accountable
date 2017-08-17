//
//  AboutCreatorViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/31/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class AboutCreatorViewController: UIViewController {

    @IBOutlet weak var creatorImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        creatorImage.layer.borderWidth = 1
        creatorImage.layer.masksToBounds = false
        creatorImage.layer.borderColor = UIColor.white.cgColor
        creatorImage.layer.cornerRadius = creatorImage.frame.height/2
        creatorImage.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
