//
//  AthleticsEvent.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 14/3/21.
//

import SwiftUI

public class AthleticsEvent : Codable {
    let sName:String
    let sType:String //run jump or throw
    let sCategory:String //is it combined events, indoor/outdoor, and male/female
    let sKey:String
    let sCoefficients:Dictionary<String,Double>
    
    enum CodingKeys: String, CodingKey {
        //I dont really need to use this - this corresponds to the json i am using in all_events.json
        case sName = "sName"
        case sType = "sType"
        case sCategory = "sCategory"
        case sKey = "sKey"
        case sCoefficients = "sCoefficients"
    }
    
    static let typeRun="type_run" //Only seconds
    static let typeRunLong="type_run_long" //minutes and seconds
    static let typeRunVeryLong="type_run_very_long" //hours, minutes and seconds
    static let typeJump="type_jump"
    static let typeThrow="type_throw"
    
    static let categoryCombinedEvents="category_combined_events"
    static let categoryIndoorFemale="category_indoor_female"
    static let categoryIndoorMale="category_indoor_male"
    static let categoryOutdoorFemale="category_outdoor_female"
    static let categoryOutdoorMale="category_outdoor_male"
    
    static func needsWindParameter(eventKey:String) -> Bool {
        return (eventKey == "100m_m_o" || eventKey == "200m_m_o" || eventKey == "110mh_m_o"  || eventKey == "long_jump_m_o" || eventKey == "triple_jump_m_o" || eventKey == "100m_f_o" || eventKey == "200m_f_o" || eventKey == "100mh_f_o"  || eventKey == "long_jump_f_o" || eventKey == "triple_jump_f_o")
    }
    
    init () {
        self.sName="unknown"
        self.sType=Self.typeRun
        self.sCategory=Self.categoryCombinedEvents
        self.sKey="key_unknown"
        self.sCoefficients=["a":0,"b":0,"c":0]
    }
    
    func getIndoorDisplayName() -> String {
        if self.sCategory==AthleticsEvent.categoryIndoorFemale||self.sCategory==AthleticsEvent.categoryIndoorMale {
            return self.sName + "(i)"
        } else {
            return self.sName
        }
    }
    static func getExample() -> AthleticsEvent {
//        var athleticsEvent = AthleticsEvent()
//        athleticsEvent.sName="150m"
//        athleticsEvent.sKey="150m_o_m"
        return AthleticsEvent()
    }
}
