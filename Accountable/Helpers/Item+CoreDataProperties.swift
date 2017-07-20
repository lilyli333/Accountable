//
//  Item+CoreDataProperties.swift
//  Accountable
//
//  Created by Lily Li on 7/19/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var itemTitle: String
    @NSManaged public var itemDescription: String
    @NSManaged public var itemTime: Double
    @NSManaged public var order: Int16
    @NSManaged public var task: Task?

}
