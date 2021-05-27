//
//  EventPointsHolder.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 14/3/21.
//

import SwiftUI

struct EventPointsHolder {
    
    var numberOfEvents = 0
    var pointsIntArray = [Int]()
    var performancesStringArray = [Double]()

    //The initialization/value filling of the above variables is done in mainviewmodel
    
    var totalSum :Int {
        return getDay1Sum()+getDay2Sum()
    }
    
    func getDay1Sum() -> Int {
        if numberOfEvents==0 {
            return 0
        }
        var day1Sum=0
        let count = 0...Int(floor(Double(numberOfEvents-1)/2))
        for i in count {
            day1Sum+=pointsIntArray[i]
        }
        return day1Sum
    }
    
    func getDay2Sum() -> Int {
        
        //single events dont have day 2
        if numberOfEvents<2 {
            return 0
        }
        var day2Sum=0
        let count = Int(floor(Double(numberOfEvents-1)/2))+1...numberOfEvents-1
        for i in count {
            day2Sum+=pointsIntArray[i]
        }
        return day2Sum
    }
}
