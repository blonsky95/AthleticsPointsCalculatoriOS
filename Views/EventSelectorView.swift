//
//  ContentView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 12/3/21.
//

import SwiftUI
import CoreData


struct EventSelectorView: View {
    
//    let eventsDataObtainerAndHelper = EventsDataObtainerAndHelper()
    
    @EnvironmentObject var eventsDataObtainerAndHelper: EventsDataObtainerAndHelper
    
    @State private var selectedMaleOutdoorEventIndex=0
    @State private var selectedFemaleOutdoorEventIndex=0
    @State private var selectedMaleIndoorEventIndex=0
    @State private var selectedFemaleIndoorEventIndex=0
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack (alignment: .leading){
                    Group
                    {
                        Text("Women Combined Events")
                            .font(.title)
                            .padding(.bottom)
                        NavigationLink(destination: CalculatorView(athleticPointsEvent: getHeptathlon(), userSavedPerformance: nil).environmentObject(eventsDataObtainerAndHelper)) {
                            Text("Heptathlon")
                        }
                        NavigationLink(destination: CalculatorView(athleticPointsEvent: getPentathlon(), userSavedPerformance: nil).environmentObject(eventsDataObtainerAndHelper)) {
                            Text("Pentathlon (indoor)")
                        }
                        NavigationLink(destination: CalculatorView(athleticPointsEvent: getWomenDecathlon(), userSavedPerformance: nil).environmentObject(eventsDataObtainerAndHelper)) {
                            Text("Decathlon")
                        }
                        .padding(.bottom)
                    }
                    
                    Group
                    {
                        Text("Men Combined Events")
                            .font(.title)
                            .padding(.bottom)
//                        NavigationLink(destination: CalculatorView(athleticPointsEvent: getStubAthleticsPointsEventPerformance(), userSavedPerformance: nil, isASavedPerformance: true).environmentObject(eventsDataObtainerAndHelper)) {
//                            Text("Stub saved decathlon")
//                        }
                        NavigationLink(destination: CalculatorView(athleticPointsEvent: getDecathlon(), userSavedPerformance: nil).environmentObject(eventsDataObtainerAndHelper)) {
                            Text("Decathlon")
                        }
                        NavigationLink(destination: CalculatorView(athleticPointsEvent: getIndoorHeptathlon(), userSavedPerformance: nil).environmentObject(eventsDataObtainerAndHelper)) {
                            Text("Heptathlon (indoor)")
                        }
                        .padding(.bottom)
                    }
                    Group
                    {
                        Text("Single Events")
                            .font(.title)
                            .padding(.bottom)
                        
                        HStack {
                            Text("Men outdoor")
                                .font(.title3)
                            Spacer()
                            NavigationLink(destination: CalculatorView(athleticPointsEvent: AthleticsPointsEvent(name: eventsDataObtainerAndHelper.maleOutdoorSingleEvents[selectedMaleOutdoorEventIndex].sName, events: [eventsDataObtainerAndHelper.maleOutdoorSingleEvents[selectedMaleOutdoorEventIndex]], days: 1), userSavedPerformance: nil)
                                            .environmentObject(eventsDataObtainerAndHelper)) {
                                Text("Go")
                            }
                        }
                        CustomEventPicker(selectedSingleEventIndex: $selectedMaleOutdoorEventIndex , arrayOfEvents: eventsDataObtainerAndHelper.maleOutdoorSingleEvents, pickerTitle: "")

                        HStack {
                            Text("Women outdoor")
                                .font(.title3)
                            Spacer()
                            NavigationLink(destination: CalculatorView(athleticPointsEvent: AthleticsPointsEvent(name: eventsDataObtainerAndHelper.femaleOutdoorSingleEvents[selectedFemaleOutdoorEventIndex].sName, events: [eventsDataObtainerAndHelper.femaleOutdoorSingleEvents[selectedFemaleOutdoorEventIndex]], days: 1), userSavedPerformance: nil)
                                            .environmentObject(eventsDataObtainerAndHelper)) {
                                Text("Go")
                            }
                        }
                        CustomEventPicker(selectedSingleEventIndex: $selectedFemaleOutdoorEventIndex , arrayOfEvents: eventsDataObtainerAndHelper.femaleOutdoorSingleEvents, pickerTitle: "")

                        
                        
                        HStack {
                            Text("Men indoor")
                                .font(.title3)
                            Spacer()
                            NavigationLink(destination: CalculatorView(athleticPointsEvent: AthleticsPointsEvent(name: eventsDataObtainerAndHelper.maleIndoorSingleEvents[selectedMaleIndoorEventIndex].sName, events: [eventsDataObtainerAndHelper.maleIndoorSingleEvents[selectedMaleIndoorEventIndex]], days: 1), userSavedPerformance: nil)
                                            .environmentObject(eventsDataObtainerAndHelper)) {
                                Text("Go")
                            }
                        }
                        CustomEventPicker(selectedSingleEventIndex: $selectedMaleIndoorEventIndex , arrayOfEvents: eventsDataObtainerAndHelper.maleIndoorSingleEvents, pickerTitle: "")

                        HStack {
                            Text("Women indoor")
                                .font(.title3)
                            Spacer()
                            NavigationLink(destination: CalculatorView(athleticPointsEvent: AthleticsPointsEvent(name: eventsDataObtainerAndHelper.femaleIndoorSingleEvents[selectedFemaleIndoorEventIndex].sName, events: [eventsDataObtainerAndHelper.femaleIndoorSingleEvents[selectedFemaleIndoorEventIndex]], days: 1), userSavedPerformance: nil)
                                            .environmentObject(eventsDataObtainerAndHelper)) {
                                Text("Go")
                            }
                        }
                        CustomEventPicker(selectedSingleEventIndex: $selectedFemaleIndoorEventIndex, arrayOfEvents: eventsDataObtainerAndHelper.femaleIndoorSingleEvents, pickerTitle: "")
                    }
                    Spacer()
                    
                }
                .padding()
            }
            
        }
        .navigationBarTitle("TF Points Calculator")
    }
    
    func getDecathlon() -> AthleticsPointsEvent {
        return AthleticsPointsEvent(name: "Decathlon", events:
                                        [eventsDataObtainerAndHelper.athleticsEventsSearcher["100m_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["long_jump_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["shot_put_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["high_jump_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["400m_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["110mh_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["discus_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["pole_vault_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["javelin_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["1500m_m_ce"]!],
                                    days:2)
    }
    
//    func getStubAthleticsPointsEventPerformance() -> AthleticsPointsEventPerformance {
//        let dec = AthleticsPointsEvent(name: "Decathlon", events:
//                                        [eventsDataObtainerAndHelper.athleticsEventsSearcher["100m_m_ce"]!,
//                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["long_jump_m_ce"]!,
//                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["shot_put_m_ce"]!,
//                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["high_jump_m_ce"]!,
//                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["400m_m_ce"]!,
//                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["110mh_m_ce"]!,
//                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["discus_m_ce"]!,
//                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["pole_vault_m_ce"]!,
//                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["javelin_m_ce"]!,
//                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["1500m_m_ce"]!],
//                                    days:2)
//
//        let athleticsPointsEventPerformance = AthleticsPointsEventPerformance(athleticsPointsEvent: dec)
//        athleticsPointsEventPerformance.performanceTitle="super dec"
//        athleticsPointsEventPerformance.performancesArray=[11.00,7.26,14.11,1.97,49.22,14.32,45.77,4.70,60.33,268.0]
//        athleticsPointsEventPerformance.totalPoints = 8121
//        return athleticsPointsEventPerformance
//
//    }
    
    func getIndoorHeptathlon() -> AthleticsPointsEvent {
        return AthleticsPointsEvent(name: "Indoor Heptathlon", events:
                                        [eventsDataObtainerAndHelper.athleticsEventsSearcher["60m_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["long_jump_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["shot_put_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["high_jump_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["60mh_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["pole_vault_m_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["1000m_m_ce"]!],
                                    days:2)
    }
    
    func getHeptathlon() -> AthleticsPointsEvent {
        return AthleticsPointsEvent(name: "Heptathlon", events:
                                        [eventsDataObtainerAndHelper.athleticsEventsSearcher["100mh_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["high_jump_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["shot_put_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["200m_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["long_jump_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["javelin_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["800m_f_ce"]!],
                                    days:2)
    }
    
    func getPentathlon() -> AthleticsPointsEvent {
        return AthleticsPointsEvent(name: "Indoor Pentathlon", events:
                                        [eventsDataObtainerAndHelper.athleticsEventsSearcher["60mh_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["high_jump_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["shot_put_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["long_jump_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["800m_f_ce"]!],
                                    days:2)
    }
    
    func getWomenDecathlon() -> AthleticsPointsEvent {
        return AthleticsPointsEvent(name: "Women Decathlon", events:
                                        [eventsDataObtainerAndHelper.athleticsEventsSearcher["100m_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["long_jump_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["shot_put_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["high_jump_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["400m_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["100mh_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["discus_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["pole_vault_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["javelin_f_ce"]!,
                                         eventsDataObtainerAndHelper.athleticsEventsSearcher["1500m_f_ce"]!],
                                    days:2)
    }
}


struct EventSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        EventSelectorView()
    }
}
