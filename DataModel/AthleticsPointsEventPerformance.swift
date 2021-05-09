//
//  AthleticsPointsEventPerformance.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 23/3/21.
//

import SwiftUI


//is a subclass of AthleticsPointsEvent, as it contains extra info:
// - a performanceTitle e.g. Tallin 2018 Decathlon (sName of parent class would be Heptathlon or Decathlon, not user picked)
// - performances array - contains all the performances, e.g. 11.12, 6.55, 13.11
// - total points - e.g. 5666 points


//For now this class exists here, and is replicated as a Core Data entity with the name "UserSavedPerformance" - ideally they should be recycled as one, can it be done?
class AthleticsPointsEventPerformance:AthleticsPointsEvent  {

    var performanceID = "id_unknown"
    var performanceTitle = "Untitled"
    var performancesArray=[Double]()
    var totalPoints = 0
    
    init(athleticsPointsEvent: AthleticsPointsEvent) {
        super.init(name: athleticsPointsEvent.sEventName, events: athleticsPointsEvent.sEventsArray, days: athleticsPointsEvent.sNumberDays)
        for _ in 0...athleticsPointsEvent.sEventsArray.count {
            performancesArray.append(0.0)
        }
    }
    
    init () {
        super.init(name: "Initialized", events: [AthleticsEvent](), days: 0)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) yoooo the errorr is bla bla has not been implemented")
    }
    
    static func userSavedPerfToAthPointsEventPerf(userSavedPerf: UserSavedPerformance) -> AthleticsPointsEventPerformance {
        
        var athleticsEventsArray = [AthleticsEvent]()
        var performancesArray = [Double]()
        if let jsonData1 = userSavedPerf.wrappedPerformanceEventsArray.data(using: .utf8), let jsonData2 = userSavedPerf.wrappedPerformancesArray.data(using: .utf8)

        {
            let decoder = JSONDecoder()

            do {
                athleticsEventsArray = try decoder.decode([AthleticsEvent].self, from: jsonData1)
                performancesArray = try decoder.decode([Double].self, from: jsonData2)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let athPointsEvent = AthleticsPointsEvent(name: userSavedPerf.wrappedPerformanceEventName,
                              events: athleticsEventsArray,
                              days: Int(userSavedPerf.performanceNumberDays)
                            )
        
        let athleticsPointsEventPerformance = AthleticsPointsEventPerformance(athleticsPointsEvent: athPointsEvent)
        athleticsPointsEventPerformance.performanceTitle=userSavedPerf.wrappedPerformanceTitle
        athleticsPointsEventPerformance.performancesArray=performancesArray
        athleticsPointsEventPerformance.totalPoints = Int(userSavedPerf.performanceTotalPoints)
        athleticsPointsEventPerformance.performanceID = userSavedPerf.wrappedPerformanceID
//        print ("IMPORTANT CHECK POINT APEP: \(athleticsPointsEventPerformance.performancesArray) SIZE:\(athleticsPointsEventPerformance.performancesArray.count) ")
        return athleticsPointsEventPerformance
    }
    
}
