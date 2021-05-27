//
//  CurrentTabKey.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 25/5/21.
//

import SwiftUI

struct CurrentTabKey: EnvironmentKey {
    static var defaultValue: Binding<ContentView.TabOptions> = .constant(.eventSelector)
}
