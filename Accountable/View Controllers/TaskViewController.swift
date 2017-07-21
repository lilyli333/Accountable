//
//  TaskViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/19/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var numberItemsLabel: UILabel!
    
    
    @IBOutlet weak var listItemsTableView: UITableView!
    
    var task: Task?
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = CoreDataHelper.getItemsArray(task: task!)
        phoneNumberLabel.text = ("\(task!.phoneNumber)")
        taskNameLabel.text = task!.title
        numberItemsLabel.text = "items (\(items.count))"
    }
    
    @IBAction func startTaskButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "startTask", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startTask" {
            let timerViewController = segue.destination as! TimerViewController
            timerViewController.task = task
            timerViewController.items = items
        }
        else if segue.identifier == "editTask" {
            let editTaskViewController = segue.destination as! EditTaskViewController
            editTaskViewController.task = task!
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
}

extension TaskViewController: UITableViewDataSource {
    
    //    //for deleting a cell of item UNCOMMENT LATERRRRRRRR
    //        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //            if editingStyle == .delete && items.count > 1 {
    //                //items.remove(at: indexPath.row)
    //                let deleteItem = items[indexPath.row]
    //                task?.removeFromItems(deleteItem)
    //                CoreDataHelper.saveToCoreData()
    //            }
    //            else{
    //                let alertController = UIAlertController(title: "cannot delete item", message:
    //                    "there has to be 1+ item in task!", preferredStyle: UIAlertControllerStyle.alert)
    //                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
    //
    //                self.present(alertController, animated: true, completion: nil)
    //            }
    //        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items = CoreDataHelper.getItemsArray(task: task!)
        numberItemsLabel.text = "items (\(items.count))"
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! DisplayItemsTableViewCell
        let row = indexPath.row
        cell.durationLabel.text = "\(ToStringHelper.toString(time: TimeInterval(items[row].itemTime)))"
        cell.itemTitleLabel.text = items[row].itemTitle
        cell.itemDescriptionTextView.text = items[row].itemDescription
        print("printing")
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DisplayItemsTableViewCell.height
    }
}
