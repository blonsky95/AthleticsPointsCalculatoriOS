//
//  AthleticsEvent.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 13/3/21.
//

import SwiftUI


//This class describes an event, but is never custom
//sName will refer to the event name, not a user picked name
class AthleticsPointsEvent : Codable  {
    let sEventName:String
    let sEventsArray:[AthleticsEvent]
    let sNumberDays:Int
    
    enum CodingKeys: String, CodingKey {
        case sEventName = "s_event_name"
        case sEventsArray = "s_events_array"
        case sNumberDays = "s_number_days"
    }
    
    init (name: String, events: [AthleticsEvent], days: Int) {
        self.sEventName=name
        self.sEventsArray=events
        self.sNumberDays=days
    }
    
}
