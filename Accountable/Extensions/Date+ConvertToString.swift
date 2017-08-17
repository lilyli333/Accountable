//
//  Date+ConvertToString.swift
//  Accountable
//
//  Created by Lily Li on 7/14/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation

import Foundation

extension Date {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
}

extension NSDate {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: (self as Date), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
}
