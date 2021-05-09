//
//  View-Hidden.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 6/5/21.
//

import SwiftUI

extension View {
    
    //unused
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
