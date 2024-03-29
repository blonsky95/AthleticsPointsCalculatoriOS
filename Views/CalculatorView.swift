//
//  CalculatorView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 12/3/21.
//

import SwiftUI

struct CalculatorView: View {
    
    let athleticPointsEvent:AthleticsPointsEvent
    let userSavedPerformance:UserSavedPerformance?
    
    @EnvironmentObject var mainViewModel : MainViewModel

    @Environment(\.currentTab) var tab
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var titleOfSavedPerformance = "Untitled"
    @State private var showingAlert = false
    
    var isASavedPerformance:Bool{
        return userSavedPerformance != nil
    }

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
                    SingleEventScoreView(athleticsEvent: athleticPointsEvent.sEventsArray[i],
                                         performance: getPerformance(athleticPointsEvent: athleticPointsEvent, index: i),
                                         eventIndex: i)
                        .background(Color(UIColor.blue.withAlphaComponent(0.12-(5*CGFloat(i%2))/100)))

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
                        Text("\(mainViewModel.eventPointsHolder.getDay1Sum())")
                    }
                    HStack {
                        Text("Day 2")
                        Spacer()
                        Text("\(mainViewModel.eventPointsHolder.getDay2Sum())")
                    }
                }
                if athleticPointsEvent.sEventsArray.count>1 {
                    HStack {
                        Text("Total")
                            .font(.title2)
                        Spacer()
                        Text("\(mainViewModel.eventPointsHolder.totalSum)")
                    }
                }
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .onAppear{
            mainViewModel.resetEventPointsHolder(numberOfEventsOfPerformance: athleticPointsEvent.sEventsArray.count)
            loadPerformanceName()
        }
        .alert(isPresented: $showingAlert, content: getAlert)
    }
    
    func getAlert() -> Alert {
        return Alert(
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
        mainViewModel.createPerformance(athleticPointsEvent: athleticPointsEvent, titleOfNewPerformance: titleOfSavedPerformance)

        handleViewDismissal()
    }
    
    func updateUserSavedPerformance() {
        if let userSavPerf=userSavedPerformance {
            mainViewModel.updatePerformance(userSavedPerformance: userSavPerf, titleOfNewPerformance: titleOfSavedPerformance)
        }
        handleViewDismissal()
    }
    
    func handleViewDismissal() {
        //If comes from calculator view - take to saved
        //If comes from saved - dismiss the navigation screen
        
        
        //TODO i want a swift transition
        if isASavedPerformance {
            presentationMode.wrappedValue.dismiss()
        } else {
            presentationMode.wrappedValue.dismiss()
            self.tab.wrappedValue = .savedPerformances
            //The create tab is still on the calculatorview! Unless I dismiss
        }
    }
  
    
    //this basically checks if what is being sent to single score view needs to have a value, aka is saved performance
    // to do so it checks if its a AthleticsPointsEventPerformance class (subclass of AthleticPointsEvents)
    func getPerformance(athleticPointsEvent : AthleticsPointsEvent, index: Int) -> String {
        var performance = "0.0"
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
        
        CalculatorView(athleticPointsEvent: decathlon, userSavedPerformance: nil)
    }
}

