//
//  ContentView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 16/4/21.
//

import SwiftUI

struct ContentView: View {
    
    enum TabOptions {
            case eventSelector
            case savedPerformances
        }
    
    @State private var selectedTab: TabOptions = .eventSelector

    let eventsDataObtainerAndHelper = EventsDataObtainerAndHelper()
    
    var body: some View {
        TabView (selection: $selectedTab){
            EventSelectorView()
                //.environmentObject(eventsDataObtainerAndHelper)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("New")
                }
                .tag(TabOptions.eventSelector)
                .environment(\.currentTab, $selectedTab)


            SavedPerformancesView()
//                .environmentObject(eventsDataObtainerAndHelper)
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Saved")
                }
                .tag(TabOptions.savedPerformances)

        }
        .animation(.easeInOut) // 2
        .transition(.slide) // 3
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
