//
//  CalculatorView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 12/3/21.
//

import SwiftUI

struct CalculatorView: View {
    
    //when the following variable is AthleticsPointEventPerformance - so the subclass, it is a saved perf.
    let athleticPointsEvent:AthleticsPointsEvent //if a single event, it will contain an sEvents array of 1 event
    let userSavedPerformance:UserSavedPerformance? 
    var isASavedPerformance:Bool = false

    @EnvironmentObject var eventsDataObtainerAndHelper: EventsDataObtainerAndHelper
    
    @Environment(\.managedObjectContext) var moc

    @StateObject private var eventPointsHolder=EventPointsHolder()
    
    @State private var titleOfSavedPerformance = "Untitled"
    @State private var showingAlert = false

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
            
            HStack {
                TextField(titleOfSavedPerformance, text: $titleOfSavedPerformance)
                    .font(.title)
                    .padding(.bottom)
            }
            HStack {
                Text(athleticPointsEvent.sEventName)
                    .font(.title2)
                    .padding(.bottom)
                Spacer()
            }
            
            
            ForEach (0..<athleticPointsEvent.sEventsArray.count) { i in
                SingleEventScoreView(athleticsEvent: athleticPointsEvent.sEventsArray[i], performance: getPerformance(athleticPointsEvent: athleticPointsEvent, index: i), eventIndex: i, eventPointsHolder: eventPointsHolder).environmentObject(eventsDataObtainerAndHelper)
            }
                
            HStack{
                Button("Save performance") {
                    saveButtonPressed()
                }
                .padding()
            }
            
            if athleticPointsEvent.sNumberDays>1 {
                HStack {
                    Text("Day 1")
                    Spacer()
                    Text("\(eventPointsHolder.getDay1Sum())")
                }
                HStack {
                    Text("Day 2")
                    Spacer()
                    Text("\(eventPointsHolder.getDay2Sum())")
                }
            }
            if athleticPointsEvent.sEventsArray.count>1 {
                HStack {
                    Text("Total")
                        .font(.title2)
                    Spacer()
                    Text("\(eventPointsHolder.totalSum)")
                }
            }
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .onAppear{
            eventPointsHolder.setNumberEvents(numberOfEvents: athleticPointsEvent.sEventsArray.count)
            loadPerformanceName()
        }
        .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Overwrite performance?"),
                        message: Text("Overwrite existing performance, or create a new performance?"),
                        primaryButton: .default(Text("Overwrite")) {
                            print("Overwrite...")
                            updateUserSavedPerformance()
                        },
                        secondaryButton: .default(Text("New")) {
                            print("New...")
                            saveNewUserSavedPerformance()
                        }
                    )
                }
        
    }
    
    
    func saveButtonPressed() {
        if isASavedPerformance {
            if userSavedPerformance!.wrappedPerformanceTitle != titleOfSavedPerformance {
                //dialog
                showingAlert = true
            } else {
                updateUserSavedPerformance()
            }
        }
        else {
            saveNewUserSavedPerformance()
        }
    }
    
    func saveNewUserSavedPerformance() {
        let newUserSavedPerformance = UserSavedPerformance(context: self.moc)
        newUserSavedPerformance.id = UUID()
        
        fillUserSavedPerformanceData(newUserSavedPerformance)
        
        saveToCoreData(newUserSavedPerformance)
    }
    
    func updateUserSavedPerformance() {
        if let userSavPerf=userSavedPerformance {
            fillUserSavedPerformanceData(userSavPerf)
            saveToCoreData(userSavPerf)
        }
    }
    
    func fillUserSavedPerformanceData(_ fillUserSavedPerformance: UserSavedPerformance){
        fillUserSavedPerformance.performanceEventName = athleticPointsEvent.sEventName
        fillUserSavedPerformance.performanceNumberDays = Int16(athleticPointsEvent.sNumberDays)
        
        //the array of AthleticsEvent should be encodable because AthleticsEvent implements it
        let jsonData = try! JSONEncoder().encode(athleticPointsEvent.sEventsArray)
        fillUserSavedPerformance.performanceEventsArray = String(data: jsonData, encoding: .utf8)!
        
        fillUserSavedPerformance.performanceTitle = titleOfSavedPerformance
        fillUserSavedPerformance.performanceTotalPoints = Int16(eventPointsHolder.totalSum)
        
        let jsonData2 = try! JSONEncoder().encode(eventPointsHolder.performancesStringArray)
        fillUserSavedPerformance.performancesArray = String(data: jsonData2, encoding: .utf8)!
        // this should be an array of doubles collected from textfields of points
    }
    
    func saveToCoreData(_ userSavedPerformance: UserSavedPerformance) {
        userSavedPerformance.date=Date() //updates date so shows up at top, applies to new and updated perfs
        print("Saving/updating a new performance: \(userSavedPerformance)")
        try? self.moc.save()
    }
    
    
    //this basically checks if what is being sent to single score view needs to have a value, aka is saved performance
    // to do so it checks if its a AthleticsPointsEventPerformance class (subclass of AthleticPointsEvents)
    func getPerformance(athleticPointsEvent : AthleticsPointsEvent, index: Int) -> Double {
        var performance = 0.0
        if let savedPerformance = athleticPointsEvent as? AthleticsPointsEventPerformance {
            performance = savedPerformance.performancesArray[index]
            }
        return performance
    }
    
    //Called to assign a value to title of calculatedPerformance, if loading a performance, if not nothing happens
    func loadPerformanceName() {
        if isASavedPerformance {
            if let titleString = userSavedPerformance?.wrappedPerformanceTitle {
                titleOfSavedPerformance = titleString
            } else {
                print("error with perf title")
            }
        }
    }
}





struct CalculatorView_Previews: PreviewProvider {

    static var previews: some View {
        let eventsDataObtainerAndHelper = EventsDataObtainerAndHelper()

        let decathlon = AthleticsPointsEvent(name: "Decathlon", events:
                                        [eventsDataObtainerAndHelper.athleticsEventsSearcher["100m_m"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["long_jump_m"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["shot_put_m"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["high_jump_m"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["400m_m"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["110mh_m"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["discus_m"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["pole_vault_m"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["javelin_m"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["1500m_m"]!],
                                    days:2)
        
        CalculatorView(athleticPointsEvent: decathlon, userSavedPerformance: nil, isASavedPerformance: false)
    }
}

