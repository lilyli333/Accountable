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
    
    
    @IBAction func saveTaskButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "newTaskToPin", sender: self)
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    var items = [Item]()
    
    var task: Task?
    var phoneNumber: String?
    var taskName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumberTextField.text = phoneNumber ?? ""
        taskNameTextField.text = taskName ?? ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayNewItem" {
            let itemViewController = segue.destination as! NewItemViewController
            let indexPath = itemsTableView.indexPathForSelectedRow!
            let item = items[indexPath.row]
            itemViewController.item = item
        }
        else if segue.identifier == "newTaskToPin" {
            let num: Int? = Int(phoneNumberTextField.text!)
            let title = taskNameTextField.text!
            if num != nil && num!.digitCount == 10 && !title.isEmpty && items.count > 0{
                let inputPinViewController = segue.destination as! InputPinViewController
                inputPinViewController.fromSB = .saveNewTask
                //inputPinViewController.task = task!
                inputPinViewController.items = items
                inputPinViewController.taskName = taskNameTextField.text!
                inputPinViewController.phoneNumber = phoneNumberTextField.text!
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
            //            print(taskNameTextField.text!)
            let newItemViewController = segue.destination as! NewItemViewController
            ////            task?.title = taskNameTextField.text!
            ////            task?.phoneNumber = phoneNumberTextField.text! as! Int64
            ////            task?.modificationTime = Date() as NSDate
            //            task?.setValue(taskNameTextField.text, forKey: "title")
            //            task?.setValue(Int(phoneNumberTextField.text!) ?? "0000000000", forKey: "phoneNumber")
            //            task?.setValue(Date(), forKey: "modificationTime")
            //            CoreDataHelper.saveToCoreData()
            newItemViewController.taskName = taskNameTextField.text!
            newItemViewController.phoneNumber = phoneNumberTextField.text!
            newItemViewController.itemNum = items.count + 1
        }
    }
}

extension NewTaskViewController: UITableViewDataSource {
    
    //        //for deleting a cell of item UNCOMMENT LATERRRRRRRR
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        itemsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        let row = indexPath.row
        cell.itemTimeLabel.text = "\(ToStringHelper.toString(time: TimeInterval(items[row].itemObjTime!)))"
        cell.itemTitleLabel.text = items[row].itemObjTitle!
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
