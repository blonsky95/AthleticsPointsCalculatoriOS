//
//  DynamicPointsView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 18/6/21.
//

import SwiftUI

struct DynamicPointsView: View {
    
    @Binding var eventGroup: EventGroup
    
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State var selectedEventGroupEventIndexArray:[Int] = [0,0,0,0,0,0]
    @State var selectedEventGroupEventPerformance:[String] = ["0.0","0.0","0.0","0.0","0.0","0.0"]
    @State var selectedEventGroupEventPerformancePoints:[String] = ["0","0","0","0","0","0"]
    @State var selectedEventGroupEventPlacementPoints:[String] = ["0","0","0","0","0","0"]

    
    var body: some View {
        
        Section {
            HStack{
                VStack(alignment: .leading){
                    Text("Performance")
                    Text("Placement")
                    Text("Total points")
                }
                Spacer()
                Text ("Event selection")
            }
        }
        .font(Font.system(size: 16))
        .foregroundColor(.gray)
        .onChange(of: eventGroup) { newVal in
            resetFormFilling()
            print("reset form filling from DPV")
//            mainViewModel.resetEventGroupPointsHolder(numberOfPerformances: eventGroup.sMinNumberPerformancesGroup)
//            mainViewModel.updateEventGroupPointsHolderEventGroup(eGroup: eventGroup)
        }

        ForEach((0...eventGroup.sMinNumberPerformancesGroup-1), id: \.self) {performanceNumber in
            Section {
                HStack{
                    VStack(alignment: .leading){
                        
                        SingleEventScoreWAView(eventPerformance: $selectedEventGroupEventPerformance[performanceNumber], eventGroupArrayIndex: $selectedEventGroupEventIndexArray[performanceNumber])
                        
                        TextField(selectedEventGroupEventPlacementPoints[performanceNumber], text: $selectedEventGroupEventPlacementPoints[performanceNumber])
                            .fixedSize()
                            .keyboardType(.decimalPad)
                        .onChange(of: selectedEventGroupEventPlacementPoints) { newPlacPoints in
                            mainViewModel.updateEventGroupPointsHolderPlacemenetPoints(pointsArray: selectedEventGroupEventPlacementPoints)
                        }
                        
                        Text("Total: 0")

                    }
                    
                    Picker("", selection: $selectedEventGroupEventIndexArray[performanceNumber]) {
                        ForEach((0...eventGroup.getArrayOfAthleticEvents().count-1), id: \.self)  { athleticEventIndex in
                            Text(eventGroup.getArrayOfAthleticEvents()[athleticEventIndex].getIndoorDisplayName())
                        }
                    }
                    .onChange(of: selectedEventGroupEventIndexArray[performanceNumber]) { newPickerIndexArray in
                        print("new picker index for \(performanceNumber), new array: \(newPickerIndexArray)")
                        //updates the binding state that is passed to single score view
                        selectedEventGroupEventIndexArray[performanceNumber]=newPickerIndexArray
                        mainViewModel.updateEventGroupPointsHolderEventArray(index: newPickerIndexArray, performanceNumber: performanceNumber)
                    }
                }
            }
            
        }
}

    func resetFormFilling() {
        print("RESET TIME")
        selectedEventGroupEventIndexArray = [0,0,0,0,0,0]
        selectedEventGroupEventPerformance = ["0.0","0.0","0.0","0.0","0.0","0.0"]
        selectedEventGroupEventPerformancePoints = ["0","0","0","0","0","0"]
        selectedEventGroupEventPlacementPoints = ["0","0","0","0","0","0"]
    }
    
    struct SingleEventScoreWAView:View {

        @Binding var eventPerformance:String
        @Binding var eventGroupArrayIndex:Int
        
        @State private var eventPoints = 0
        @EnvironmentObject var mainViewModel : MainViewModel
        
        var body: some View {
            HStack{
                CustomCenterTextField(value: $eventPerformance)
                    .onChange(of: eventPerformance) { newValue in
                        updatePoints()
                        mainViewModel.updateEventGroupPointsHolderPerformance(index: eventGroupArrayIndex, performance: newValue)
                    }
                Text("\(eventPoints)")
                    .onChange(of: eventGroupArrayIndex) {newValue in
                        updatePoints()
                    }
            }
        }
        
        func updatePoints() {
            eventPoints=mainViewModel.getPointsForEvent(event: mainViewModel.getEventGroupAthleticsEventPerIndex(index: eventGroupArrayIndex), perf: eventPerformance.doubleValue)
        }
    }
}


//struct DynamicPointsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DynamicPointsView(eventGroup: (EventGroup()))
//    }
//}
