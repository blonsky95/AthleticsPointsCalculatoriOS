//
//  WAPointsCalculator.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 17/6/21.
//

import SwiftUI

struct WAPointsCalculator: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @State var titleOfSavedPerformance = "New points perfo"
    @State var selectedEventGroupIndex:Int = 0
    @State var selectedEventGroup: EventGroup
    @ObservedObject var eventGroupPointsHolder:EventGroupPointsHolder

    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false

    let sIsLoadingPerformance: Bool
    let wAPointsPerformance: WAPointsPerformance?
    
    init(isLoadingPerformance: Bool, initialEventGroup: EventGroup, pWAPointsPerformance:WAPointsPerformance? = nil ) {
        sIsLoadingPerformance = isLoadingPerformance
        wAPointsPerformance = pWAPointsPerformance
        
        //sets 100m or the saved event group
        _selectedEventGroup = State(initialValue: initialEventGroup)

        eventGroupPointsHolder = EventGroupPointsHolder()
        
        if sIsLoadingPerformance {
            //loads the eventgroup to the eventGroupPointsHolder
            eventGroupPointsHolder.loadDataFromPerformance(pointsPerf: wAPointsPerformance!)
            //loads index of event group
            selectedEventGroupIndex =  EventsDataObtainerAndHelper.shared.getIndexOfEventGroup(pEventGroup: eventGroupPointsHolder.eventGroup)
            //loads title as initial state value
            _titleOfSavedPerformance = State(initialValue: eventGroupPointsHolder.performanceTitle)
        } else {
            //is a new, so reset with 100m as event group
            eventGroupPointsHolder.resetEventGroupPointsHolderEventGroup(newEventGroup: selectedEventGroup)
        }   
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
//                            print("change in selectedEventGroupIndex to newIndex: \(newIndex)")
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
                    DynamicPointsView(eventGroup: selectedEventGroup, eventGroupPointsHolder: eventGroupPointsHolder)
                }
            }
            HStack{
                Text("Average:")
                Spacer()
                Text("\(eventGroupPointsHolder.getAverage())")
            }.padding()
            Button("Save") {
                saveButtonPressed()
            }.padding()
            
        }
        .alert(isPresented: $showingAlert, content: getAlert)
        .onAppear{
//            if sIsLoadingPerformance {
//                eventGroupPointsHolder.loadDataFromPerformance(pointsPerf: wAPointsPerformance!)
////                selectedEventGroup = eventGroupPointsHolder.eventGroup
//                selectedEventGroupIndex =  EventsDataObtainerAndHelper.shared.getIndexOfEventGroup(pEventGroup: eventGroupPointsHolder.eventGroup)
//                titleOfSavedPerformance = eventGroupPointsHolder.performanceTitle
//            } else {
////                print("not loading from wap7oints")
////                selectedEventGroup = EventsDataObtainerAndHelper.shared.allEventGroups[0]
//            }
            
                              
        }
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
        if sIsLoadingPerformance {
            if wAPointsPerformance!.wrappedPerformanceTitle != titleOfSavedPerformance {
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
        mainViewModel.createWAPointsPerformance(cHolder: eventGroupPointsHolder, pTitleOfNewPerformance: titleOfSavedPerformance)
        presentationMode.wrappedValue.dismiss()
    }

    func updateUserSavedPerformance() {
        mainViewModel.updateWAPointsPerformance(pWAPointsPerformance: wAPointsPerformance!, cHolder: eventGroupPointsHolder, pTitleOfNewPerformance: titleOfSavedPerformance)
        presentationMode.wrappedValue.dismiss()
    }
}



//struct WAPointsCalculator_Previews: PreviewProvider {
//    static var previews: some View {
//        WAPointsCalculator()
//    }
//}
