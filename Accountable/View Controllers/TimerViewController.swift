//
//  TimerViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/20/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    var items = [Item]()
    var task: Task?
    
    var seconds = 0
    var timer = Timer()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = task{
            seconds = getTime()
            runTimer()
        }
        else{
            let alertController = UIAlertController(title: "no task selected", message:
                "click OK to continue", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            alertController.dismiss(animated: true, completion: nil)
            
            
            performSegue(withIdentifier: "toTasks", sender: self)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    func updateTimer() {
        if getTime() == nil{
            let alertController = UIAlertController(title: "finished task", message:
                "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        else{
            if seconds < 1 {
                timer.invalidate()
                items.remove(at: 0)
                print(items.count)
                seconds = getTime()
                
                runTimer()
                listTableView.reloadData()
            } else {
                seconds -= 1
                timeLabel.text = ToStringHelper.timeString(time: TimeInterval(seconds))
            }
        }
    }
    func getTime() -> Int {
        return Int(items[0].itemTime)
    }
}

extension TimerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        let row = indexPath.row
        cell.itemTimeLabel.text = "\(ToStringHelper.timeString(time: TimeInterval(items[row].itemTime)))"
        cell.itemTitleLabel.text = items[row].itemTitle
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}

extension TimerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ItemTableViewCell.height
    }
}
