//
//  User.swift
//  Accountable
//
//  Created by Lily Li on 7/24/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation

class User {
    static func setName (name: String){
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "name")
    }
    
    static func setPin (pin: Int){
        let defaults = UserDefaults.standard
        defaults.set(pin, forKey: "pin")
    }
    
    static func setText (num: Int) {
        let defaults = UserDefaults.standard
        defaults.set(num, forKey: "canText")
    }
    static func deviceCanSendText (bool: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(bool, forKey: "deviceText")
    }
    
    static func setTime(seconds: Double) {
        let defaults = UserDefaults.standard
        defaults.set(seconds, forKey: "restTime")

    }
}

