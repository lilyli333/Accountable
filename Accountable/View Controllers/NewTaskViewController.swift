//
//  NewTaskViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/21/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController {
    
    @IBAction func addItemTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addNewItem", sender: self)
    }
    
    @IBAction func unwindSegue(for segue: UIStoryboardSegue, sender: Any) {
    
    
    }
    
    
    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    var items = [Item]()
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let newtask = NSEntityDescription.entity(forEntityName: "Task", in: CoreDataHelper.managedContext)
        task = NSManagedObject(entity: newtask!, insertInto: CoreDataHelper.managedContext) as! Task

    
        task?.setValue("---", forKey: "title")
        task?.setValue(Date() as NSDate, forKey: "modificationTime")
        task?.setValue(0000000000, forKey: "phoneNumber")
        
        phoneNumberTextField.text = "\(task?.phoneNumber)"
        taskNameTextField.text = task?.title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItem" {
            let itemViewController = segue.destination as! NewItemViewController
            let indexPath = itemsTableView.indexPathForSelectedRow!
            let item = items[indexPath.row]
            itemViewController.item = item
        }
        else if segue.identifier == "saveTask" {
            let listViewController = segue.destination as! ListViewController
            let number = phoneNumberTextField.text!
            
            if let number = Int(number) {
//                if number < 1000000000 {
//                    let alertController = UIAlertController(title: "invalid phone number", message:
//                        "", preferredStyle: UIAlertControllerStyle.alert)
//                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//                    self.present(alertController, animated: true, completion: nil)
//                    return
//                }
//                else if taskNameTextField.text!.isEmpty{
//                    let alertController = UIAlertController(title: "cannot save task", message:
//                        "required field cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
//                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//                    self.present(alertController, animated: true, completion: nil)
//                    return
//                }
                task?.setValue(Date(), forKey: "modificationTime")
                task?.setValue(taskNameTextField.text, forKey: "title")
                task?.setValue(number, forKey: "phoneNumber")
                CoreDataHelper.saveToCoreData()
                print(task)
                listViewController.tasks.append(task!)
                listViewController.tasks = CoreDataHelper.retrieveTask()
                listViewController.tasksListTableView.reloadData()
                
            }
            else{
                let alertController = UIAlertController(title: "cannot save task", message:
                    "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        else if segue.identifier == "addNewItem" {
            print(taskNameTextField.text!)
            task?.setValue(taskNameTextField.text, forKey: "title")
            task?.setValue(Int(phoneNumberTextField.text!), forKey: "phoneNumber")
            print(task)
        }
    }
}

extension NewTaskViewController: UITableViewDataSource {
    
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
        print(items.count)
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        let row = indexPath.row
        cell.itemTimeLabel.text = "\(ToStringHelper.toString(time: TimeInterval(items[row].itemTime)))"
        cell.itemTitleLabel.text = items[row].itemTitle
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension NewTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ItemTableViewCell.height
    }
}