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
                var _ = "hello"
//                print("Must be combined events")
            }

            athleticsEventsSearcher[event.sKey]=event
        }
    }
    
    enum CombinedEventsKeys {
        case menOutdoorDecathlon
        case menIndoorHeptathlon
        case womenOutdoorHeptathlon
        case womenOutdoorDecathlon
        case womenIndoorPentathlon
    }
    
    func getCombinedEventsAthleticsPointEvent(eventKey: CombinedEventsKeys) -> AthleticsPointsEvent {
        switch eventKey {
        case .menOutdoorDecathlon:
            return AthleticsPointsEvent(name: "Decathlon", events:
                                            [self.athleticsEventsSearcher["100m_m_ce"]!,
                                             self.athleticsEventsSearcher["long_jump_m_ce"]!,
                                             self.athleticsEventsSearcher["shot_put_m_ce"]!,
                                             self.athleticsEventsSearcher["high_jump_m_ce"]!,
                                             self.athleticsEventsSearcher["400m_m_ce"]!,
                                             self.athleticsEventsSearcher["110mh_m_ce"]!,
                                             self.athleticsEventsSearcher["discus_m_ce"]!,
                                             self.athleticsEventsSearcher["pole_vault_m_ce"]!,
                                             self.athleticsEventsSearcher["javelin_m_ce"]!,
                                             self.athleticsEventsSearcher["1500m_m_ce"]!],
                                        days:2)
            
        case .menIndoorHeptathlon:
            return AthleticsPointsEvent(name: "Indoor Heptathlon", events:
                                            [self.athleticsEventsSearcher["60m_m_ce"]!,
                                             self.athleticsEventsSearcher["long_jump_m_ce"]!,
                                             self.athleticsEventsSearcher["shot_put_m_ce"]!,
                                             self.athleticsEventsSearcher["high_jump_m_ce"]!,
                                             self.athleticsEventsSearcher["60mh_m_ce"]!,
                                             self.athleticsEventsSearcher["pole_vault_m_ce"]!,
                                             self.athleticsEventsSearcher["1000m_m_ce"]!],
                                        days:2)

        case .womenOutdoorHeptathlon:
            return AthleticsPointsEvent(name: "Heptathlon", events:
                                            [self.athleticsEventsSearcher["100mh_f_ce"]!,
                                             self.athleticsEventsSearcher["high_jump_f_ce"]!,
                                             self.athleticsEventsSearcher["shot_put_f_ce"]!,
                                             self.athleticsEventsSearcher["200m_f_ce"]!,
                                             self.athleticsEventsSearcher["long_jump_f_ce"]!,
                                             self.athleticsEventsSearcher["javelin_f_ce"]!,
                                             self.athleticsEventsSearcher["800m_f_ce"]!],
                                        days:2)

        case .womenOutdoorDecathlon:
            return AthleticsPointsEvent(name: "Women Decathlon", events:
                                            [self.athleticsEventsSearcher["100m_f_ce"]!,
                                             self.athleticsEventsSearcher["long_jump_f_ce"]!,
                                             self.athleticsEventsSearcher["shot_put_f_ce"]!,
                                             self.athleticsEventsSearcher["high_jump_f_ce"]!,
                                             self.athleticsEventsSearcher["400m_f_ce"]!,
                                             self.athleticsEventsSearcher["100mh_f_ce"]!,
                                             self.athleticsEventsSearcher["discus_f_ce"]!,
                                             self.athleticsEventsSearcher["pole_vault_f_ce"]!,
                                             self.athleticsEventsSearcher["javelin_f_ce"]!,
                                             self.athleticsEventsSearcher["1500m_f_ce"]!],
                                        days:2)

        case .womenIndoorPentathlon:
            return AthleticsPointsEvent(name: "Indoor Pentathlon", events:
                                            [self.athleticsEventsSearcher["60mh_f_ce"]!,
                                             self.athleticsEventsSearcher["high_jump_f_ce"]!,
                                             self.athleticsEventsSearcher["shot_put_f_ce"]!,
                                             self.athleticsEventsSearcher["long_jump_f_ce"]!,
                                             self.athleticsEventsSearcher["800m_f_ce"]!],
                                        days:1)

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
