//
//  ContentView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 12/3/21.
//

import SwiftUI
import CoreData


struct EventSelectorView: View {
            
//    @EnvironmentObject var eventsDataObtainerAndHelper: EventsDataObtainerAndHelper
    @EnvironmentObject var mainViewModel : MainViewModel

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
                        NavigationLink(destination: CalculatorView(athleticPointsEvent:mainViewModel.getWomenOutdoorHeptathlon(), userSavedPerformance: nil))
                        {
                            Text("Heptathlon")
                        }
                        NavigationLink(destination: CalculatorView(athleticPointsEvent:  mainViewModel.getWomenIndoorPentathlon(), userSavedPerformance: nil))
                        {
                            Text("Pentathlon (indoor)")
                        }
                        NavigationLink(destination: CalculatorView(athleticPointsEvent:  mainViewModel.getWomenDecathlon(), userSavedPerformance: nil)) {
                            Text("Decathlon")
                        }
                        .padding(.bottom)
                    }
                    
                    Group
                    {
                        Text("Men Combined Events")
                            .font(.title)
                            .padding(.bottom)
                        NavigationLink(destination: CalculatorView(athleticPointsEvent:  mainViewModel.getMenDecathlon(), userSavedPerformance: nil)) {
                            Text("Decathlon")
                        }
                        NavigationLink(destination: CalculatorView(athleticPointsEvent: mainViewModel.getMenHeptathlon(), userSavedPerformance: nil)) {
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
                            NavigationLink(destination: CalculatorView(athleticPointsEvent: mainViewModel.getMaleOutdoorSingleEvent(index: selectedMaleOutdoorEventIndex), userSavedPerformance: nil)) {
                                Text("Go")
                            }
                        }
                        CustomEventPicker(selectedSingleEventIndex: $selectedMaleOutdoorEventIndex , arrayOfEvents: mainViewModel.eventsDataObtainerAndHelper.maleOutdoorSingleEvents, pickerTitle: "")

                        HStack {
                            Text("Women outdoor")
                                .font(.title3)
                            Spacer()
                            NavigationLink(destination: CalculatorView(athleticPointsEvent: mainViewModel.getFemaleOutdoorSingleEvent(index: selectedFemaleOutdoorEventIndex), userSavedPerformance: nil)) {
                                Text("Go")
                            }
                        }
                        CustomEventPicker(selectedSingleEventIndex: $selectedFemaleOutdoorEventIndex , arrayOfEvents: mainViewModel.eventsDataObtainerAndHelper.femaleOutdoorSingleEvents, pickerTitle: "")

                        
                        
                        HStack {
                            Text("Men indoor")
                                .font(.title3)
                            Spacer()
                            NavigationLink(destination: CalculatorView(athleticPointsEvent: mainViewModel.getMaleIndoorSingleEvent(index: selectedMaleIndoorEventIndex), userSavedPerformance: nil)) {
                                Text("Go")
                            }
                        }
                        CustomEventPicker(selectedSingleEventIndex: $selectedMaleIndoorEventIndex , arrayOfEvents: mainViewModel.eventsDataObtainerAndHelper.maleIndoorSingleEvents, pickerTitle: "")

                        HStack {
                            Text("Women indoor")
                                .font(.title3)
                            Spacer()
                            NavigationLink(destination: CalculatorView(athleticPointsEvent: mainViewModel.getFemaleIndoorSingleEvent(index: selectedFemaleIndoorEventIndex), userSavedPerformance: nil)) {
                                Text("Go")
                            }
                        }
                        CustomEventPicker(selectedSingleEventIndex: $selectedFemaleIndoorEventIndex, arrayOfEvents: mainViewModel.eventsDataObtainerAndHelper.femaleIndoorSingleEvents, pickerTitle: "")
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
