//
//  EditMode-custom.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 4/5/21.
//

import SwiftUI

extension EditMode {
    
    var title: String {
        self == .active ? "Done" : "Edit"
    }

    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
