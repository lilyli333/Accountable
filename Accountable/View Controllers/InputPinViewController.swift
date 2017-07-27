//
//  InputPinViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/26/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

class InputPinViewController: UIViewController {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var pinInputTextField: UITextField!
    
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
            warningLabel.backgroundColor = UIColor(hexString: "#FF9966")
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
                    navigationController?.popToRootViewController(animated: true)
                }
                else if fromSB == .saveTask {
                    performSegue(withIdentifier: "pinToSaveTask", sender: self)
                }
                else if fromSB == .saveNewTask {
                    performSegue(withIdentifier: "pinToTaskList", sender: self)
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
                warningLabel.backgroundColor = UIColor(hexString: "#FFFFE0")
            }

        }
        
        if arr.count >= 1 {
            firstLabel.text = "⚪"
        } else {
            firstLabel.text = "-"
        }
        
        if arr.count >= 2 {
            secondLabel.text = "⚪"
        } else {
            secondLabel.text = "-"
        }
        
        if arr.count >= 3 {
            thirdLabel.text = "⚪"
        } else {
            thirdLabel.text = "-"
        }
        
        if arr.count >= 4 {
            fourthLabel.text = "⚪"
        } else {
            fourthLabel.text = "-"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pinToEditTask" {
            let editTaskViewController = segue.destination as! EditTaskViewController
            editTaskViewController.task = task!
            editTaskViewController.items = items
        }
        else if segue.identifier == "pinToSaveTask" {
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
            
            if let number = Int(number) {
                if number.digitCount != 10 {
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
                task?.setValue(taskName! ?? "---", forKey: "title")
                task?.setValue(phoneNumber!, forKey: "phoneNumber")
                listViewController.tasks.append(task!)
                print(task!)
                CoreDataHelper.saveToCoreData()
                print(task!)
                listViewController.tasks = CoreDataHelper.retrieveTask()
                
                print(task!)
                
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
        
}
