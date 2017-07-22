//
//  NewItemViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/21/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import CoreData

class NewItemViewController : UIViewController {
    
    @IBOutlet weak var itemTitleTextField: UITextField!
    
    @IBOutlet weak var itemDescriptionTextView: UITextView!
    
    @IBOutlet weak var itemTimePicker: UIDatePicker!
    
    @IBOutlet weak var itemNumLabel: UILabel!
    var seconds: Double = 60.0
    var itemTitle: String?
    
    var item: Item?
    var itemNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //tap gesture recognize
    //dismiss keyboard func
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textViewShouldReturn(textField: UITextView) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemTitleTextField.text = item?.itemTitle ?? ""
        itemDescriptionTextView.text = item?.itemDescription ?? ""
        itemTimePicker.countDownDuration = item?.itemTime ?? 60
        itemNumLabel.text = "item #\(itemNum)"
    }
    @IBAction func itemTimePickerAction(_ sender: Any) {
        itemTimePicker.datePickerMode = UIDatePickerMode.countDownTimer
        seconds = itemTimePicker.countDownDuration
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveNewItem" {
            if let item = item{
                let taskViewController = segue.destination as! NewTaskViewController
                item.setValue(itemTitleTextField.text ?? "---", forKey: "itemTitle")
                item.setValue(itemDescriptionTextView.text ?? "", forKey: "itemDescription")
                item.setValue(itemTimePicker.countDownDuration, forKey: "itemTime")
                item.setValue(taskViewController.items.count ?? 0, forKey: "order")
                CoreDataHelper.saveToCoreData()

                taskViewController.itemsTableView.reloadData()
            }
            else{
            let taskViewController = segue.destination as! NewTaskViewController
            let item = NSEntityDescription.entity(forEntityName: "Item", in: CoreDataHelper.managedContext)
            let newItem = NSManagedObject(entity: item!, insertInto: CoreDataHelper.managedContext) as! Item
            newItem.setValue(itemTitleTextField.text ?? "---", forKey: "itemTitle")
            newItem.setValue(itemDescriptionTextView.text ?? "", forKey: "itemDescription")
            newItem.setValue(itemTimePicker.countDownDuration, forKey: "itemTime")
            newItem.setValue(taskViewController.items.count ?? 0, forKey: "order")
            newItem.task = taskViewController.task!
                CoreDataHelper.saveToCoreData()

            print(newItem)
            print(taskViewController.task)
            taskViewController.items.append(newItem)
            taskViewController.itemsTableView.reloadData()
            }
        }
        else if segue.identifier == "cancelItem" {
        }
    }

//    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
//        if segue.identifier == "saveNewItem" {
//            let taskViewController = segue.destination as! NewTaskViewController
//            let item = NSEntityDescription.entity(forEntityName: "Item", in: CoreDataHelper.managedContext)
//            let newItem = NSManagedObject(entity: item!, insertInto: CoreDataHelper.managedContext) as! Item
//            newItem.setValue(itemTitleTextField.text ?? "---", forKey: "itemTitle")
//            newItem.setValue(itemDescriptionTextView.text ?? "", forKey: "itemDescription")
//            newItem.setValue(itemTimePicker.countDownDuration, forKey: "itemTime")
//            newItem.setValue(taskViewController.items.count, forKey: "order")
//            newItem.task = taskViewController.task
//            
//            CoreDataHelper.saveToCoreData()
//            
//            taskViewController.items.append(newItem)
//            taskViewController.itemsTableView.reloadData()
//        }
//        else if segue.identifier == "cancelNewItem" {
//            let destinationVC = segue.destination as! NewTaskViewController
//            
//        }
//
//    }
}

extension NewItemViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("started")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        title = itemTitleTextField.text!
        print("finished")
    }
}
