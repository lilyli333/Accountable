//
//  ItemTableViewCell.swift
//  Accountable
//
//  Created by Lily Li on 7/13/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController : UIViewController {
    @IBOutlet weak var itemTitleTextField: UITextField!
    
    @IBOutlet weak var itemDescriptionTextView: UITextView!
    
    @IBOutlet weak var itemTimePicker: UIDatePicker!
    
    var seconds: Double = 60.0
    var itemTitle: String?
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        self.view.endEditing(true)
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
        if let item = item{
            itemTitleTextField.text = item.itemTitle
            itemDescriptionTextView.text = item.itemDescription
            itemTimePicker.countDownDuration = item.itemTime
        }
        else{
            itemTitleTextField.text = ""
            itemDescriptionTextView.text = ""
            itemTimePicker.countDownDuration = 60
        }
    }
    @IBAction func itemTimePickerAction(_ sender: Any) {
        itemTimePicker.datePickerMode = UIDatePickerMode.countDownTimer
        seconds = itemTimePicker.countDownDuration
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let taskViewController = segue.destination as! EditTaskViewController
        if segue.identifier == "saveItem" {
            if let item = item{
                item.setValue(itemTitleTextField.text ?? "---", forKey: "itemTitle")
                item.setValue(itemDescriptionTextView.text ?? "", forKey: "itemDescription")
                item.setValue(itemTimePicker.countDownDuration, forKey: "itemTime")
                do{
                    try CoreDataHelper.managedContext.save()
                }
                catch{
                    print("error saving with add button press. \(error)")
                }
                taskViewController.itemsListTableViwe.reloadData()

            }
            else{
                let item = NSEntityDescription.entity(forEntityName: "Item", in: CoreDataHelper.managedContext)
                let newItem = NSManagedObject(entity: item!, insertInto: CoreDataHelper.managedContext) as! Item
                newItem.setValue(itemTitleTextField.text ?? "---", forKey: "itemTitle")
                newItem.setValue(itemDescriptionTextView.text ?? "", forKey: "itemDescription")
                newItem.setValue(itemTimePicker.countDownDuration, forKey: "itemTime")
                newItem.setValue(taskViewController.items.count, forKey: "order")
                newItem.task = taskViewController.task

                do{
                    try CoreDataHelper.managedContext.save()
                }
                catch{
                    print("error saving with add button press. \(error)")
                    taskViewController.items.append(newItem)
                }
                print(taskViewController.task)
                print("...")
                print(newItem)
                taskViewController.itemsListTableViwe.reloadData()
            }
        }
        else if segue.identifier == "cancelItem" {
        }
    }
}

extension ItemViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("started")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        title = itemTitleTextField.text!
        print("finished")
    }
}
