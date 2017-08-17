//
//  String+Utilities.swift
//  Accountable
//
//  Created by Lily Li on 8/1/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation

extension String {
    func removeWhiteSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
