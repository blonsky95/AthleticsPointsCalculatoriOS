//
//  RankingPointsView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 16/6/21.
//

import SwiftUI

struct RankingPointsView: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @State var searchText = ""

    var body: some View {
        
        NavigationView{
            VStack{
                SearchBar(text: $searchText)
                    .padding(.top)
                    .onChange(of: searchText) { newValue in
                        mainViewModel.updatePerformancesQuery(searchText: newValue)
                    }

                List {
                    ForEach (mainViewModel.wAPointsPerformancesArray) { performance in
                        NavigationLink(destination: WAPointsCalculator(isLoadingPerformance: true, pWAPointsPerformance: performance)) {
//                            PointsPerformanceListItemView(waPointsPerformance: performance)
                            HStack{
                                VStack(alignment: .leading){
                                    Text(performance.wrappedPerformanceTitle)
                                    Text(performance.wrappedEventGroup.sName)
                                }
                                Spacer()
                                Text(performance.wrappedRankingScore)
                            }
                        }
                    }
                    .onDelete(perform: mainViewModel.deletePointsPerformance)
                }

                Spacer()
                NavigationLink(destination: WAPointsCalculator(isLoadingPerformance: false)) {
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


//struct PointsPerformanceListItemView:View {
//    
//    var waPointsPerformance:WAPointsPerformance
//    
//    var body: some View {
//        HStack{
//            VStack(alignment: .leading){
//                Text(waPointsPerformance.wrappedPerformanceTitle)
//                Text(waPointsPerformance.wrappedEventGroup.sName)
//            }
//            Spacer()
//            Text(waPointsPerformance.wrappedRankingScore)
//        }
//    }
//}
