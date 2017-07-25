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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendText(text: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = text
            controller.recipients = ["\(task?.phoneNumber)"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else{
            print("DEVICE CANNOT SEND MSG")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    @IBAction func yesButtonTapped(_ sender: Any) {
        let str = "\(User.user) has successfully completed the task: \(item!.itemTitle). A picture of the product coming soon!"
        sendText(text: str)
        print(str)
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        let str = "\(User.user) has NOT completed task: \(item!.itemTitle)."
        sendText(text: str)
        print(str)
    }
}
