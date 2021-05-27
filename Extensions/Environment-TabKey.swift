//
//  Environment-TabKey.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 25/5/21.
//

import SwiftUI

extension EnvironmentValues {
    var currentTab: Binding<ContentView.TabOptions> {
        get { self[CurrentTabKey.self] }
        set { self[CurrentTabKey.self] = newValue }
    }
}
