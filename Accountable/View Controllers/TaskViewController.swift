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
    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var itemsListTableViwe: UITableView!
    
    var task: Task?
    var items = [Item]()
    
    var isNewTask: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = getItemsArray(task: task!)
        phoneNumberTextField.text = ("\(task!.phoneNumber)")
        taskNameTextField.text = task!.title
        if task!.phoneNumber == 0{
            isNewTask = true
        }
    }
    
    public func getItemsArray(task: Task)-> [Item] {
        let allItems = task.items.sortedArray(using: [NSSortDescriptor(key: "order", ascending: true, selector: #selector(NSNumber.compare(_:)))]) as! [Item]
        print(allItems)
        return allItems
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItem" {
            let itemViewController = segue.destination as! ItemViewController
            let indexPath = itemsListTableViwe.indexPathForSelectedRow!
            let item = items[indexPath.row]
            itemViewController.item = item
        }
        else if segue.identifier == "saveTask" {
            let listViewController = segue.destination as! ListViewController
            let number = phoneNumberTextField.text!
            
            if let number = Int(number) {
                if number < 1000000000 {
                    let alertController = UIAlertController(title: "invalid phone number", message:
                        "", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                else if taskNameTextField.text!.isEmpty{
                    let alertController = UIAlertController(title: "cannot save task", message:
                        "required field cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                task?.setValue(Date(), forKey: "modificationTime")
                task?.setValue(taskNameTextField.text, forKey: "title")
                print(number)
                task?.setValue(number, forKey: "phoneNumber")
                do{
                    try CoreDataHelper.managedContext.save()
                }
                catch{
                    print("error saving with add button press. \(error)")
                }
                print("saving the task:")
                listViewController.tasksListTableView.reloadData()
                if isNewTask == false {
                    listViewController.tasks.append(task!)
                    listViewController.tasksListTableView.reloadData()
                }

            }
            else{
                let alertController = UIAlertController(title: "cannot save task", message:
                    "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
}

extension TaskViewController: UITableViewDataSource {
    
    //for deleting a cell of item UNCOMMENT LATERRRRRRRR
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete && items.count > 1 {
    //            //items.remove(at: indexPath.row)
    //            let deleteItem = items[indexPath.row]
    //            task?.removeFromItems(deleteItem)
    //        }
    //        else{
    //            let alertController = UIAlertController(title: "cannot delete item", message:
    //                "there has to be 1+ item in task!", preferredStyle: UIAlertControllerStyle.alert)
    //            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
    //
    //            self.present(alertController, animated: true, completion: nil)
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items = getItemsArray(task: task!)
        print(items.count)
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        let row = indexPath.row
        cell.itemTimeLabel.text = "\(items[row].itemTime) seconds"
        cell.itemTitleLabel.text = items[row].itemTitle
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func getItemCell() -> ItemTableViewCell{
        let indexPath = IndexPath(row:items.count, section: 0)
        let cell = itemsListTableViwe.cellForRow(at:indexPath) as! ItemTableViewCell
        return cell
    }
}

extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ItemTableViewCell.height
    }
}
