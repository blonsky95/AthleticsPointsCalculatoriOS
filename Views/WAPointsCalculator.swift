//
//  WAPointsCalculator.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 17/6/21.
//

import SwiftUI

struct WAPointsCalculator: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @State private var titleOfSavedPerformance = "New points performance"
    @State var selectedEventGroupIndex:Int = 0
    @State var selectedEventGroup: EventGroup
    
    init() {
        _selectedEventGroup = State(initialValue: EventsDataObtainerAndHelper().allEventGroups[0])
    }

    var body: some View {
        VStack {
            Form{
                Section {
                    TextField(titleOfSavedPerformance, text: $titleOfSavedPerformance)
                        .font(.title)
                        .padding(.bottom)
                    CustomEventGroupPicker(selectedEventGroupIndex: $selectedEventGroupIndex, arrayOfEventGroups: mainViewModel.eventsDataObtainerAndHelper.allEventGroups)
                        .onChange(of: selectedEventGroupIndex) {newIndex in
                            print("change in selectedEventGroupIndex to newIndex: \(newIndex)")
                            selectedEventGroup=mainViewModel.getEventGroup(index: newIndex)
                        }
                    Text("Includes: \(selectedEventGroup.getListOfSimilarEvents())")
                }
                Section {
                    Text("Minimum performances for event group: \(selectedEventGroup.sMinNumberPerformancesGroup)")
                    Text("Minimum performances for main event: \(selectedEventGroup.sMinNumberPerformancesMainEvent)")
                }
                Section {
                    DynamicPointsView(eventGroup: $selectedEventGroup)
                        .onChange(of: selectedEventGroup) {newGroup in
                            print("Change outside to: \(newGroup.sName)")
                            
                        }
                }
            }            
        }
    }
}

struct WAPointsCalculator_Previews: PreviewProvider {
    static var previews: some View {
        WAPointsCalculator()
    }
}
