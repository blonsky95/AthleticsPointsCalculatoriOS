//
//  EventGroupPointsHolder.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 20/6/21.
//

import SwiftUI

class EventGroupPointsHolder:ObservableObject {
        
    var eventGroup:EventGroup = EventGroup()
    var performanceTitle: String = ""
    
    @Published var selectedEventIndexesArray=[Int]()
    @Published var selectedAthleticsEvents=[AthleticsEvent]()

    @Published var eventPerformances=[String]()
    @Published var eventPerformancesPoints=[String]()

    @Published var eventPlacementPoints=[String]()
    
    @Published var windReadings=[String]()
    @Published var windPointsModifications=[String]()

    
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
        windReadings=[String]()
        windPointsModifications=[String]()
        
        self.eventGroup = newEventGroup
        
        let count = 0...6

        for _ in count {
            selectedEventIndexesArray.append(0)
            selectedAthleticsEvents.append(eventGroup.sMainEvent)
            eventPerformances.append("0.0")
            eventPerformancesPoints.append("0")
            eventPlacementPoints.append("0")
            windReadings.append("0.0")
            windPointsModifications.append("0")
        }
    }
    
    func loadDataFromPerformance(pointsPerf: WAPointsPerformance){
        self.eventGroup = pointsPerf.wrappedEventGroup
        self.performanceTitle = pointsPerf.wrappedPerformanceTitle
        self.selectedAthleticsEvents = pointsPerf.wrappedSelectedAthleticsEvents
        self.eventPerformances = pointsPerf.wrappedEventPerformances
        self.eventPerformancesPoints = pointsPerf.wrappedEventPerformancePoints
        self.eventPlacementPoints = pointsPerf.wrappedEventPlacementPoints
        
        let arrayOfEvents = eventGroup.getArrayOfAthleticEvents()
        for event in selectedAthleticsEvents {
            self.selectedEventIndexesArray.append(arrayOfEvents.firstIndex{$0.sKey == event.sKey}!)
        }
        
//        return self
    }

}
