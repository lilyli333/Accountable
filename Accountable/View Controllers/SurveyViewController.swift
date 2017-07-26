//
//  SurveyViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/24/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import MessageUI

class SurveyViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var task: Task?
    var item: Item?
    var items = [Item]()
    var didFinish: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendText(text: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = text
            controller.recipients = ["\(task!.phoneNumber)"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else{
            print("DEVICE CANNOT SEND MSG")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        if didFinish == true{
            performSegue(withIdentifier: "showCamera", sender: self)
        }
        else {
            performSegue(withIdentifier: "unfinishedTask", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCamera" {
            let cameraViewController = segue.destination as! CameraViewController
            cameraViewController.task = task!
            cameraViewController.items = items
        }
    }
    
    @IBAction func yesButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name")
        let str = "\(name) has successfully completed the task: \(item!.itemTitle). A picture of the product coming soon!"
        sendText(text: str)
        print(str)
        didFinish = true
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name")
        let str = "\(name) has NOT completed task: \(item!.itemTitle)."
        sendText(text: str)
        print(str)
        didFinish = false
    }
}
