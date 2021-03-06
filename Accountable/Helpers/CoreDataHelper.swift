//
//  CoreDataHelper.swift
//  Accountable
//
//  Created by Lily Li on 7/17/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import CoreData
import UIKit

class CoreDataHelper {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    //    static func newTask() -> Task {
    //        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managedContext) as! Task
    //        return task
    //    }
    
    //    static func newItem() -> Item {
    //        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedContext) as! Item
    //        return item
    //    }
    
    //
    static func saveToCoreData() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    //
    //    static func saveItem() {
    //        do {
    //            try managedContext.save()
    //        } catch let error as NSError {
    //            print("Could not save \(error)")
    //        }
    //    }
    //
    //    static func deleteItem(item: Item) {
    //        managedContext.delete(item)
    //        saveTask()
    //    }
    
    
    
    static func deleteTask(task: Task) {
        managedContext.delete(task)
    }
    static func deleteItems(items: [Item]) {
        for item in items{
            managedContext.delete(item)
        }
    }
    static func deleteItem(item: Item, task: Task) {
        managedContext.delete(item)
        task.removeFromItems(item)
        
    }
    static func retrieveTask() -> [Task] {
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results.sorted(by: { $0.modificationTime.compare($1.modificationTime as Date) == .orderedDescending})
            //return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    static public func getItemsArray(task: Task)-> [Item] {
        let allItems = task.items.sortedArray(using: [NSSortDescriptor(key: "order", ascending: true, selector: #selector(NSNumber.compare(_:)))]) as! [Item]
        return allItems
    }
    
    //    static func retrieveItem() ->  [Item] {
    //        let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
    //        do {
    //            let results = try managedContext.fetch(fetchRequest)
    //            return results
    //        } catch let error as NSError {
    //            print("Could not fetch \(error)")
    //        }
    //        return []
    //    }
}
//extension Task {
//    var items: [Item] {
//        get {
//            return itemsArray as? Array<Item> ?? []
//        }
//        set {
//            itemsArray = newValue as NSArray
//        }
//    }
//}
//


