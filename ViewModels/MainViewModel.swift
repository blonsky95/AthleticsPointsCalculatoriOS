//
//  MainViewModel.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 24/5/21.
//

import Foundation
import CoreData

class MainViewModel: ObservableObject {
    
    var eventsDataObtainerAndHelper:EventsDataObtainerAndHelper
    let container: NSPersistentContainer
    
    init() {
        eventsDataObtainerAndHelper = EventsDataObtainerAndHelper()
        container = NSPersistentContainer(name: "AthleticsPointsCalculator")
        container.loadPersistentStores{( description, error) in
            if let pError = error {
                print("Error loading container: \(pError)")
            } else {
//                print("Container loaded succesfully")
                self.fetchPerformances()
            }
        }
    }
    
    
    //-----//-----////-----//-----////-----//-----////-----//-----//
    //Saved Performances View
    
    var currentSearchText:String = ""
    
    func updateQuery(searchText: String) {
            currentSearchText=searchText
            fetchPerformances(searchText: currentSearchText)
    }
    
    func getAthleticsPerformanceFromSelection(selectedUUID: UUID) -> AthleticsPointsEventPerformance? {
        if let performance = userSavedPerfsArray.first(where: {$0.id == selectedUUID}) {
            return AthleticsPointsEventPerformance.userSavedPerfToAthPointsEventPerf(userSavedPerf: performance)
        } else {
            return nil
        }
    }

   
    
    
    //-----//-----////-----//-----////-----//-----////-----//-----//
    //Core Data stuff
    
    @Published var userSavedPerfsArray:[UserSavedPerformance] = []
    
    func saveData(){
        do {
            try
            container.viewContext.save()
            fetchPerformances(searchText: currentSearchText)
        } catch let error{
            print ("error saving data: \(error)")
        }
        
    }
    
    func createPerformance(athleticPointsEvent: AthleticsPointsEvent, titleOfNewPerformance:String) {
        let newUserSavedPerformance = UserSavedPerformance(context: container.viewContext)
        newUserSavedPerformance.id = UUID()
        
        newUserSavedPerformance.performanceEventName = athleticPointsEvent.sEventName
        newUserSavedPerformance.performanceNumberDays = Int16(athleticPointsEvent.sNumberDays)
        
        //the array of AthleticsEvent should be encodable because AthleticsEvent implements it
        let jsonData = try! JSONEncoder().encode(athleticPointsEvent.sEventsArray)
        newUserSavedPerformance.performanceEventsArray = String(data: jsonData, encoding: .utf8)!
        
        newUserSavedPerformance.performanceTitle = titleOfNewPerformance
        newUserSavedPerformance.performanceTotalPoints = Int16(eventPointsHolder.totalSum)
        
        let jsonData2 = try! JSONEncoder().encode(eventPointsHolder.performancesStringArray)
        newUserSavedPerformance.performancesArray = String(data: jsonData2, encoding: .utf8)!
        
        newUserSavedPerformance.date=Date()
        container.viewContext.insert(newUserSavedPerformance)
        
        saveData()
    }
    
    func updatePerformance(userSavedPerformance: UserSavedPerformance, titleOfNewPerformance:String) {

        userSavedPerformance.performanceTitle = titleOfNewPerformance
        userSavedPerformance.performanceTotalPoints = Int16(eventPointsHolder.totalSum)
        

        let jsonData2 = try! JSONEncoder().encode(eventPointsHolder.performancesStringArray)
        userSavedPerformance.performancesArray = String(data: jsonData2, encoding: .utf8)!
        
        print("this is the performances array when updated: \(userSavedPerformance.wrappedPerformancesArray)")

        userSavedPerformance.date=Date()
        //there is no container function to update, save() does the job
        saveData()
    }
    
    func deletePerformance(indexSet: IndexSet) {
        guard let sIndexSet = indexSet.first else {return}
        let perf = userSavedPerfsArray[sIndexSet]
        print("will delete \(perf.wrappedPerformanceTitle)")
        container.viewContext.delete(perf)
        saveData()
    }
    
    func fetchPerformances(searchText:String? = nil) {
        let fetchRequest = NSFetchRequest<UserSavedPerformance>(entityName: "UserSavedPerformance")        

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \UserSavedPerformance.date, ascending: false),
            NSSortDescriptor(keyPath: \UserSavedPerformance.performanceTitle, ascending: true)
        ]
        
        if searchText != nil && !(searchText?.isEmpty ?? true) {
            print("predicate added to the fetch request: \(searchText!)")
            
            let titleFilter = NSPredicate(format: "performanceTitle CONTAINS[c] %@", searchText!)
            let eventFilter = NSPredicate(format: "performanceEventName CONTAINS[c] %@", searchText!)
            let pointsFilter = NSPredicate(format: "performanceTotalPoints BEGINSWITH %@", searchText!)
            
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titleFilter, eventFilter, pointsFilter])
        }
       
        do {
            userSavedPerfsArray = try container.viewContext.fetch(fetchRequest)
        } catch let error {
            print("Error fetching perfs: \(error)")
        }
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
            eventPointsHolder.performancesStringArray.append("0.0")
        }
    }
    
    func updateEventPointsHolder(eventIndex: Int, eventPoints: Int, eventPerf: String) {
        eventPointsHolder.pointsIntArray[eventIndex] = eventPoints
        eventPointsHolder.performancesStringArray[eventIndex] = eventPerf
    }

    
}
