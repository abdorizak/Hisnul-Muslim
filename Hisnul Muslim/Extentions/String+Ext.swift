//
//  String+Ext.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/19/23.
//

import Foundation

extension String {
    
    /// Custom Split function
    /// - Parameter speretors: as parameter it takes array of character
    /// - Returns: it returns an array of string
    func split(_ speretors: [Character]) -> [String] {
        var currentStr = self
        for speretor in speretors {
            currentStr = currentStr.replacingOccurrences(of: "\(speretor)", with: "|")
        }
        return currentStr.split(separator: "|").filter { !$0.isEmpty }.map { String($0) }
    }
    
    var isBlank: Bool { self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    var isNotBlank: Bool { !isBlank }
}
