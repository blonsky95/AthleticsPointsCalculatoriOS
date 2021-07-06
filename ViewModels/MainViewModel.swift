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
                self.fetchPointsPerformances()
            }
        }
    }
    
    
    //-----//-----////-----//-----////-----//-----////-----//-----//
    //Saved Performances View
    
    var performancesSearchText:String = ""
    
    func updatePerformancesQuery(searchText: String) {
            performancesSearchText=searchText
            fetchPointsPerformances(searchText: performancesSearchText)
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
    
    func savePerformancesData(){
        do {
            try
            container.viewContext.save()
            fetchPerformances(searchText: performancesSearchText)
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
        
        savePerformancesData()
    }
    
    func updatePerformance(userSavedPerformance: UserSavedPerformance, titleOfNewPerformance:String) {

        userSavedPerformance.performanceTitle = titleOfNewPerformance
        userSavedPerformance.performanceTotalPoints = Int16(eventPointsHolder.totalSum)
        

        let jsonData2 = try! JSONEncoder().encode(eventPointsHolder.performancesStringArray)
        userSavedPerformance.performancesArray = String(data: jsonData2, encoding: .utf8)!
        
        print("this is the performances array when updated: \(userSavedPerformance.wrappedPerformancesArray)")

        userSavedPerformance.date=Date()
        //there is no container function to update, save() does the job
        savePerformancesData()
    }
    
    func deletePerformance(indexSet: IndexSet) {
        guard let sIndexSet = indexSet.first else {return}
        let perf = userSavedPerfsArray[sIndexSet]
        print("will delete \(perf.wrappedPerformanceTitle)")
        container.viewContext.delete(perf)
        savePerformancesData()
    }
    
    func fetchPerformances(searchText:String? = nil) {
        let fetchRequest = NSFetchRequest<UserSavedPerformance>(entityName: "UserSavedPerformance")        

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \UserSavedPerformance.date, ascending: false),
            NSSortDescriptor(keyPath: \UserSavedPerformance.performanceTitle, ascending: true)
        ]
        
        if searchText != nil && !(searchText?.isEmpty ?? true) {
//            print("predicate added to the fetch request: \(searchText!)")
            
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
    
    func getStringPointsForEvent(event: AthleticsEvent, perf: Double) -> String {
        return String(eventsDataObtainerAndHelper.getPoints(event: event, performance: perf))
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
    
    //-----//-----////-----//-----////-----//-----////-----//-----//
    //Points Calculator view
    
    func getEventGroup(index: Int) -> EventGroup {
//        print("get event group called: \(eventsDataObtainerAndHelper.allEventGroups[index].sName)")
        return eventsDataObtainerAndHelper.allEventGroups[index]
    }
    
    //-----//-----////-----//-----////-----//-----////-----//-----//
    //Event Rankings view
    
    var pointsPerformancesSearchText:String = ""
    
    func updatePointsPerformancesQuery(searchText: String) {
            pointsPerformancesSearchText=searchText
            fetchPointsPerformances(searchText: pointsPerformancesSearchText)
    }
    
    //Core data stuff
    
    @Published var wAPointsPerformancesArray:[WAPointsPerformance] = []
    
    func saveWAPointsPerformancesData(){
        do {
            try
            container.viewContext.save()
            fetchPointsPerformances(searchText: "")
        } catch let error{
            print ("error saving 222 data: \(error)")
        }
        
    }
    
    func fetchPointsPerformances(searchText:String? = nil) {
        let fetchRequest = NSFetchRequest<WAPointsPerformance>(entityName: "WAPointsPerformance")

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \WAPointsPerformance.date, ascending: false),
            NSSortDescriptor(keyPath: \WAPointsPerformance.performanceTitle, ascending: true)
        ]
        
        if searchText != nil && !(searchText?.isEmpty ?? true) {
            
            let titleFilter = NSPredicate(format: "performanceTitle CONTAINS[c] %@", searchText!)
            let eventGroupFilter = NSPredicate(format: "eventGroup CONTAINS[c] %@", searchText!)
            let rankingScoreFilter = NSPredicate(format: "rankingScore BEGINSWITH %@", searchText!)
            
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titleFilter, eventGroupFilter, rankingScoreFilter])
        }
       
        do {
            wAPointsPerformancesArray = try container.viewContext.fetch(fetchRequest)
        } catch let error {
            print("Error fetching perfs: \(error)")
        }
    }
    
    func createWAPointsPerformance(cHolder: EventGroupPointsHolder, titleOfNewPerformance:String) {
        
        let newInstance = WAPointsPerformance(context: container.viewContext)
        newInstance.id = UUID()
        newInstance.performanceTitle = titleOfNewPerformance
        
        let jsonEventGroup = try! JSONEncoder().encode(cHolder.eventGroup)
        newInstance.eventGroup = String(data: jsonEventGroup, encoding: .utf8)!
        
        let jsonSelAthEvents = try! JSONEncoder().encode(cHolder.selectedAthleticsEvents)
        newInstance.selectedAthleticsEvents=String(data: jsonSelAthEvents, encoding: .utf8)!
        
        let jsonEvePerfs = try! JSONEncoder().encode(cHolder.eventPerformances)
        newInstance.eventPerformances=String(data: jsonEvePerfs, encoding: .utf8)!
        
        let jsonEvePerfsPts = try! JSONEncoder().encode(cHolder.eventPerformancesPoints)
        newInstance.eventPerformancePoints=String(data: jsonEvePerfsPts, encoding: .utf8)!
        
        let jsonEvePlcPts = try! JSONEncoder().encode(cHolder.eventPlacementPoints)
        newInstance.eventPlacementPoints=String(data: jsonEvePlcPts, encoding: .utf8)!
        
        newInstance.rankingScore = String(cHolder.getAverage())

        print("points perf saved, title: \(newInstance.wrappedPerformanceTitle), ranking score: \(newInstance.wrappedRankingScore)")
        
        print("points perf saved 2, title: \(String(describing: newInstance.eventPerformances))")
        newInstance.date=Date()
        container.viewContext.insert(newInstance)

        saveWAPointsPerformancesData()
    }
        
}
