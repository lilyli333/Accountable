//
//  ListTasksViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/13/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import CoreData

class ListTasksViewController: UIViewController {
    
    @IBOutlet weak var listTasksTableView: UITableView!
    var tasks = [NSManagedObject]() as! [Task] {
        didSet {
            listTasksTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tasks = CoreDataHelper.retrieveTask()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "displayTask" {
                print("Table view cell tapped")
                let indexPath = listTasksTableView.indexPathForSelectedRow!
                let task = tasks[indexPath.row]
                print(task)
                print(tasks[indexPath.row])
                let displayTaskViewController = segue.destination as! DisplayTaskViewController
                displayTaskViewController.task = task
                
            } else if identifier == "addTask" {
            }
        }
    }
    
    @IBAction func unwindToListTaskViewController(_ segue: UIStoryboardSegue) {
        self.tasks = CoreDataHelper.retrieveTask()
    }
}

extension ListTasksViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataHelper.deleteTask(task: tasks[indexPath.row])
            tasks = CoreDataHelper.retrieveTask()
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTasksTableViewCell", for: indexPath) as! ListTasksTableViewCell
        let task = tasks[indexPath.row]
        cell.taskTitleLabel.text = task.title
        cell.taskModificationTimeLabel.text = task.modificationTime?.convertToString()
        return cell
    }
}

extension ListTasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ListTasksTableViewCell.height
    }
}




