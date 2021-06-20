//
//  EventGroupPointsHolder.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 20/6/21.
//

import Foundation

struct EventGroupPointsHolder {
    
    var numberOfPerformances = 0
    
    var selectedEventGroupEventIndexArray=[Int]()
    
    var selectedEventGroupEventArray=[AthleticsEvent]()

    var selectedEventGroupEventPerformance=[String]()
    var selectedEventGroupEventPerformancePoints=[String]()

    var selectedEventGroupEventPlacementPoints=[String]()
    
    
    //The initialization/value filling of the above variables is done in mainviewmodel
    
//    var totalSum :Int {
//        return getDay1Sum()+getDay2Sum()
//    }
    
//    func getDay1Sum() -> Int {
//        if numberOfPerformances==0 {
//            return 0
//        }
//        var day1Sum=0
//        let count = 0...Int(floor(Double(numberOfPerformances-1)/2))
//        for i in count {
//            day1Sum+=pointsIntArray[i]
//        }
//        return day1Sum
//    }
    
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
