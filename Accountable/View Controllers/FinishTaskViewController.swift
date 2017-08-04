//
//  FinishTaskViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/25/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import MessageUI

class FinishTaskViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var resultsTable: UITableView!
    var originalItems = [Item]()
    var results = [Int]()
    
    @IBOutlet weak var taskNameLabel: UILabel!
    var task: Task?
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameLabel.text = task?.title
        continueButton.layer.cornerRadius = 6
        shareButton.layer.cornerRadius = 6
        
        print(results)
        print(self.parseResults())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        let canText = defaults.integer(forKey: "canText")
        
        let imagePickerActionSheet = UIAlertController(title: "which medium to use",
                                                       message: nil, preferredStyle: .actionSheet)
        if canText == 1 {
            let textButton = UIAlertAction(title: "text message", style: .default) { (alert) -> Void in
                self.sendText(text: self.parseResults())
            }
            imagePickerActionSheet.addAction(textButton)
        }
        if !MFMailComposeViewController.canSendMail() {
            let emailButton = UIAlertAction(title: "email", style: .default) { (alert) -> Void in
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                
                let defaults = UserDefaults.standard
                let name: String = defaults.string(forKey: "name")!
                
                composeVC.setToRecipients([""])
                composeVC.setSubject("\(name) has completed the to-do list: \(self.task!.title)")
                composeVC.setMessageBody("\(self.parseResults())!", isHTML: false)
                self.present(composeVC, animated: true, completion: nil)
            }
            imagePickerActionSheet.addAction(emailButton)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        present(imagePickerActionSheet, animated: true,
                completion: nil)
        
        
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendText(text: String) {
        
        let controller = MFMessageComposeViewController()
        controller.body = text
        controller.recipients = ["\(task!.phoneNumber)"]
        controller.messageComposeDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func parseResults() -> String {
        var str = ""
        for index in 0..<results.count {
            str += "task: \(originalItems[index].itemTitle) is "
            if results[index] == 1 {
                str += "completed \n"
            }
            else {
                str += "not complete \n"
            }
        }
        return str
    }
}

extension FinishTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return originalItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsTableCell", for: indexPath) as! ResultsTableViewCell
        let item = originalItems[indexPath.row]
        cell.itemTitle.text = item.itemTitle
        cell.itemTitle.adjustsFontSizeToFitWidth = true
        if results[indexPath.row] == 1{
            cell.resultLabel.text = "✔️"
        }
        else{
            cell.resultLabel.text = "❌"
        }
        return cell
    }
}

extension FinishTaskViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ResultsTableViewCell.height
    }
}

