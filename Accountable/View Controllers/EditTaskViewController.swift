//
//  EditTaskViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/21/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController {
    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var itemsListTableViwe: UITableView!
    
    var task: Task?
    var items = [Item]()
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let vc = presentingViewController!
        let pinVC = vc.presentingViewController!
        pinVC.dismiss(animated: false) {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func backgroundTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        items = CoreDataHelper.getItemsArray(task: task!)
        phoneNumberTextField.text = ("\(task!.phoneNumber)")
        taskNameTextField.text = task!.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        task?.setValue(phoneNumberTextField.text!, forKey: "phoneNumber")
        task?.setValue(taskNameTextField.text!, forKey: "title")
        task?.setValue(Date(), forKey: "modificationTime")
        
        for i in items {
            i.task = task!
            CoreDataHelper.saveToCoreData()
            
        }
        
        print(CoreDataHelper.getItemsArray(task: task!))
        
        let vc = presentingViewController!
        let pinVC = vc.presentingViewController!
        pinVC.dismiss(animated: false) {
            vc.dismiss(animated: true, completion: nil)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumberTextField.text = ("\(task!.phoneNumber)")
        taskNameTextField.text = task!.title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewItem" {
            let itemViewController = segue.destination as! ItemViewController
            let indexPath = itemsListTableViwe.indexPathForSelectedRow!
            let item = items[indexPath.row]
            itemViewController.item = item
            itemViewController.itemnum = indexPath.row + 1
        }
            //        else if segue.identifier == "pinToSaveTask" {
            //            let inputPinViewController = segue.destination as! InputPinViewController
            //            inputPinViewController.fromSB = .saveTask
            //            inputPinViewController.task = task!
            //            inputPinViewController.items = items
            //            inputPinViewController.taskName = taskNameTextField.text!
            //            inputPinViewController.phoneNumber = phoneNumberTextField.text!
            //            self.dismiss(animated: false, completion: nil)
            //        }
        else if segue.identifier == "addNewItem" {
            let itemViewController = segue.destination as! ItemViewController
            task?.setValue(phoneNumberTextField.text!, forKey: "phoneNumber")
            task?.setValue(taskNameTextField.text!, forKey: "title")
            itemViewController.itemnum = items.count + 1
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
}

extension EditTaskViewController: UITableViewDataSource {
    
    //    //for deleting a cell of item UNCOMMENT LATERRRRRRRR
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && items.count > 1 {
            let deleteItem: Item? = items[indexPath.row]
            items.remove(at: indexPath.row)
            
            if deleteItem != nil {
                CoreDataHelper.deleteItem(item: deleteItem!, task: task!)
                CoreDataHelper.saveToCoreData()
            }
            itemsListTableViwe.reloadData()
        }
        else{
            let alertController = UIAlertController(title: "cannot delete item", message:
                "there has to be 1+ item in task!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //items = CoreDataHelper.getItemsArray(task: task!)
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
    
    
    func getItemCell() -> ItemTableViewCell{
        let indexPath = IndexPath(row:items.count, section: 0)
        let cell = itemsListTableViwe.cellForRow(at:indexPath) as! ItemTableViewCell
        return cell
    }
}

extension EditTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ItemTableViewCell.height
    }
}
