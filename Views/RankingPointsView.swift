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
                        //                        mainViewModel.updateQuery(searchText: newValue)
                    }
                Spacer()
                NavigationLink(destination: WAPointsCalculator()) {
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