//
//  StringExtensions.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    func localized(arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
