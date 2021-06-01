//
//  AthleticsPointsCalculatorApp.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 12/3/21.
//

import SwiftUI

@main
struct AthleticsPointsCalculatorApp: App {
    
//    let persistenceController = PersistenceController.shared

    @StateObject var mainViewModel:MainViewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(mainViewModel)
        }
    }
}
