//
//  User.swift
//  Accountable
//
//  Created by Lily Li on 7/24/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation

class User: NSObject {
    let name: String
    let pin: Int
    
    init(name: String, pin: Int) {
        self.name = name
        self.pin = pin
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Constants.UserDefaults.name) as? String,
            let pin = aDecoder.decodeObject(forKey: Constants.UserDefaults.pin) as? Int
            else { return nil }
        self.name = name
        self.pin = pin
        
        super.init()
    }
    
    class func setName(_ name: String, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: name)
            
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.name)
        }
    }
    
    class func setPin(_ pin: Int, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: pin)
            
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.pin)
        }
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Constants.UserDefaults.name)
        aCoder.encode(pin, forKey: Constants.UserDefaults.pin)
    }
}

