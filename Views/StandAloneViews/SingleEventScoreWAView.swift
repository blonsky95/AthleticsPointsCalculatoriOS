//
//  SingleEventScoreWAView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 23/6/21.
//

import SwiftUI

struct SingleEventScoreWAView:View {

    let performanceIndex:Int
    @ObservedObject var eventGroupPointsHolder:EventGroupPointsHolder

    @EnvironmentObject var mainViewModel : MainViewModel
    
    var body: some View {
        HStack{
            SecondsMinutesHoursCollector(athleticsEvent: eventGroupPointsHolder.getEventOfPerformanceNumber(perfNumber: performanceIndex), totalTime: $eventGroupPointsHolder.eventPerformances[performanceIndex])
                .onChange(of: eventGroupPointsHolder.eventPerformances[performanceIndex]) { newValue in
                    updatePoints()
                }

            Text("\(eventGroupPointsHolder.eventPerformancesPoints[performanceIndex])")
                .onChange(of: eventGroupPointsHolder.selectedEventIndexesArray[performanceIndex]) {newValue in
                    updatePoints()
                }
        }
    }
    
    func updatePoints() {
        eventGroupPointsHolder.eventPerformancesPoints[performanceIndex]=mainViewModel.getStringPointsForEvent(event: eventGroupPointsHolder.eventGroup.getArrayOfAthleticEvents()[eventGroupPointsHolder.selectedEventIndexesArray[performanceIndex]], perf: eventGroupPointsHolder.eventPerformances[performanceIndex].doubleValue)
    }
}



//struct SingleEventScoreWAView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleEventScoreWAView()
//    }
//}
