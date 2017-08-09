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
    var isLastTime = false
    
    var results = [Int]()
    var originalItems = [Item]()
    
    var timer = Timer()
    
    var seconds: Int?
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let restTime = defaults.double(forKey: "restTime")
        seconds = Int(restTime)
        runTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendText(text: String) {
        let defaults = UserDefaults.standard
        let canText = defaults.integer(forKey: "canText")
        if (MFMessageComposeViewController.canSendText() && canText == 1) {
            let controller = MFMessageComposeViewController()
            controller.body = text
            controller.recipients = ["\(task!.phoneNumber)"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else{
            print("DEVICE CANNOT SEND MSG")
            return
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        
        if seconds! < 1 {
            timer.invalidate()
            didFinish = false
            
            noButtonTapped(self)
        }
        else {
            seconds! -= 10
            timeLabel.text = ToStringHelper.timeString(time: TimeInterval(seconds!))
        }
    }
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        if isLastTime == true{
            performSegue(withIdentifier: "surveyToCongrats", sender: self)
        }
        else {
            performSegue(withIdentifier: "unfinishedTask", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCamera" {
            let cameraViewController = segue.destination as! CameraViewController
            
            cameraViewController.didFinish = isLastTime
            cameraViewController.task = task!
            cameraViewController.items = items
            cameraViewController.results = results
            cameraViewController.originalItems = originalItems
        }
        else if segue.identifier == "unfinishedTask" {
            let timerViewController = segue.destination as! TimerViewController
            timerViewController.task = task!
            timerViewController.items = items
            do{
                timerViewController.items.remove(at: 0)
                timerViewController.seconds = timerViewController.getTime()
                timerViewController.collectionView.reloadData()
            }
            catch{
                print(error)
            }
            if didFinish == true {
                timerViewController.results.append(1)
            }
            else {
                timerViewController.results.append(0)
            }
        }
        else if segue.identifier == "surveyToCongrats" {
            
            if didFinish == true {
                results.append(1)
            }
            else {
                results.append(0)
            }
            
            let congratsViewController = segue.destination as! FinishTaskViewController
            congratsViewController.task = task!
            congratsViewController.results = results
            congratsViewController.originalItems = originalItems
        }
    }
    
    @IBAction func yesButtonTapped(_ sender: Any) {
        didFinish = true
        timer.invalidate()
        let defaults = UserDefaults.standard
        let canText = defaults.integer(forKey: "canText")
        if canText == 1 {
            let name = defaults.string(forKey: "name")
            let str = "\(name!) has successfully completed the task: \(item!.itemTitle). A picture of the product coming soon!"
            sendText(text: str)
        }
        else{
            if isLastTime == true{
                performSegue(withIdentifier: "surveyToCongrats", sender: self)
            }
            else{
                performSegue(withIdentifier: "unfinishedTask", sender: self)
            }
        }
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        didFinish = false
        timer.invalidate()
        let defaults = UserDefaults.standard
        let canText = defaults.integer(forKey: "canText")
        if canText == 1 {
            let name = defaults.string(forKey: "name")
            let str = "\(name!) has NOT completed task: \(item!.itemTitle)."
            sendText(text: str)
        }
        else{
            if isLastTime == true{
                performSegue(withIdentifier: "surveyToCongrats", sender: self)
            }
            else{
                performSegue(withIdentifier: "unfinishedTask", sender: self)
            }
        }
    }
}
