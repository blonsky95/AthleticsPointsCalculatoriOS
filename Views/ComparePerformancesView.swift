//
//  ComparePerformancesView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 7/5/21.
//

import SwiftUI

struct ComparePerformancesView: View {

    @Binding var athleticPointsEventPerformance1:AthleticsPointsEventPerformance
    @Binding var athleticPointsEventPerformance2:AthleticsPointsEventPerformance
        
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var eventsDataObtainerAndHelper: EventsDataObtainerAndHelper
    
    var body: some View {
        VStack {
            HStack{
            Spacer()
                Text("Event name")
                    .font(.title)
                    .padding(.bottom)
            Spacer()
            }
            
            HStack{
                VStack{
                    HStack{
                        Text("\(athleticPointsEventPerformance1.performanceTitle )")
                            .font(.title3)
                            .padding(.leading)
                        Spacer()
                        Text("\(athleticPointsEventPerformance2.performanceTitle )")
                            .font(.title3)
                            .padding(.trailing)
                    }
                    ForEach (0..<athleticPointsEventPerformance1.performancesArray.count) { i in
                        let sEvent1 = athleticPointsEventPerformance1.sEventsArray[i].sName
                        let sPerformance1 = "\(athleticPointsEventPerformance1.performancesArray[i])"
                        let sPoints1 = eventsDataObtainerAndHelper.getPoints(event: athleticPointsEventPerformance1.sEventsArray[i], performance: athleticPointsEventPerformance1.performancesArray[i])
                   
                        let sEvent2 = athleticPointsEventPerformance2.sEventsArray[i].sName
                        let sPerformance2 = "\(athleticPointsEventPerformance2.performancesArray[i])"
                        let sPoints2 = eventsDataObtainerAndHelper.getPoints(event: athleticPointsEventPerformance2.sEventsArray[i], performance: athleticPointsEventPerformance2.performancesArray[i])
                        
                        SingleEventComparer(event1: sEvent1,
                                            event2: sEvent2,
                                            performance1: sPerformance1,
                                            performance2: sPerformance2,
                                            points1: sPoints1,
                                            points2: sPoints2)
                        
                    }
                    Spacer()
                    HStack{
                        Text("Total")
                            .padding(.leading)
                        Spacer()
                        Text("Total")
                            .padding(.trailing)
                    }
                    HStack{
                        Text("\(athleticPointsEventPerformance1.totalPoints )")
                            .padding(.leading)
                        Spacer()
                        PointsDifferenceView(points1: athleticPointsEventPerformance1.totalPoints , points2: athleticPointsEventPerformance2.totalPoints )
                        Spacer()
                        Text("\(athleticPointsEventPerformance2.totalPoints )")
                            .padding(.trailing)
                    }.onAppear{
//                        print("Compare perf View - total points - perf 1: \(athleticPointsEventPerformance1.totalPoints)")
//                        print("Compare perf View - perf 2: \(athleticPointsEventPerformance2.totalPoints)")
                    }
                    
                }

            }
            Spacer()
            Button("Press to dismiss") {
                        presentationMode.wrappedValue.dismiss()
                    }
            
        }
        .padding()
    }

}

struct PointsDifferenceView:View {
    let points1:Int
    let points2:Int
    
    @State private var pointsDifference = ""
    @State private var textColor: Color = Color.blue

    var body: some View {
        Text("\(pointsDifference)")
            .foregroundColor(textColor)
            .onAppear{
//                print("Points difference view on appear points 1: \(points1) points 2: \(points2)")
                if points2-points1>=0{
                    textColor=Color.blue
                    pointsDifference="+\(points2-points1)"
                } else {
                    textColor=Color.red
                    pointsDifference="-\(abs(points2-points1))"

                }
            }
    }
    
    
}

struct SingleEventComparer:View {
    let event1:String
    let event2:String
    let performance1:String
    let performance2:String
    let points1:Int
    let points2:Int
    
    var body: some View {
        VStack{
            HStack{
                Text("\(event1)")
                Spacer()
                Text("\(event2)")
            }
            HStack{
                Text("\(performance1) ")
                Text("\(points1)")
                    .fontWeight(.bold)
                Spacer()
                PointsDifferenceView(points1: points1, points2: points2)
                Spacer()
                Text("\(performance2) ")
                Text("\(points2)")
                    .fontWeight(.bold)
                
            }
        }
        
    }
}

//struct ComparePerformancesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComparePerformancesView()
//    }
//}
