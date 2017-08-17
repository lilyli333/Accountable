//
//  InputPinViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/26/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import CoreData

class InputPinViewController: UIViewController {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var pinInputTextField: UITextField!
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var fromSB: segues?
    var task: Task?
    var items = [Item]()
    var phoneNumber: String?
    var taskName: String?
    
    enum segues {
        case task //to edit task
        case timer
        case saveTask
        case saveNewTask
        case editSettings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinInputTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func textFieldChanged(_ sender: UITextField) {
        let arr = Array(pinInputTextField.text!.characters)
        
        if arr.count < 4{
            warningLabel.text = ""
            warningLabel.backgroundColor = ColorConversion.hexStringToUIColor(hex: "FF9966")
            warningLabel.layer.cornerRadius = 6
            
        }
        if arr.count == 4 {
            let number = Int(pinInputTextField.text!)
            let defaults = UserDefaults.standard
            let pin = defaults.integer(forKey: "pin")
            if number == pin{
                print("correct pin")
                if fromSB == .task {
                    performSegue(withIdentifier: "pinToEditTask", sender: self)
                }
                else if fromSB == .timer {
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                }
                else if fromSB == .saveTask {
                    performSegue(withIdentifier: "pinToSaveTask", sender: self)
                }
                else if fromSB == .saveNewTask {
                    //self.dismiss(animated: true, completion: {
                        performSegue(withIdentifier: "pinToTaskList", sender: self)
                    //})
                }
                else if fromSB == .editSettings {
                    performSegue(withIdentifier: "pinToChangePin", sender: self)
                }
                
            }
            else {
                pinInputTextField.text = ""
                firstLabel.text = "-"
                secondLabel.text = "-"
                thirdLabel.text = "-"
                fourthLabel.text = "-"
                self.reloadInputViews()
                warningLabel.text = "inccorect pin, please try again"
                warningLabel.textColor = ColorConversion.hexStringToUIColor(hex: "FAEBD7")
                warningLabel.layer.cornerRadius = 6

            }
            
        }
        
        if arr.count >= 1 {
            firstLabel.font = firstLabel.font.withSize(20)
            firstLabel.text = "⚪"
        } else {
            firstLabel.font = firstLabel.font.withSize(70)
            firstLabel.text = "-"
        }
        if arr.count >= 2 {
            
            secondLabel.font = secondLabel.font.withSize(20)
            secondLabel.text = "⚪"
        } else {
            secondLabel.font = firstLabel.font.withSize(70)
            secondLabel.text = "-"
        }
        
        if arr.count >= 3 {
            thirdLabel.font = thirdLabel.font.withSize(20)
            thirdLabel.text = "⚪"
        } else {
            thirdLabel.font = firstLabel.font.withSize(70)
            thirdLabel.text = "-"
        }
        
        if arr.count >= 4 {
            fourthLabel.font = fourthLabel.font.withSize(20)
            fourthLabel.text = "⚪"
        } else {
            fourthLabel.font = firstLabel.font.withSize(70)
            fourthLabel.text = "-"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pinToEditTask" {
            
            let editTaskViewController = segue.destination as! EditTaskViewController
            editTaskViewController.task = self.task!
            editTaskViewController.items = self.items
        }
        else if segue.identifier == "pinToSaveTask" {
            
            let newtask = NSEntityDescription.entity(forEntityName: "Task", in: CoreDataHelper.managedContext)
            task = NSManagedObject(entity: newtask!, insertInto: CoreDataHelper.managedContext) as! Task
            let listViewController = segue.destination as! TaskViewController
            let number = phoneNumber!
            
            if let number = Int(number) {
                if number.digitCount != 10 {
                    print(phoneNumber)
                    let alertController = UIAlertController(title: "invalid phone number", message:
                        "", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                else if taskName!.isEmpty{
                    let alertController = UIAlertController(title: "cannot save task", message:
                        "required field cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                task?.setValue(Date(), forKey: "modificationTime")
                task?.setValue(taskName!, forKey: "title")
                print(number)
                task?.setValue(phoneNumber!, forKey: "phoneNumber")
                
                CoreDataHelper.saveToCoreData()
                listViewController.task = task!
                listViewController.items = items
                //listViewController.listItemsTableView.reloadData()
            }
            else{
                let alertController = UIAlertController(title: "cannot save task", message:
                    "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        else if segue.identifier == "pinToTaskList" {
            let listViewController = segue.destination as! ListViewController
            let number = phoneNumber!
            
            let taskk = NSEntityDescription.entity(forEntityName: "Task", in: CoreDataHelper.managedContext)
            let newtask = NSManagedObject(entity: taskk!, insertInto: CoreDataHelper.managedContext) as! Task
            
            newtask.setValue(Date(), forKey: "modificationTime")
            newtask.setValue(taskName! ?? "---", forKey: "title")
            newtask.setValue(phoneNumber!, forKey: "phoneNumber")
            
            for i in items {
                let item = NSEntityDescription.entity(forEntityName: "Item", in: CoreDataHelper.managedContext)
                let newItem = NSManagedObject(entity: item!, insertInto: CoreDataHelper.managedContext) as! Item
                newItem.setValue(i.itemObjTitle, forKey: "itemTitle")
                newItem.setValue(i.itemObjDesc, forKey: "itemDescription")
                newItem.setValue(i.itemObjTime, forKey: "itemTime")
                newItem.setValue(i.itemObjOrder, forKey: "order")
                newItem.task = newtask
                CoreDataHelper.saveToCoreData()
            }
            
            listViewController.tasks.append(newtask)
            CoreDataHelper.saveToCoreData()
            listViewController.tasks = CoreDataHelper.retrieveTask()
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
