//
//  EventGroupPointsHolder.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 20/6/21.
//

import SwiftUI

class EventGroupPointsHolder:ObservableObject {
    
//    @Published var numberOfPerformances = 0
    
    var eventGroup:EventGroup = EventGroup()
    
    @Published var selectedEventIndexesArray=[Int]()
    @Published var selectedAthleticsEvents=[AthleticsEvent]()

    @Published var eventPerformances=[String]()
    @Published var eventPerformancesPoints=[String]()

    @Published var eventPlacementPoints=[String]()
    
//    var totalPerformancePoints=[Int]()
    func getEventOfPerformanceNumber(perfNumber: Int) -> AthleticsEvent {
        return selectedAthleticsEvents[selectedEventIndexesArray[perfNumber]]
    }
    
    func getTotalPoints(performanceIndex: Int) -> String {
        return String((Int(eventPerformancesPoints[performanceIndex]) ?? 0) + (Int(eventPlacementPoints[performanceIndex]) ?? 0))
    }
    
    func getAverage() -> Int {
        let numberPerfs = eventGroup.sMinNumberPerformancesGroup
        var totalSum = 0
        for index in 0...eventPerformances.count-1 {
            totalSum = totalSum + (Int(eventPerformancesPoints[index]) ?? 0) + (Int(eventPlacementPoints[index]) ?? 0)
        }
        return totalSum/numberPerfs
    }
    
    func updateSelectedAthleticEvents(changeIndex: Int) {
        selectedAthleticsEvents[changeIndex] = eventGroup.getArrayOfAthleticEvents()[selectedEventIndexesArray[changeIndex]]
    }
    func resetEventGroupPointsHolderEventGroup(newEventGroup: EventGroup = EventGroup()) {
        
        selectedEventIndexesArray=[Int]()
        selectedAthleticsEvents=[AthleticsEvent]()
        eventPerformances=[String]()
        eventPerformancesPoints=[String]()
        eventPlacementPoints=[String]()
        
        self.eventGroup = newEventGroup
        
//        let count = 0...eventGroup.sMinNumberPerformancesGroup-1
        let count = 0...6

        for _ in count {
            selectedEventIndexesArray.append(0)
            selectedAthleticsEvents.append(eventGroup.sMainEvent)
            eventPerformances.append("0.0")
            eventPerformancesPoints.append("0")
            eventPlacementPoints.append("0")
        }
        
        print("event group change reset done, new in perfs: \(newEventGroup.sMinNumberPerformancesGroup)")
    }

}
