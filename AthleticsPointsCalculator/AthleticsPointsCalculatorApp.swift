//
//  AthleticsPointsCalculatorApp.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 12/3/21.
//

import SwiftUI

@main
struct AthleticsPointsCalculatorApp: App {
    
//    let persistenceController = PersistenceController.shared //I dont need this because im creating my own container to do core data stuff in the view model

    @StateObject var mainViewModel:MainViewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext) //same as above
                .environmentObject(mainViewModel)
        }
    }
}
