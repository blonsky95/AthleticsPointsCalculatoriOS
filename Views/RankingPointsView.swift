//
//  RankingPointsView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 16/6/21.
//

import SwiftUI

struct RankingPointsView: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    var eventGroupPointsHolder = EventGroupPointsHolder()
    @State var searchText = ""

    var body: some View {
        
        NavigationView{
            
            VStack{
                SearchBar(text: $searchText)
                    .padding(.top)
                    .onChange(of: searchText) { newValue in
                        mainViewModel.updatePerformancesQuery(searchText: newValue)
                    }
                List(mainViewModel.wAPointsPerformancesArray) { performance in
                    NavigationLink(destination: WAPointsCalculator(eventGroupPointsHolder: eventGroupPointsHolder)) {
                        PointsPerformanceListItemView(waPointsPerformance: performance)
                        }
                    }
                Spacer()
                NavigationLink(destination: WAPointsCalculator(eventGroupPointsHolder: eventGroupPointsHolder)) {
                    Text("New")
                        .padding()
                        .foregroundColor(.white)
                        .background(Capsule()
                                        .fill(Color.blue)
                                        .frame(minWidth: 100, minHeight: 50))
                        .padding()
                }
                
            }
            .navigationTitle("WA Ranking Points")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RankingPointsView_Previews: PreviewProvider {
    static var previews: some View {
        RankingPointsView()
    }
}


struct PointsPerformanceListItemView:View {
    
    let waPointsPerformance:WAPointsPerformance
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(waPointsPerformance.wrappedPerformanceTitle)
                Text(waPointsPerformance.wrappedEventGroup.sName)
            }
            Spacer()
            Text(waPointsPerformance.wrappedRankingScore)
        }
    }
}
