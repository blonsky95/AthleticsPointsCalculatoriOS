//
//  EventGroup.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 17/6/21.
//

import Foundation

public class EventGroup : Codable, Equatable {
    
    //Here is the EventGroup class conforming to equatable, for this to work I need to provide a function so they can be equated ==
    public static func == (lhs: EventGroup, rhs: EventGroup) -> Bool {
        return lhs.sName == rhs.sName
    }
    
    static func needsWindParameter(eventGroupName: String) -> Bool {
        return (eventGroupName == "Men´s 100m" || eventGroupName == "Men´s 200m" || eventGroupName == "Men´s 110mH"  || eventGroupName == "Men´s Long Jump" || eventGroupName == "Men´s Triple Jump" || eventGroupName == "Women´s 100m" || eventGroupName == "Women´s 200m" || eventGroupName == "Women´s 100mH"  || eventGroupName == "Women´s Long Jump" || eventGroupName == "Women´s Triple Jump")
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

