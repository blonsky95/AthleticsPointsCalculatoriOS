//
//  EventPointsHolder.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 14/3/21.
//

import Foundation

class EventPointsHolder:ObservableObject {
    
    var numberOfEvents:Int
    
    @Published var pointsIntArray = [Int]()
    @Published var performancesStringArray = [Double]()


    init() {
        numberOfEvents=0
    }
    
    func setNumberEvents(numberOfEvents:Int) {
        self.numberOfEvents=numberOfEvents

        let count = 0...numberOfEvents-1
        for _ in count {
            pointsIntArray.append(0)
            performancesStringArray.append(0.0)
        }
    }
}

extension EventPointsHolder {
    
    var totalSum :Int {
        getDay1Sum()+getDay2Sum()
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
