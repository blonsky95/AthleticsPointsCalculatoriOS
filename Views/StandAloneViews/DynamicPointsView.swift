//
//  DynamicPointsView.swift
//  AthleticsPointsCalculator
//
//  Created by Mar Garcia on 18/6/21.
//

import Combine
import SwiftUI

struct DynamicPointsView: View {
    
    @Binding var eventGroup: EventGroup
    
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @ObservedObject var eventGroupPointsHolder:EventGroupPointsHolder

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
//        .onChange(of: eventGroup) { newVal in
//            resetFormFilling()
//            print("new event group: \(eventGroup.sName) and minPerfs \(eventGroup.sMinNumberPerformancesGroup)")
//        }

        ForEach((0...eventGroup.sMinNumberPerformancesGroup-1), id: \.self) {performanceNumber in
            Section {
                HStack{
                    VStack(alignment: .leading){
                                           
                        SingleEventScoreWAView(performanceIndex: performanceNumber, eventGroupPointsHolder: self.eventGroupPointsHolder)
                        
                        TextField(eventGroupPointsHolder.eventPlacementPoints[performanceNumber], text: $eventGroupPointsHolder.eventPlacementPoints[performanceNumber])
                            .fixedSize()
                            .keyboardType(.decimalPad)
                        
                        Text("Total: \(eventGroupPointsHolder.getTotalPoints(performanceIndex: performanceNumber))")

                    }
                    
                    Picker("", selection: $eventGroupPointsHolder.selectedEventIndexesArray[performanceNumber]) {
                        ForEach((0...eventGroup.getArrayOfAthleticEvents().count-1), id: \.self)  { athleticEventIndex in
                            Text(eventGroup.getArrayOfAthleticEvents()[athleticEventIndex].getIndoorDisplayName())
                        }
                    }
                    .onChange(of: eventGroupPointsHolder.selectedEventIndexesArray[performanceNumber]) { newPickerIndex in
                        print("new picker index for \(performanceNumber), new array: \(newPickerIndex)")
                        //updates the binding state that is passed to single score view
                        eventGroupPointsHolder.updateSelectedAthleticEvents(changeIndex: newPickerIndex)
                    }
                }
            }
        }

    }
}


//struct DynamicPointsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DynamicPointsView(eventGroup: (EventGroup()))
//    }
//}
