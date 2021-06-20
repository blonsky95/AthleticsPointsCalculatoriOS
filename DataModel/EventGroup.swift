//
//  EventGroup.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 17/6/21.
//

import Foundation

class EventGroup : Codable, Equatable {
    
    //Here is the EventGroup class conforming to equatable, for this to work I need to provide a function so they can be equated ==
    static func == (lhs: EventGroup, rhs: EventGroup) -> Bool {
        return lhs.sName == rhs.sName
    }
    
    let sName:String
    let sMainEvent:AthleticsEvent
    let sSimilarEvents:[AthleticsEvent]
    let sSex:String
    let sMinNumberPerformancesGroup:Int
    let sMinNumberPerformancesMainEvent:Int

    init () {
        self.sName="test"
        self.sMainEvent=AthleticsEvent.getExample()
        self.sSimilarEvents = [AthleticsEvent.getExample(), AthleticsEvent.getExample()]
        self.sSex="male"
        self.sMinNumberPerformancesGroup=5
        self.sMinNumberPerformancesMainEvent=3
    }
    
    func getArrayOfAthleticEvents() -> [AthleticsEvent] {
        var returnArray = self.sSimilarEvents
        returnArray.insert(self.sMainEvent, at: 0)
//        print("array of athletics events: \(returnArray.count)")
        return returnArray
    }
    
    func getListOfSimilarEvents() -> String {
        var string = ""
        if sSimilarEvents.isEmpty {
            return "None"
        } else {
            for event in sSimilarEvents {
                
                string=string+event.getIndoorDisplayName()+" "
            }
        }
        
        return string
    }
    
    
}

