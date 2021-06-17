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
            case rankingPoints
        }
    
    @State private var selectedTab: TabOptions = .eventSelector
    
    var body: some View {
        TabView (selection: $selectedTab){
            EventSelectorView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("New")
                }
                .tag(TabOptions.eventSelector)
                .environment(\.currentTab, $selectedTab)


            SavedPerformancesView()
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Saved")
                }
                .tag(TabOptions.savedPerformances)
            
            RankingPointsView()
                .tabItem {
                    Image(systemName: "wonsign.square")
                    Text("WA")
                }
                .tag(TabOptions.rankingPoints)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
