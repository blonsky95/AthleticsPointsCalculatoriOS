//
//  DynamicPointsView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 18/6/21.
//

import SwiftUI

struct DynamicPointsView: View {
    
    @Binding var eventGroup: EventGroup
    
//    @State var arrayOfEventGroupEvents:[AthleticsEvent] = []
    @EnvironmentObject var mainViewModel : MainViewModel
    @State var eventGroupPointsHolder:EventGroupPointsHolder = EventGroupPointsHolder()
    
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
            mainViewModel.resetEventGroupPointsHolder(numberOfPerformances: eventGroup.sMinNumberPerformancesGroup)
            print("view indexes resetted")
        }

        ForEach((0...eventGroup.sMinNumberPerformancesGroup-1), id: \.self) {performanceNumber in
            Section {
                HStack{
                    VStack(alignment: .leading){
                        
                        SingleEventScoreWAView(performance: "0.0", eventGroupArrayIndex: performanceNumber)
                        
                        TextField(selectedEventGroupEventPlacementPoints[performanceNumber], text: $selectedEventGroupEventPlacementPoints[performanceNumber])
                            .fixedSize()
                            .keyboardType(.decimalPad)
                        .onChange(of: selectedEventGroupEventPlacementPoints) { newPlacPoints in
                            mainViewModel.updateEventGroupPointsHolder(pointsArray: selectedEventGroupEventPlacementPoints)
                        }
                        
                        Text("Total: 0")
                        
                        
                    }
                    
                    Picker("", selection: $selectedEventGroupEventIndexArray[performanceNumber]) {
                        ForEach((0...eventGroup.getArrayOfAthleticEvents().count-1), id: \.self)  { athleticEventIndex in
                            Text(eventGroup.getArrayOfAthleticEvents()[athleticEventIndex].getIndoorDisplayName())
                        }
                    }
                    .onChange(of: selectedEventGroupEventIndexArray) { newPickerIndexArray in
                        mainViewModel.updateEventGroupPointsHolder(eventArrayPickerIndexes: newPickerIndexArray)
                    }
                }
            }
            
        }
   
    }
    
    func resetFormFilling() {
        
        selectedEventGroupEventIndexArray = [0,0,0,0,0,0]
        selectedEventGroupEventPerformance = ["0.0","0.0","0.0","0.0","0.0","0.0"]
        selectedEventGroupEventPerformancePoints = ["0","0","0","0","0","0"]
        selectedEventGroupEventPlacementPoints = ["0","0","0","0","0","0"]
    }
    
    struct SingleEventScoreWAView:View {
        
        //CONTINUE HERE - THE PARAMETERS ARE WRONG

//        let athleticsEvent:AthleticsEvent //the event
        let performance:String //performance, 0.0 if not a saved performance
        let eventGroupArrayIndex:Int
        
        @State private var eventPerformance:String = ""
        @State private var eventPoints = 0
        
        @EnvironmentObject var mainViewModel : MainViewModel

        var body: some View {
            HStack{
                CustomCenterTextField(value: $eventPerformance)
                    .onChange(of: eventPerformance) { newValue in
                        if mainViewModel.isEventGroupPointsHolderInit {
                            eventPoints=mainViewModel.getPointsForEvent(event: mainViewModel.getEventGroupAthleticsEventPerIndex(index: eventGroupArrayIndex), perf: eventPerformance.doubleValue)
                            mainViewModel.updateEventGroupPointsHolderPerformance(index: eventGroupArrayIndex, performance: newValue)
                        }

                    }
                Text("\(eventPoints)")
            }
            .onAppear{
                eventPerformance=performance
            }
        }

    }
    
}


//struct DynamicPointsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DynamicPointsView(eventGroup: (EventGroup()))
//    }
//}
