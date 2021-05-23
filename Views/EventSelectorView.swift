//
//  ContentView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 12/3/21.
//

import SwiftUI
import CoreData


struct EventSelectorView: View {
        
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
                        NavigationLink(destination: CalculatorView(athleticPointsEvent: eventsDataObtainerAndHelper.getCombinedEventsAthleticsPointEvent(eventKey: EventsDataObtainerAndHelper.CombinedEventsKeys.womenOutdoorHeptathlon), userSavedPerformance: nil).environmentObject(eventsDataObtainerAndHelper)) {
                            Text("Heptathlon")
                        }
                        NavigationLink(destination: CalculatorView(athleticPointsEvent:  eventsDataObtainerAndHelper.getCombinedEventsAthleticsPointEvent(eventKey: EventsDataObtainerAndHelper.CombinedEventsKeys.womenIndoorPentathlon), userSavedPerformance: nil).environmentObject(eventsDataObtainerAndHelper)) {
                            Text("Pentathlon (indoor)")
                        }
                        NavigationLink(destination: CalculatorView(athleticPointsEvent:  eventsDataObtainerAndHelper.getCombinedEventsAthleticsPointEvent(eventKey: EventsDataObtainerAndHelper.CombinedEventsKeys.womenOutdoorDecathlon), userSavedPerformance: nil).environmentObject(eventsDataObtainerAndHelper)) {
                            Text("Decathlon")
                        }
                        .padding(.bottom)
                    }
                    
                    Group
                    {
                        Text("Men Combined Events")
                            .font(.title)
                            .padding(.bottom)
                        NavigationLink(destination: CalculatorView(athleticPointsEvent:  eventsDataObtainerAndHelper.getCombinedEventsAthleticsPointEvent(eventKey: EventsDataObtainerAndHelper.CombinedEventsKeys.menOutdoorDecathlon), userSavedPerformance: nil).environmentObject(eventsDataObtainerAndHelper)) {
                            Text("Decathlon")
                        }
                        NavigationLink(destination: CalculatorView(athleticPointsEvent: eventsDataObtainerAndHelper.getCombinedEventsAthleticsPointEvent(eventKey: EventsDataObtainerAndHelper.CombinedEventsKeys.menIndoorHeptathlon), userSavedPerformance: nil).environmentObject(eventsDataObtainerAndHelper)) {
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
            .navigationTitle("Event Selector")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct EventSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        EventSelectorView()
    }
}
