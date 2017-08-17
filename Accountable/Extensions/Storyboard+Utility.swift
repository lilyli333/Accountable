//
//  Storyboard+Utility.swift
//  Accountable
//
//  Created by Lily Li on 7/26/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum MGType: String {
        case main
        case namepinselect
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(type: MGType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: MGType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        
        return initialViewController
    }
}
