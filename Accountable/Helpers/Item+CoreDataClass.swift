//
//  Item+CoreDataClass.swift
//  Accountable
//
//  Created by Lily Li on 7/19/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    var itemObjTitle: String?
    var itemObjDesc: String?
    var itemObjTime: Double?
    var itemObjOrder: Int16?
}
