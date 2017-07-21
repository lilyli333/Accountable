//
//  ListViewController.swift
//  Accountable
//
//  Created by Lily Li on 7/19/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
    
    @IBOutlet weak var tasksListTableView: UITableView!
    
    var tasks = [Task]() {
        didSet {
            tasksListTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        print("the list of tasks has been reloaded")
        super.viewDidLoad()
        tasksListTableView.reloadData()
        tasks = CoreDataHelper.retrieveTask()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let taskViewController = segue.destination as! TaskViewController
        
        if let identifier = segue.identifier {
            if identifier == "showTask" {
                print("Table view cell tapped")
                let indexPath = tasksListTableView.indexPathForSelectedRow!
                let task = tasks[indexPath.row]
                taskViewController.task = task
            }
        }
    }
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }


 }

extension ListViewController: UITableViewDataSource {
    
//    //FOR DELETING TASK, UNCOMMENT LATER
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //CoreDataHelper.deleteTask(task: tasks[indexPath.row])
            print(tasks.count)
            let deletingTask = tasks[indexPath.row]
            print("deleting:")
            print(deletingTask)
            CoreDataHelper.managedContext.delete(deletingTask)
            tasks = CoreDataHelper.retrieveTask()
            tasksListTableView.reloadData()
            print(tasks.count)
            print(CoreDataHelper.retrieveTask().count)
            CoreDataHelper.saveToCoreData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("the count of tasks is: \(tasks.count)")
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTasksTableViewCell", for: indexPath) as! ListTasksTableViewCell
        let task = tasks[indexPath.row]
        cell.taskTitleLabel.text = task.title
        cell.taskModificationTimeLabel.text = task.modificationTime.convertToString()
        return cell
    }
}

extension ListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ListTasksTableViewCell.height
    }
}

