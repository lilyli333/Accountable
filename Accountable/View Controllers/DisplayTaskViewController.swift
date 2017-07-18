//
//  DisplayTaskViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/13/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import CoreData

class DisplayTaskViewController: UIViewController {
    
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemsTableView: UITableView!
    

    var items = [NSManagedObject]() as! [Item]
    var task: Task?
    //let encodedData = NSKeyedArchiver.archivedData(withRootObject: task) as! NSCoder

    
    var addBlankCell = false
    
    @IBAction func addItemAction(_ sender: UIButton) {
        if let task = task{
            addBlankCell = true
            itemsTableView.reloadData()
            
            let indexPath = IndexPath(row: items.count, section: 0)
            itemsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }
        else{
            let item = NSEntityDescription.entity(forEntityName: "Item", in: CoreDataHelper.managedContext)
            let newItem = NSManagedObject(entity: item!, insertInto: CoreDataHelper.managedContext) as! Item
            let cell = getItemCell()
            newItem.setValue(cell.title! as NSString ?? "", forKey: "itemTitle")
            newItem.setValue(cell.itemDescriptionTextView.text as NSString  ?? "", forKey: "itemDescription")
            newItem.setValue(cell.seconds as Double ?? 60.0, forKey: "itemTime")
            do{
                try CoreDataHelper.managedContext.save()
                items.append(newItem)
            }
            catch{
                print("count not save. \(error)")
            }
            itemsTableView.reloadData()
            let indexPath = IndexPath(row: items.count, section: 0)
            itemsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
            do {
                let results = try CoreDataHelper.managedContext.fetch(fetchRequest)
                print("results:")
                print(results)
            } catch let error as NSError {
                print("Could not fetch \(error)")
            }
            
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let task = task {
//            taskTitle.text = task.title
//            items = task.items
//        } else {
//            taskTitle.text = ""
//            items = [Item]()
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let listTasksTableViewController = segue.destination as! ListTasksViewController
        
        if let identifier = segue.identifier {
            if identifier == "cancelTask" {
                print("the task was canceled!")
                
            }
            else if segue.identifier == "saveTask" {
                let item = NSEntityDescription.entity(forEntityName: "Item", in: CoreDataHelper.managedContext)
                let newItem = NSManagedObject(entity: item!, insertInto: CoreDataHelper.managedContext) as! Item
                print("savinggggg")
                if addBlankCell == true{
                    let cell = getItemCell()
                    newItem.setValue(cell.title! as NSString ?? "", forKey: "itemTitle")
                    newItem.setValue(cell.itemDescriptionTextView.text as NSString  ?? "", forKey: "itemDescription")
                    newItem.setValue(cell.seconds as Double ?? 60.0, forKey: "itemTime")
                    do{
                        try CoreDataHelper.managedContext.save()
                        items.append(newItem)
                    }
                    catch{
                        print("count not save. \(error)")
                    }                }
                else if task == nil{
                    let cell = getItemCell()
                    newItem.setValue(cell.title! as NSString ?? "", forKey: "itemTitle")
                    newItem.setValue(cell.itemDescriptionTextView.text as NSString  ?? "", forKey: "itemDescription")
                    newItem.setValue(cell.seconds as Double ?? 60.0, forKey: "itemTime")

                    do{
                        try CoreDataHelper.managedContext.save()
                        items.append(newItem)
                    }
                    catch{
                        print("count not save. \(error)")
                    }
                }
//                                let newTask = Task()
//                                newTask.title = taskTitle.text ?? ""
//                                newTask.items = items
//                                newTask.modificationTime = Date() as NSDate
//                                listTasksTableViewController.tasks.append(newTask)
                
                
                let newtask = self.task ?? CoreDataHelper.newTask()
                newtask.title = taskTitle.text ?? ""
//                newtask.items = items
                newtask.modificationTime = Date() as NSDate
                CoreDataHelper.saveTask()
                
            }
        }
    }
}


extension DisplayTaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && items.count > 1 {
            items.remove(at: indexPath.row)
        }
        else{
            let alertController = UIAlertController(title: "cannot delete item", message:
                "there has to be 1+ item in task!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let task = task {
            if addBlankCell == true{
                print("adding one extra cell")
                return items.count + 1
            }
            else{
                return items.count
            }
        }
        else{
            return items.count + 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let task = task{
            if addBlankCell == true{
                if indexPath.row < items.count{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
                    cell.itemTitleTextField.text = items[indexPath.row].itemTitle ?? ""
                    cell.itemDescriptionTextView.text = items[indexPath.row].itemDescription ?? ""
                    cell.itemTimePicker.countDownDuration = items[indexPath.row].itemTime ?? 60.0
                    cell.itemTitleTextField.delegate = cell
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
                    cell.itemTitleTextField.delegate = cell
                    return cell
                }
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
                cell.itemTitleTextField.text = items[indexPath.row].itemTitle ?? ""
                cell.itemDescriptionTextView.text = items[indexPath.row].itemDescription ?? ""
                cell.itemTimePicker.countDownDuration = items[indexPath.row].itemTime ?? 60.0
                cell.itemTitleTextField.delegate = cell
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
            cell.itemTitleTextField.delegate = cell
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func getItemCell() -> ItemTableViewCell{
        let indexPath = IndexPath(row:items.count, section: 0)
        let cell = itemsTableView.cellForRow(at:indexPath) as! ItemTableViewCell
        return cell
    }
}

extension DisplayTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ItemTableViewCell.height
    }
}
