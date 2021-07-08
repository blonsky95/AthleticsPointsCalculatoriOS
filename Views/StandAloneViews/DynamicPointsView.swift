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

        ForEach((0...eventGroup.sMinNumberPerformancesGroup-1), id: \.self) {performanceNumber in
            Section {
                HStack{
                    VStack(alignment: .leading){
                                           
                        SingleEventScoreWAView(performanceIndex: performanceNumber, eventGroupPointsHolder: self.eventGroupPointsHolder)
                        
                        ZStack {
                            WindReadingView(windReading: $eventGroupPointsHolder.windReadings[performanceNumber], pointsModification: $eventGroupPointsHolder.windPointsModifications[performanceNumber])
                        }
//                        .highPriorityGesture(
//                                    TapGesture()
//                                        .onEnded { _ in
//                                            print("VStack tapped")
//                                        }
//                                )
                                               
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
                        //updates the binding state that is passed to single score view
                        eventGroupPointsHolder.updateSelectedAthleticEvents(changeIndex: newPickerIndex)
                    }
                }
            }
        }

    }
}

struct WindReadingView:View {
    
    private let headwind = "Headwind"
    private let tailwind = "Tailwind"
    
    @Binding var windReading:String
    @Binding var pointsModification:String
    @State var windDirection:String = "Headwind"
    
    let pointsPerUnitOfWind = 6.0
    var body: some View {
        HStack{
            Button(action: {
                //All i want is this button gesture to be run, not the picker in the form
            }) {
                Text(windDirection)
            }
            .highPriorityGesture(
                TapGesture()
                    .onEnded { _ in
                        if windDirection==tailwind {
                            windDirection=headwind
                        } else {
                            windDirection=tailwind
                        }
                        updatePointsModification()
                    }
            )
            
            CustomCenterTextField(value: $windReading, keyboardType: .decimalPad, defaultValue: "0.0")
                .onChange(of: windReading) { newWindReading in
                    if newWindReading.isEmpty {
                        pointsModification="0"
                    } else {
                        updatePointsModification()
                    }
                }
            Text(pointsModification)
        }
    }
    
    func updatePointsModification() {
        if var windReadingDouble = Double(windReading) {
            if windDirection==headwind{
                windReadingDouble=windReadingDouble * -1.0
            }
            if windReadingDouble<0.0 || windReadingDouble>2.0 {
                pointsModification=String(Int(floor(-windReadingDouble*pointsPerUnitOfWind)))
                print("points mod:\(String(Int(floor(-windReadingDouble*pointsPerUnitOfWind)))) ")
            } else {
                pointsModification="0"
            }
        }
    }
}


//struct DynamicPointsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DynamicPointsView(eventGroup: (EventGroup()))
//    }
//}
