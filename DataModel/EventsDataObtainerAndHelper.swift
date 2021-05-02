//
//  EventsDataObtainerAndHelper.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 14/3/21.
//

import Foundation

//THIS IS A SINGLETON
class EventsDataObtainerAndHelper:ObservableObject{
        
    
    //contains all the athletics events
    let allAthleticsEvents: [AthleticsEvent]
    
     //we use array for allSingleEvents because it facilitates using a Picker in ContentView and sending it to CalculatorView
    var maleOutdoorSingleEvents = [AthleticsEvent]()
    var femaleOutdoorSingleEvents = [AthleticsEvent]()
    var maleIndoorSingleEvents = [AthleticsEvent]()
    var femaleIndoorSingleEvents = [AthleticsEvent]()


//    var singleEventsCount:Int=0
    var athleticsEventsSearcher: Dictionary<String, AthleticsEvent>
    
    init() {
        allAthleticsEvents = Bundle.main.decode("all_events.json")
        athleticsEventsSearcher=Dictionary<String, AthleticsEvent>()
        for event in allAthleticsEvents {
            switch event.sCategory {
            case AthleticsEvent.categoryOutdoorMale:
                maleOutdoorSingleEvents.append(event)
            case AthleticsEvent.categoryOutdoorFemale:
                femaleOutdoorSingleEvents.append(event)
            case AthleticsEvent.categoryIndoorMale:
                maleIndoorSingleEvents.append(event)
            case AthleticsEvent.categoryIndoorFemale:
                femaleIndoorSingleEvents.append(event)
            default:
                var x = "hello"
//                print("Must be combined events")
            }

            athleticsEventsSearcher[event.sKey]=event
        }
    }
    
    func getPoints(event:AthleticsEvent, performance:Double) -> Int {
        
        if performance<=0 {
            return 0
        }
        
        var points=0
        
        //combined events formulas, there is one for each type: run (runLong is the same), jump and throw
        if event.sCategory==AthleticsEvent.categoryCombinedEvents {
            switch event.sType {
            
            case AthleticsEvent.typeRun:
                //seconds and decimals
                if performance>event.sCoefficients["b"]!{
                    return 0
                }
                points=Int(floor((event.sCoefficients["a"]!)*pow((event.sCoefficients["b"]!-performance), event.sCoefficients["c"]!)))
                
            case AthleticsEvent.typeRunLong:
                //seconds and decimals
                if performance>event.sCoefficients["b"]!{
                    return 0
                }
                points=Int(floor((event.sCoefficients["a"]!)*pow((event.sCoefficients["b"]!-performance), event.sCoefficients["c"]!)))
                
            case AthleticsEvent.typeJump:
                //convert m to cm e.g. 7.07 will be 707
                if performance*100<event.sCoefficients["b"]!{
                    return 0
                }
                points=Int(floor((event.sCoefficients["a"]!)*pow((performance*100-event.sCoefficients["b"]!), event.sCoefficients["c"]!)))
                
            case AthleticsEvent.typeThrow:
                //stays in m e.g. 16.33
                if performance<event.sCoefficients["b"]!{
                    return 0
                }
                points=Int(floor((event.sCoefficients["a"]!)*pow((performance-event.sCoefficients["b"]!), event.sCoefficients["c"]!)))
                
            default:
                return points
            }
        } else {
            //single events formulas
            //They all have the following second order polynomial formula:
            // a * (x + b)^2 + c
            
            points = Int(floor(event.sCoefficients["a"]! * pow(performance+event.sCoefficients["b"]!, 2) + event.sCoefficients["c"]!))
        }
        

        
        
        if points>1999 || points<0 {
            return 0
        } else {
            return points
        }
    }
    
}
