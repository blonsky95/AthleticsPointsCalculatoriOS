//
//  String-NumberFormatter.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 2/5/21.
//

import Foundation

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
    
    func trimSpace() -> String {
            return self.trimmingCharacters(in: .whitespacesAndNewlines)
        }
}
