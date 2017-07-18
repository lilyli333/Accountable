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
    
    var items = [Item]()
    var task: Task?
    
    var addBlankCell = false
    
    @IBAction func addItemAction(_ sender: UIButton) {
        if let task = task{
            addBlankCell = true
            itemsTableView.reloadData()
            
            let indexPath = IndexPath(row: items.count, section: 0)
            itemsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }
        else{
            let cell = getItemCell()
            //            let newItem = Item()
            //            newItem.itemTitle = cell.title ?? ""
            //            newItem.itemTime = cell.seconds ?? 60.0
            //            newItem.itemDescription = cell.itemDescriptionTextView.text ?? ""
            //            items.append(newItem)
            
            let item = NSEntityDescription.entity(forEntityName: "Item", in: CoreDataHelper.managedContext)
            let newItem = NSManagedObject(entity: item!, insertInto: CoreDataHelper.managedContext) as! Item
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
            
            task?.mutableSetValue(forKey: "items").add(newItem)
            
            
            itemsTableView.reloadData()
            let indexPath = IndexPath(row: items.count, section: 0)
            itemsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let task = task {
            taskTitle.text = task.title
            //items = task.items as Array
        } else {
            taskTitle.text = ""
            items = [Item]()
            
            let newtask = NSEntityDescription.entity(forEntityName: "Task", in: CoreDataHelper.managedContext)
            let newTask = NSManagedObject(entity: newtask!, insertInto: CoreDataHelper.managedContext) as! Task
            newTask.setValue(taskTitle.text as! NSString ??  "---", forKey: "title")
            newTask.setValue(Date() as NSDate, forKey: "modificationTime")
            self.task = newTask
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cancelTask" {
            print("the task was canceled!")
            
        }
        else if segue.identifier == "saveTask" {
            
            print("savinggggg")
            if addBlankCell == true{
                let cell = getItemCell()
                let item = NSEntityDescription.entity(forEntityName: "Item", in: CoreDataHelper.managedContext)
                let newItem = NSManagedObject(entity: item!, insertInto: CoreDataHelper.managedContext) as! Item
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
            else if task == nil{
                let cell = getItemCell()
                
                let item = NSEntityDescription.entity(forEntityName: "Item", in: CoreDataHelper.managedContext)
                let newItem = NSManagedObject(entity: item!, insertInto: CoreDataHelper.managedContext) as! Item
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
            
            //            for item in items {
            //                newTask.mutableSetValue(forKey: "items").add(item)
            //            }
            
            print(CoreDataHelper.retrieveTask())
            
            
            
            //            let newTask = self.task ?? CoreDataHelper.newTask()
            //
            //
            //            newTask.title = taskTitle.text ?? ""
            //            newTask.items = items
            //            newTask.modificationTime = Date() as NSDate
            //            CoreDataHelper.saveTask()
        }
    }
}


extension DisplayTaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && items.count > 1 {
            //items.remove(at: indexPath.row)
            let deleteItem = items[indexPath.row]
            task?.removeFromItems(deleteItem)
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
                    cell.itemTitleTextField.text = items[indexPath.row].itemTitle as! String ?? ""
                    cell.itemDescriptionTextView.text = items[indexPath.row].itemDescription as! String ?? ""
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
                cell.itemTitleTextField.text = items[indexPath.row].itemTitle as! String ?? ""
                cell.itemDescriptionTextView.text = items[indexPath.row].itemDescription as! String ?? ""
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
