//
//  SingleEventScoreView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 15/3/21.
//

import SwiftUI

struct SingleEventScoreView:View {
    
    let athleticsEvent:AthleticsEvent //the event
    let performance:Double //performance, 0.0 if not a saved performance
    let eventIndex:Int //which event of the events array is it
    
    @State private var eventPerformance:String = ""
    @State private var eventPoints = 0

    @EnvironmentObject var mainViewModel : MainViewModel

        var body: some View {
        HStack {
            Text(athleticsEvent.sName)
            DynamicPerformanceCollector(athleticsEvent: athleticsEvent, eventPerformance: $eventPerformance)
                .onChange(of: eventPerformance) { newValue in
                    eventPoints=mainViewModel.getPointsForEvent(event: athleticsEvent, perf: eventPerformance.doubleValue)
                    mainViewModel.updateEventPointsHolder(eventIndex: eventIndex, eventPoints: eventPoints, eventPerf: eventPerformance)
                }
            Spacer()
            Text("\(eventPoints)")
        }.onAppear(perform: loadData)
        
    }
    
    func loadData() {
        eventPerformance = String(performance)
    }

}

//struct SingleEventScoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let eventsDataObtainerAndHelper = EventsDataObtainerAndHelper()
//        let eventPointsHolder=EventPointsHolder()
//        
//        SingleEventScoreView(athleticsEvent: eventsDataObtainerAndHelper.athleticsEventsSearcher["1500m_m"]!, performance: 0.1,
//                             eventIndex: 0, eventPointsHolder: eventPointsHolder)
//    }
//}
