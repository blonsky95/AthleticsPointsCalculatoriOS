//
//  EventGroupPointsHolder.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 20/6/21.
//

import SwiftUI

class EventGroupPointsHolder {
    
    var numberOfPerformances = 0
    
    var eventGroup:EventGroup = EventGroup()
    
    var selectedEventGroupEventIndexArray=[Int]()
    
    var selectedEventGroupEventArray=[AthleticsEvent]()

    var selectedEventGroupEventPerformance=[String]()
    var selectedEventGroupEventPerformancePoints=[String]()

    var selectedEventGroupEventPlacementPoints=[String]()
    
    
//    func getDay2Sum() -> Int {
//        
//        //single events dont have day 2
//        if numberOfPerformances<2 {
//            return 0
//        }
//        var day2Sum=0
//        let count = Int(floor(Double(numberOfPerformances-1)/2))+1...numberOfPerformances-1
//        for i in count {
//            day2Sum+=pointsIntArray[i]
//        }
//        return day2Sum
//    }
}
