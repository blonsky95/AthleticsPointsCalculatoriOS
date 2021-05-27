//
//  MainViewModel.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 24/5/21.
//

import Foundation

class MainViewModel: ObservableObject {
    
    var eventsDataObtainerAndHelper:EventsDataObtainerAndHelper
    
    init() {
        eventsDataObtainerAndHelper = EventsDataObtainerAndHelper()
    }
    
    //-----//-----////-----//-----////-----//-----////-----//-----//
    //Event Selector View
    func getWomenOutdoorHeptathlon() -> AthleticsPointsEvent {
        return eventsDataObtainerAndHelper.getCombinedEventsAthleticsPointEvent(eventKey: EventsDataObtainerAndHelper.CombinedEventsKeys.womenOutdoorHeptathlon)
    }
    
    func getWomenIndoorPentathlon() -> AthleticsPointsEvent {
        return
            eventsDataObtainerAndHelper.getCombinedEventsAthleticsPointEvent(eventKey: EventsDataObtainerAndHelper.CombinedEventsKeys.womenIndoorPentathlon)
    }
    
    func getWomenDecathlon() -> AthleticsPointsEvent {
        return
            eventsDataObtainerAndHelper.getCombinedEventsAthleticsPointEvent(eventKey: EventsDataObtainerAndHelper.CombinedEventsKeys.womenOutdoorDecathlon)
    }
    
    func getMenDecathlon() -> AthleticsPointsEvent {
        return
            eventsDataObtainerAndHelper.getCombinedEventsAthleticsPointEvent(eventKey: EventsDataObtainerAndHelper.CombinedEventsKeys.menOutdoorDecathlon)
    }
    
    func getMenHeptathlon() -> AthleticsPointsEvent {
        return
            eventsDataObtainerAndHelper.getCombinedEventsAthleticsPointEvent(eventKey: EventsDataObtainerAndHelper.CombinedEventsKeys.menIndoorHeptathlon)
    }
    
    func getMaleOutdoorSingleEvent(index: Int) -> AthleticsPointsEvent {
        return getSingleEvent(index: index, categoryString: AthleticsEvent.categoryOutdoorMale)
    }
    
    func getMaleIndoorSingleEvent(index: Int) -> AthleticsPointsEvent {
        return getSingleEvent(index: index, categoryString: AthleticsEvent.categoryIndoorMale)
    }
    
    func getFemaleOutdoorSingleEvent(index: Int) -> AthleticsPointsEvent {
        return getSingleEvent(index: index, categoryString: AthleticsEvent.categoryOutdoorFemale)
    }
    
    func getFemaleIndoorSingleEvent(index: Int) -> AthleticsPointsEvent {
        return getSingleEvent(index: index, categoryString: AthleticsEvent.categoryIndoorFemale)
    }
    
    func getSingleEvent(index: Int, categoryString: String) -> AthleticsPointsEvent {
        
        var athleticsEvent:AthleticsEvent? = nil
        
        switch categoryString {
        case AthleticsEvent.categoryIndoorMale:
            athleticsEvent = eventsDataObtainerAndHelper.maleIndoorSingleEvents[index]
        case AthleticsEvent.categoryOutdoorMale:
            athleticsEvent = eventsDataObtainerAndHelper.maleOutdoorSingleEvents[index]
        case AthleticsEvent.categoryIndoorFemale:
            athleticsEvent = eventsDataObtainerAndHelper.femaleIndoorSingleEvents[index]
        case AthleticsEvent.categoryOutdoorFemale:
            athleticsEvent = eventsDataObtainerAndHelper.femaleOutdoorSingleEvents[index]
        default:
            print("woops")
        }

        return
            AthleticsPointsEvent(name: athleticsEvent!.sName, events: [athleticsEvent!], days: 1)
    }
    
    //-----//-----////-----//-----////-----//-----////-----//-----//
    //Calculator view
    
    
    @Published var eventPointsHolder=EventPointsHolder()
    
    func getPointsForEvent(event: AthleticsEvent, perf: Double) -> Int {
        return eventsDataObtainerAndHelper.getPoints(event: event, performance: perf)
    }
    
    
    //Call this when new event is loaded
    func resetEventPointsHolder(numberOfEventsOfPerformance: Int) {
        eventPointsHolder = EventPointsHolder()
        
        eventPointsHolder.numberOfEvents = numberOfEventsOfPerformance
        
        let count = 0...numberOfEventsOfPerformance-1
        for _ in count {
            eventPointsHolder.pointsIntArray.append(0)
            eventPointsHolder.performancesStringArray.append(0.0)
        }
    }
    
    func updateEventPointsHolder(eventIndex: Int, eventPoints: Int, eventPerf: String) {
        eventPointsHolder.pointsIntArray[eventIndex] = eventPoints
        eventPointsHolder.performancesStringArray[eventIndex] = eventPerf.doubleValue
    }

    
}
