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
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var eventGroupPointsHolder:EventGroupPointsHolder
    let sIsLoadingPerformance: Bool
    
    init(eventGroupPointsHolder:EventGroupPointsHolder, isLoadingPerformance: Bool) {
        sIsLoadingPerformance = isLoadingPerformance
        _selectedEventGroup = State(initialValue: EventsDataObtainerAndHelper().allEventGroups[0])
        self.eventGroupPointsHolder = eventGroupPointsHolder
        eventGroupPointsHolder.resetEventGroupPointsHolderEventGroup(newEventGroup: EventsDataObtainerAndHelper().allEventGroups[0])
        print("wapoints init OOO")
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
                            eventGroupPointsHolder.resetEventGroupPointsHolderEventGroup(newEventGroup: selectedEventGroup)
                        }
                    Text("Includes: \(selectedEventGroup.getListOfSimilarEvents())")
                }
                Section {
                    Text("Minimum performances for event group: \(selectedEventGroup.sMinNumberPerformancesGroup)")
                    Text("Minimum performances for main event: \(selectedEventGroup.sMinNumberPerformancesMainEvent)")
                }
                Section {
                    DynamicPointsView(eventGroup: $selectedEventGroup, eventGroupPointsHolder: eventGroupPointsHolder)
                }
            }
            HStack{
                Text("Average:")
                Spacer()
                Text("\(eventGroupPointsHolder.getAverage())")
            }.padding()
            Button("Save") {
                mainViewModel.createWAPointsPerformance(cHolder: eventGroupPointsHolder, titleOfNewPerformance: titleOfSavedPerformance)
                presentationMode.wrappedValue.dismiss()

            }.padding()
            
        }
    }
    
}

//struct WAPointsCalculator_Previews: PreviewProvider {
//    static var previews: some View {
//        WAPointsCalculator()
//    }
//}
