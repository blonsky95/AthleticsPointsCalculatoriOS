//
//  ContentView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 16/4/21.
//

import SwiftUI

struct ContentView: View {
    
    let eventsDataObtainerAndHelper = EventsDataObtainerAndHelper()

    var body: some View {
        TabView {
            EventSelectorView().environmentObject(eventsDataObtainerAndHelper)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("New")
                }
            SavedPerformancesView().environmentObject(eventsDataObtainerAndHelper)
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Saved")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
